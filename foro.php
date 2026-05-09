<?php
session_start();
require_once 'db.php';
require_once 'auth.php';

$is_logged = isset($_SESSION['user_id']);
$username  = $_SESSION['username'] ?? 'Guest';
$rol = isset($_SESSION['rol']) ? (int)$_SESSION['rol'] : 0;
$userId = isset($_SESSION['user_id']) ? (int)$_SESSION['user_id'] : 0;

if (!$is_logged) {
    header("Location: login.php");
    exit();
}

$retoId = isset($_GET['id']) ? (int)$_GET['id'] : 0;

if ($retoId <= 0) {
    $_SESSION['flash_error'] = 'Máquina no válida.';
    header("Location: start.php");
    exit();
}


$stmtReto = $conn->prepare("
    SELECT 
        r.id,
        r.titulo,
        r.descripcion,
        r.puntos,
        r.dificultad,
        r.activo,
        r.tipo_entorno,
        c.nombre AS categoria
    FROM retos r
    INNER JOIN categorias c ON c.id = r.categoria_id
    WHERE r.id = ?
    LIMIT 1
");

if (!$stmtReto) {
    die("Error al preparar la consulta del reto: " . $conn->error);
}

$stmtReto->bind_param("i", $retoId);
$stmtReto->execute();
$resultReto = $stmtReto->get_result();
$reto = $resultReto->fetch_assoc();
$stmtReto->close();

if (!$reto) {
    $_SESSION['flash_error'] = 'La máquina no existe.';
    header("Location: start.php");
    exit();
}


if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['nuevo_comentario'])) {
    $comentario = trim($_POST['comentario'] ?? '');

    if ($comentario === '') {
        $_SESSION['flash_error'] = 'El comentario no puede estar vacío.';
        header("Location: foro.php?id=" . $retoId);
        exit();
    }

    if (mb_strlen($comentario) > 2000) {
        $_SESSION['flash_error'] = 'El comentario es demasiado largo.';
        header("Location: foro.php?id=" . $retoId);
        exit();
    }

    $stmtInsert = $conn->prepare("
        INSERT INTO foro_retos (
            reto_id,
            usuario_id,
            username,
            comentario
        ) VALUES (?, ?, ?, ?)
    ");

    if (!$stmtInsert) {
        $_SESSION['flash_error'] = 'Error al preparar el comentario.';
        header("Location: foro.php?id=" . $retoId);
        exit();
    }

    $stmtInsert->bind_param("iiss", $retoId, $userId, $username, $comentario);

    if ($stmtInsert->execute()) {
        $_SESSION['flash_success'] = 'Comentario publicado correctamente.';
    } else {
        $_SESSION['flash_error'] = 'No se pudo publicar el comentario.';
    }

    $stmtInsert->close();

    header("Location: foro.php?id=" . $retoId);
    exit();
}


if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['eliminar_comentario'])) {
    $comentarioId = isset($_POST['comentario_id']) ? (int)$_POST['comentario_id'] : 0;

    if ($comentarioId > 0) {
        if ($rol === 1) {
            $stmtDelete = $conn->prepare("
                DELETE FROM foro_retos
                WHERE id = ? AND reto_id = ?
            ");
            $stmtDelete->bind_param("ii", $comentarioId, $retoId);
        } else {
            $stmtDelete = $conn->prepare("
                DELETE FROM foro_retos
                WHERE id = ? AND reto_id = ? AND usuario_id = ?
            ");
            $stmtDelete->bind_param("iii", $comentarioId, $retoId, $userId);
        }

        if ($stmtDelete && $stmtDelete->execute()) {
            $_SESSION['flash_success'] = 'Comentario eliminado.';
        } else {
            $_SESSION['flash_error'] = 'No se pudo eliminar el comentario.';
        }

        if ($stmtDelete) {
            $stmtDelete->close();
        }
    }

    header("Location: foro.php?id=" . $retoId);
    exit();
}


$stmtComentarios = $conn->prepare("
    SELECT 
        id,
        usuario_id,
        username,
        comentario,
        creado_en
    FROM foro_retos
    WHERE reto_id = ?
    ORDER BY creado_en DESC
");

if (!$stmtComentarios) {
    die("Error al preparar los comentarios: " . $conn->error);
}

$stmtComentarios->bind_param("i", $retoId);
$stmtComentarios->execute();
$resultComentarios = $stmtComentarios->get_result();

$comentarios = [];
while ($fila = $resultComentarios->fetch_assoc()) {
    $comentarios[] = $fila;
}

$stmtComentarios->close();

$difClass = "yellow";
if ($reto["dificultad"] === "Fácil") $difClass = "green";
if ($reto["dificultad"] === "Difícil") $difClass = "red";
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ROOT ME - Foro</title>
  <link rel="stylesheet" href="style.css">

  <style>
    .page-wrap{max-width:1100px;margin:0 auto;padding:24px;}
    .page-title{color:#fff;font-size:34px;margin:10px 0 6px;}
    .page-sub{color:#b9b9b9;margin:0 0 18px;}

    .section-title{
      color:#fff;
      font-size:24px;
      margin:28px 0 14px;
      padding-bottom:8px;
      border-bottom:1px solid #222;
    }

    .card{
      background:#0f0f0f;
      border:1px solid #222;
      border-radius:14px;
      padding:16px;
      margin-bottom:14px;
    }

    .card-top{
      display:flex;
      justify-content:space-between;
      align-items:flex-start;
      gap:12px;
    }

    .title{color:#fff;font-size:18px;margin:0;}
    .meta{color:#b9b9b9;margin:8px 0 10px;font-size:13px;line-height:1.4;}

    .row{display:flex; gap:10px; flex-wrap:wrap; margin-bottom:12px;}

    .pill{
      font-size:12px;
      padding:6px 10px;
      border-radius:10px;
      border:1px solid #2b2b2b;
      color:#eaeaea;
      background:#0b0b0b;
    }

    .pill.red{border-color:#d32f2f;color:#ff7a7a;}
    .pill.yellow{border-color:#c9a227;color:#ffe082;}
    .pill.green{border-color:#2e7d32;color:#7CFC90;}
    .pill.blue{border-color:#1976d2;color:#8ec5ff;}
    .pill.gray{border-color:#666;color:#cfcfcf;}

    .badge{
      font-size:12px;
      padding:6px 10px;
      border-radius:999px;
      border:1px solid #2b2b2b;
      color:#cfcfcf;
      background:#0b0b0b;
      white-space:nowrap;
    }

    .badge.live{border-color:#1976d2;color:#8ec5ff;}
    .badge.retired{border-color:#666;color:#bdbdbd;}

    .btn-open{
      display:inline-block;
      text-decoration:none;
      padding:10px 12px;
      border-radius:10px;
      background:transparent;
      cursor:pointer;
      font-size:14px;
      border:1px solid #fff;
      color:#fff;
    }

    .btn-open:hover{filter:brightness(1.08);}

    .btn-red{
      display:inline-block;
      text-decoration:none;
      padding:10px 12px;
      border-radius:10px;
      background:transparent;
      cursor:pointer;
      font-size:14px;
      border:1px solid #d32f2f;
      color:#d32f2f;
    }

    .btn-red:hover{filter:brightness(1.08);}

    .foro-form{
      background:#0f0f0f;
      border:1px solid #222;
      border-radius:14px;
      padding:16px;
      margin-bottom:18px;
    }

    .foro-form textarea{
      width:100%;
      min-height:130px;
      resize:vertical;
      background:#0b0b0b;
      border:1px solid #2b2b2b;
      color:#fff;
      padding:12px;
      border-radius:10px;
      outline:none;
      box-sizing:border-box;
      margin-bottom:12px;
      font-size:14px;
    }

    .foro-actions{
      display:flex;
      justify-content:space-between;
      align-items:center;
      gap:10px;
      flex-wrap:wrap;
    }

    .comment-head{
      display:flex;
      justify-content:space-between;
      align-items:flex-start;
      gap:12px;
      margin-bottom:10px;
    }

    .comment-user{
      color:#EBFF00;
      font-size:14px;
      margin:0;
    }

    .comment-date{
      color:#777;
      font-size:12px;
      margin:0;
    }

    .comment-text{
      color:#eaeaea;
      font-size:14px;
      line-height:1.5;
      white-space:pre-wrap;
      margin:0;
    }

    .comment-delete{
      background:transparent;
      border:1px solid #d32f2f;
      color:#d32f2f;
      border-radius:10px;
      padding:7px 10px;
      cursor:pointer;
      font-size:12px;
    }

    .empty{
      color:#b9b9b9;
      border:1px dashed #333;
      border-radius:12px;
      padding:18px;
      text-align:center;
    }

    .alert-success{
      background:#0f0f0f;
      border:1px solid #2e7d32;
      color:#7CFC90;
      padding:12px 14px;
      border-radius:12px;
      margin:14px 0;
    }

    .alert-error{
      background:#0f0f0f;
      border:1px solid #d32f2f;
      color:#ff7a7a;
      padding:12px 14px;
      border-radius:12px;
      margin:14px 0;
    }
  </style>
</head>
<body>

  <nav>
    <a href="index.php"><div class="logo">>_ root<span>me</span></div></a>
    <div class="nav-links">
      <a href="academia.php">Academia</a>
      <a href="ranking.php">Ranking</a>

      <?php if ($is_logged): ?>
        <?php if ($rol === 1): ?>
          <a href="admin_dashboard.php" style="color:#EBFF00; margin-left:20px; text-decoration:none;">[ <?php echo htmlspecialchars($username); ?> ]</a>
        <?php else: ?>
          <span style="color:#EBFF00; margin-left:20px;">[ <?php echo htmlspecialchars($username); ?> ]</span>
        <?php endif; ?>
        <a href="logout.php" class="btn-login2" style="border-color:#FF0000 !important; color:#FF0000 !important;">LOGOUT</a>
      <?php else: ?>
        <a href="logout.php" class="btn-login2">LOGOUT</a>
      <?php endif; ?>
    </div>
  </nav>

  <div class="page-wrap">

    <h1 class="page-title">Foro de máquina</h1>
    <p class="page-sub">Comentarios y dudas asociadas únicamente a esta máquina.</p>

    <?php if (!empty($_SESSION['flash_success'])): ?>
      <div class="alert-success">
        <?php
          echo htmlspecialchars($_SESSION['flash_success']);
          unset($_SESSION['flash_success']);
        ?>
      </div>
    <?php endif; ?>

    <?php if (!empty($_SESSION['flash_error'])): ?>
      <div class="alert-error">
        <?php
          echo htmlspecialchars($_SESSION['flash_error']);
          unset($_SESSION['flash_error']);
        ?>
      </div>
    <?php endif; ?>

    <div class="card">
      <div class="card-top">
        <h3 class="title"><?php echo htmlspecialchars($reto["titulo"]); ?></h3>

        <?php if ((int)$reto["activo"] === 1): ?>
          <span class="badge live">Activa</span>
        <?php else: ?>
          <span class="badge retired">Retirada</span>
        <?php endif; ?>
      </div>

      <p class="meta"><?php echo htmlspecialchars($reto["descripcion"]); ?></p>

      <div class="row">
        <span class="pill"><?php echo htmlspecialchars($reto["categoria"]); ?></span>
        <span class="pill <?php echo $difClass; ?>"><?php echo htmlspecialchars($reto["dificultad"]); ?></span>
        <span class="pill"><?php echo (int)$reto["puntos"]; ?> pts</span>
        <span class="pill blue"><?php echo htmlspecialchars($reto["tipo_entorno"]); ?></span>
        <span class="pill gray">Máquina #<?php echo (int)$reto["id"]; ?></span>
      </div>

      <a href="start.php" class="btn-open">Volver a máquinas</a>
    </div>

    <h2 class="section-title">Escribir comentario</h2>

    <form class="foro-form" method="POST" action="foro.php?id=<?php echo (int)$retoId; ?>">
      <textarea name="comentario" placeholder="Escribe tu comentario, duda o pista..." required></textarea>

      <div class="foro-actions">
        <span style="color:#777; font-size:12px;">Publicado como <?php echo htmlspecialchars($username); ?></span>
        <button type="submit" name="nuevo_comentario" class="btn-red">Publicar comentario</button>
      </div>
    </form>

    <h2 class="section-title">Comentarios</h2>

    <?php if (count($comentarios) === 0): ?>
      <div class="empty">Todavía no hay comentarios en esta máquina.</div>
    <?php else: ?>
      <?php foreach ($comentarios as $comentario): ?>
        <div class="card">
          <div class="comment-head">
            <div>
              <p class="comment-user">
                <?php echo htmlspecialchars($comentario["username"]); ?>
              </p>
              <p class="comment-date">
                <?php echo htmlspecialchars(date("d/m/Y H:i", strtotime($comentario["creado_en"]))); ?>
              </p>
            </div>

            <?php if ($rol === 1 || (int)$comentario["usuario_id"] === $userId): ?>
              <form method="POST" action="foro.php?id=<?php echo (int)$retoId; ?>" onsubmit="return confirm('¿Eliminar este comentario?');">
                <input type="hidden" name="comentario_id" value="<?php echo (int)$comentario["id"]; ?>">
                <button type="submit" name="eliminar_comentario" class="comment-delete">Eliminar</button>
              </form>
            <?php endif; ?>
          </div>

          <p class="comment-text"><?php echo htmlspecialchars($comentario["comentario"]); ?></p>
        </div>
      <?php endforeach; ?>
    <?php endif; ?>

  </div>

  <footer>
    root@server:~$ sudo shutdown -h now
  </footer>

</body>
</html>
