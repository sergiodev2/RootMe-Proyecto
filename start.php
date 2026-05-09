<?php
session_start();
require_once 'db.php';
require_once 'auth.php';

$is_logged = isset($_SESSION['user_id']);
$username  = $_SESSION['username'] ?? 'Guest';
$rol = isset($_SESSION['rol']) ? (int)$_SESSION['rol'] : 0;
$userId = isset($_SESSION['user_id']) ? (int)$_SESSION['user_id'] : 0;

$cooldownRestante = 0;

if ($is_logged) {
    $sqlCooldown = "SELECT ultima_apertura FROM cooldown_conexiones WHERE id_usuario = ? LIMIT 1";
    $stmtCooldown = $conn->prepare($sqlCooldown);

    if ($stmtCooldown) {
        $stmtCooldown->bind_param("i", $userId);
        $stmtCooldown->execute();
        $resultCooldown = $stmtCooldown->get_result();
        $filaCooldown = $resultCooldown->fetch_assoc();
        $stmtCooldown->close();

        if ($filaCooldown) {
            $ultimo = strtotime($filaCooldown['ultima_apertura']);
            $diferencia = time() - $ultimo;

            if ($diferencia < 60) {
                $cooldownRestante = 60 - $diferencia;
            }
        }
    }
}


if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['crear_reto']) && $rol === 1) {
    $titulo = trim($_POST['titulo'] ?? '');
    $descripcion = trim($_POST['descripcion'] ?? '');
    $puntos = (int)($_POST['puntos'] ?? 0);
    $dificultad = trim($_POST['dificultad'] ?? '');
    $categoria_id = (int)($_POST['categoria_id'] ?? 0);
    $activo = isset($_POST['activo']) ? (int)$_POST['activo'] : 1;
    $tipo_entorno = trim($_POST['tipo_entorno'] ?? 'guacamole');
    $maquina_url = trim($_POST['maquina_url'] ?? '');
    $archivo_descarga = trim($_POST['archivo_descarga'] ?? '');
    $flag = trim($_POST['flag'] ?? '');

    if ($titulo === '' || $descripcion === '' || $categoria_id <= 0) {
        $_SESSION['flash_error'] = 'Completa título, descripción y categoría.';
        header("Location: start.php");
        exit();
    }

    if (!in_array($dificultad, ['Fácil', 'Media', 'Difícil'], true)) {
        $_SESSION['flash_error'] = 'Dificultad no válida.';
        header("Location: start.php");
        exit();
    }

    if (!in_array($tipo_entorno, ['guacamole', 'descargable'], true)) {
        $_SESSION['flash_error'] = 'Tipo de entorno no válido.';
        header("Location: start.php");
        exit();
    }

    if ($activo === 1 && $flag === '') {
        $_SESSION['flash_error'] = 'Las máquinas activas deben tener flag.';
        header("Location: start.php");
        exit();
    }

    if ($tipo_entorno === 'guacamole' && $maquina_url === '') {
        $_SESSION['flash_error'] = 'Debes indicar la URL de la máquina para entorno Guacamole.';
        header("Location: start.php");
        exit();
    }

    if ($tipo_entorno === 'descargable' && $archivo_descarga === '') {
        $_SESSION['flash_error'] = 'Debes indicar la ruta de descarga para entorno descargable.';
        header("Location: start.php");
        exit();
    }

    $flag_db = null;
    if ($activo === 1 && $flag !== '') {
        $flag_db = $flag;
    }

    $maquina_url_db = ($tipo_entorno === 'guacamole') ? $maquina_url : null;
    $archivo_descarga_db = ($tipo_entorno === 'descargable') ? $archivo_descarga : null;

    $stmtInsert = $conn->prepare("
        INSERT INTO retos (
            titulo,
            descripcion,
            puntos,
            dificultad,
            categoria_id,
            flag,
            activo,
            tipo_entorno,
            maquina_url,
            archivo_descarga
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ");

    if (!$stmtInsert) {
        $_SESSION['flash_error'] = 'Error al preparar el alta del reto: ' . $conn->error;
        header("Location: start.php");
        exit();
    }

    $stmtInsert->bind_param(
        "ssisisssss",
        $titulo,
        $descripcion,
        $puntos,
        $dificultad,
        $categoria_id,
        $flag_db,
        $activo,
        $tipo_entorno,
        $maquina_url_db,
        $archivo_descarga_db
    );

    if ($stmtInsert->execute()) {
        $_SESSION['flash_success'] = 'Reto creado correctamente.';
    } else {
        $_SESSION['flash_error'] = 'Error al crear el reto.';
    }

    header("Location: start.php");
    exit();
}

$cat = $_GET["cat"] ?? "Todos";
$dif = $_GET["dif"] ?? "Todas";
$q   = trim($_GET["q"] ?? "");


$categorias = ["Todos"];
$categoriasReto = [];

$sqlCategorias = "SELECT id, nombre FROM categorias ORDER BY nombre ASC";
$resultCategorias = $conn->query($sqlCategorias);

if ($resultCategorias && $resultCategorias->num_rows > 0) {
    while ($filaCat = $resultCategorias->fetch_assoc()) {
        $categorias[] = $filaCat['nombre'];
        $categoriasReto[] = $filaCat;
    }
}

$dificultades = ["Todas", "Fácil", "Media", "Difícil"];


$sql = "
    SELECT
        r.id,
        r.titulo,
        r.descripcion,
        r.puntos,
        r.dificultad,
        r.activo,
        r.tipo_entorno,
        r.maquina_url,
        r.archivo_descarga,
        c.nombre AS categoria,
        CASE
            WHEN s.usuario_id IS NOT NULL THEN 1
            ELSE 0
        END AS resuelto
    FROM retos r
    INNER JOIN categorias c ON c.id = r.categoria_id
    LEFT JOIN solves s ON s.reto_id = r.id AND s.usuario_id = ?
    WHERE 1=1
";

$types = "i";
$params = [$userId];

if ($cat !== "Todos") {
    $sql .= " AND c.nombre = ? ";
    $types .= "s";
    $params[] = $cat;
}

if ($dif !== "Todas") {
    $sql .= " AND r.dificultad = ? ";
    $types .= "s";
    $params[] = $dif;
}

if ($q !== "") {
    $sql .= " AND (r.titulo LIKE ? OR r.descripcion LIKE ?) ";
    $types .= "ss";
    $busqueda = "%{$q}%";
    $params[] = $busqueda;
    $params[] = $busqueda;
}

$sql .= " ORDER BY r.activo DESC, r.id ASC ";

$stmt = $conn->prepare($sql);

if (!$stmt) {
    die("Error al preparar la consulta: " . $conn->error);
}

$stmt->bind_param($types, ...$params);
$stmt->execute();
$result = $stmt->get_result();

$retos = [];
while ($fila = $result->fetch_assoc()) {
    $retos[] = $fila;
}

$retosActivos = array_filter($retos, function ($reto) {
    return (int)$reto['activo'] === 1;
});

$retosRetirados = array_filter($retos, function ($reto) {
    return (int)$reto['activo'] === 0;
});
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>ROOT ME - Máquinas</title>
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

    .filters{
      display:flex; gap:12px; flex-wrap:wrap;
      background:#0f0f0f; border:1px solid #222; border-radius:12px;
      padding:14px; margin:18px 0 22px;
    }
    .filters input, .filters select, .filters textarea{
      background:#0b0b0b; border:1px solid #2b2b2b; color:#eaeaea;
      padding:10px 12px; border-radius:10px; outline:none;
      font-size:14px;
    }
    .filters .btn{
      padding:10px 14px; border-radius:10px; border:1px solid #d32f2f;
      background:transparent; color:#d32f2f; cursor:pointer;
      text-decoration:none; display:inline-flex; align-items:center;
    }
    .filters .btn:hover{filter:brightness(1.1);}

    .admin-panel{
      background:#0f0f0f;
      border:1px solid #222;
      border-radius:14px;
      padding:18px;
      margin:0 0 24px;
    }

    .admin-grid{
      display:grid;
      grid-template-columns:repeat(auto-fit, minmax(220px, 1fr));
      gap:12px;
    }

    .admin-grid textarea{
      min-height:120px;
      resize:vertical;
      grid-column:1 / -1;
    }

    .admin-actions{
      display:flex;
      gap:10px;
      flex-wrap:wrap;
      margin-top:14px;
    }

    .admin-title{
      color:#fff;
      font-size:20px;
      margin:0 0 14px;
    }

    .grid{
      display:grid;
      grid-template-columns:repeat(auto-fit, minmax(260px, 1fr));
      gap:14px;
    }

    .card{
      background:#0f0f0f; border:1px solid #222; border-radius:14px;
      padding:16px;
    }

    .card-top{display:flex; justify-content:space-between; align-items:flex-start; gap:12px;}

    .badge{
      font-size:12px; padding:6px 10px; border-radius:999px;
      border:1px solid #2b2b2b; color:#cfcfcf;
      background:#0b0b0b;
      white-space:nowrap;
    }
    .badge.ok{border-color:#2e7d32;color:#7CFC90;}
    .badge.retired{border-color:#666;color:#bdbdbd;}
    .badge.live{border-color:#1976d2;color:#8ec5ff;}
    .badge.admin{border-color:#EBFF00;color:#EBFF00;}

    .title{color:#fff;font-size:18px;margin:0;}
    .meta{color:#b9b9b9;margin:8px 0 10px;font-size:13px;line-height:1.4;}

    .row{display:flex; gap:10px; flex-wrap:wrap; margin-bottom:12px;}

    .pill{
      font-size:12px; padding:6px 10px; border-radius:10px;
      border:1px solid #2b2b2b; color:#eaeaea; background:#0b0b0b;
    }
    .pill.red{border-color:#d32f2f;color:#ff7a7a;}
    .pill.yellow{border-color:#c9a227;color:#ffe082;}
    .pill.green{border-color:#2e7d32;color:#7CFC90;}
    .pill.blue{border-color:#1976d2;color:#8ec5ff;}
    .pill.gray{border-color:#666;color:#cfcfcf;}

    .card-actions{
      display:flex;
      justify-content:space-between;
      align-items:center;
      gap:10px;
      flex-wrap:wrap;
    }

    .actions-left{
      display:flex;
      gap:10px;
      flex-wrap:wrap;
      align-items:center;
    }

    .btn-open, .btn-download{
      display:inline-block; text-decoration:none;
      padding:10px 12px; border-radius:10px;
      background:transparent; cursor:pointer;
      font-size:14px;
    }

    .btn-open{
      border:1px solid #fff; color:#fff;
    }
    .btn-open:hover{filter:brightness(1.08);}

    .btn-download{
      border:1px solid #d32f2f; color:#d32f2f;
    }
    .btn-download:hover{filter:brightness(1.08);}

    .empty{
      color:#b9b9b9; border:1px dashed #333; border-radius:12px;
      padding:18px; text-align:center;
    }


    .resolution-panel{
      position:relative;
      overflow:hidden;
      background:
        radial-gradient(circle at top left, rgba(124,252,144,.12), transparent 30%),
        linear-gradient(135deg, #090909 0%, #0f0f0f 55%, #141414 100%);
      border:1px solid #243b2a;
      border-radius:16px;
      padding:18px;
      margin:0 0 28px;
      box-shadow:0 18px 45px rgba(0,0,0,.35), inset 0 0 24px rgba(124,252,144,.03);
    }

    .resolution-panel::before{
      content:"";
      position:absolute;
      inset:0;
      background:repeating-linear-gradient(
        to bottom,
        rgba(255,255,255,.025) 0px,
        rgba(255,255,255,.025) 1px,
        transparent 1px,
        transparent 6px
      );
      pointer-events:none;
      opacity:.35;
    }

    .resolution-head{
      position:relative;
      display:flex;
      justify-content:space-between;
      align-items:center;
      gap:12px;
      margin-bottom:14px;
    }

    .resolution-title{
      color:#fff;
      font-size:20px;
      margin:0;
      display:flex;
      align-items:center;
      gap:10px;
    }

    .terminal-dot{
      width:10px;
      height:10px;
      border-radius:50%;
      background:#7CFC90;
      box-shadow:0 0 16px rgba(124,252,144,.9);
      display:inline-block;
    }

    .resolution-tag{
      color:#7CFC90;
      border:1px solid #2e7d32;
      background:rgba(124,252,144,.06);
      border-radius:999px;
      padding:6px 10px;
      font-size:12px;
      white-space:nowrap;
    }

    .terminal-window{
      position:relative;
      background:#050505;
      border:1px solid #222;
      border-radius:14px;
      overflow:hidden;
    }

    .terminal-bar{
      display:flex;
      align-items:center;
      gap:7px;
      padding:10px 12px;
      border-bottom:1px solid #1d1d1d;
      background:#0b0b0b;
    }

    .terminal-bar span{
      width:10px;
      height:10px;
      border-radius:50%;
      background:#333;
      display:inline-block;
    }

    .terminal-path{
      margin-left:8px;
      color:#777;
      font-size:12px;
      font-family:monospace;
    }

    .terminal-content{
      padding:16px;
      font-family:monospace;
      color:#cfcfcf;
      line-height:1.65;
      font-size:14px;
    }

    .terminal-line{margin:0 0 8px;}
    .prompt{color:#7CFC90;}
    .cmd{color:#fff;}
    .comment{color:#8ec5ff;}
    .terminal-cursor{
      display:inline-block;
      width:8px;
      height:15px;
      background:#7CFC90;
      margin-left:4px;
      vertical-align:-2px;
      animation:blink 1s steps(2,start) infinite;
    }

    .resolution-steps{
      position:relative;
      display:grid;
      grid-template-columns:repeat(auto-fit, minmax(180px, 1fr));
      gap:10px;
      margin-top:14px;
    }

    .resolution-step{
      background:#0b0b0b;
      border:1px solid #242424;
      border-radius:12px;
      padding:12px;
      color:#b9b9b9;
      font-size:13px;
    }

    .resolution-step strong{
      display:block;
      color:#fff;
      margin-bottom:5px;
    }

    @keyframes blink{50%{opacity:0;}}

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

    .modal-backdrop{
      position:fixed;
      inset:0;
      background:rgba(0,0,0,.72);
      display:none;
      align-items:center;
      justify-content:center;
      z-index:9999;
      padding:20px;
    }
    .modal-backdrop.open{display:flex;}

    .modal{
      width:100%;
      max-width:550px;
      background:#0f0f0f;
      border:1px solid #222;
      border-radius:16px;
      overflow:hidden;
      box-shadow:0 20px 60px rgba(0,0,0,.55);
    }

    .modal-head{
      display:flex;
      justify-content:space-between;
      align-items:center;
      gap:10px;
      padding:12px 14px;
      border-bottom:1px solid #222;
      background:#0f0f0f;
    }

    .modal-title{
      color:#fff;
      font-size:16px;
      margin:0;
    }

    .modal-close{
      background:transparent;
      border:1px solid #333;
      color:#fff;
      border-radius:8px;
      padding:6px 10px;
      cursor:pointer;
    }

    .modal-body{
      padding:16px;
    }

    .modal-info{
      color:#b9b9b9;
      font-size:13px;
      line-height:1.5;
      margin:0 0 14px;
    }

    .modal-label{
      display:block;
      color:#ddd;
      margin-bottom:8px;
      font-size:14px;
    }

    .modal-input{
      width:100%;
      background:#0b0b0b;
      border:1px solid #2b2b2b;
      color:#fff;
      padding:12px;
      border-radius:10px;
      outline:none;
      margin-bottom:14px;
      box-sizing:border-box;
    }

    .modal-actions{
      display:flex;
      justify-content:flex-end;
      gap:10px;
      flex-wrap:wrap;
    }

    .modal-btn{
      padding:10px 14px;
      border-radius:10px;
      border:1px solid #d32f2f;
      background:transparent;
      color:#d32f2f;
      cursor:pointer;
    }

    .modal-btn.white{
      border-color:#fff;
      color:#fff;
    }
  </style>
</head>
<body>

  <nav>
    <a href="index.php"><div class="logo">>_ root<span>me</span></div></a>
    <div class="nav-links">
      <a href="academia.php">Academia</a>
      <a href="ranking.php">Ranking</a>
            <a href="contacto.php">Contacto</a>

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
    <h1 class="page-title">Máquinas</h1>
    <p class="page-sub">Listado de máquinas obtenidas desde la base de datos.</p>

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

    <form class="filters" method="GET" action="start.php">
      <input type="text" name="q" placeholder="Buscar máquina..." value="<?php echo htmlspecialchars($q); ?>">

      <select name="cat">
        <?php foreach ($categorias as $c): ?>
          <option value="<?php echo htmlspecialchars($c); ?>" <?php echo ($cat === $c ? 'selected' : ''); ?>>
            <?php echo htmlspecialchars($c); ?>
          </option>
        <?php endforeach; ?>
      </select>

      <select name="dif">
        <?php foreach ($dificultades as $d): ?>
          <option value="<?php echo htmlspecialchars($d); ?>" <?php echo ($dif === $d ? 'selected' : ''); ?>>
            <?php echo htmlspecialchars($d); ?>
          </option>
        <?php endforeach; ?>
      </select>

      <button class="btn" type="submit">Aplicar</button>
      <a class="btn" href="start.php">Limpiar</a>
    </form>

    <section class="resolution-panel">
      <div class="resolution-head">
        <h2 class="resolution-title"><span class="terminal-dot"></span> Resolución de máquinas</h2>
        <span class="resolution-tag">root@training:~$</span>
      </div>

      <div class="terminal-window">
        <div class="terminal-bar">
          <span></span><span></span><span></span>
          <div class="terminal-path">/home/usuario/writeups</div>
        </div>

        <div class="terminal-content">
          <p class="terminal-line"><span class="prompt">root@rootme</span>:<span class="comment">~</span>$ <span class="cmd">cat resolucion_maquina.txt</span></p>
          <p class="terminal-line">Aquí se mostrará una guía informativa con los pasos para la resolución de dichas máquinas: reconocimiento, enumeración, explotación, escalada de privilegios y obtención de la flag.</p>
          <p class="terminal-line">Usa este espacio como apoyo para la metodología seguida, se recomienda la realización de documentación de comandos importantes y evidencias encontradas durante el reto para un aprendizaje más óptimo.</p>
          <p class="terminal-line">Todas las máquinas cuentan con una password de root que se puede conseguir que será la propia flag</p>
          <p class="terminal-line"><span class="prompt">status</span>: cat suerte...<span class="terminal-cursor"></span></p>
        </div>
      </div>

      <div class="resolution-steps">
        <div class="resolution-step"><strong>01. Reconocimiento</strong>Identifica IP, puertos abiertos y servicios expuestos.</div>
        <div class="resolution-step"><strong>02. Enumeración</strong>Busca rutas, versiones, usuarios y posibles vectores.</div>
        <div class="resolution-step"><strong>03. Explotación</strong>Accede al sistema aprovechando la vulnerabilidad detectada.</div>
        <div class="resolution-step"><strong>04. Flag &amp; informe</strong>Valida la flag y documenta los pasos realizados.</div>
      </div>
    </section>

    <h2 class="section-title">Máquinas activas</h2>
    <?php if (count($retosActivos) === 0): ?>
      <div class="empty">No hay máquinas activas con esos filtros.</div>
    <?php else: ?>
      <div class="grid">
        <?php foreach ($retosActivos as $ch): ?>
          <?php
            $difClass = "yellow";
            if ($ch["dificultad"] === "Fácil") $difClass = "green";
            if ($ch["dificultad"] === "Difícil") $difClass = "red";
          ?>
          <div class="card">
            <div class="card-top">
              <h3 class="title"><?php echo htmlspecialchars($ch["titulo"]); ?></h3>

              <?php if ((int)$ch["resuelto"] === 1): ?>
                <span class="badge ok">Resuelto</span>
              <?php else: ?>
                <span class="badge live">Activa</span>
              <?php endif; ?>
            </div>

            <p class="meta"><?php echo htmlspecialchars($ch["descripcion"]); ?></p>

            <div class="row">
              <span class="pill"><?php echo htmlspecialchars($ch["categoria"]); ?></span>
              <span class="pill <?php echo $difClass; ?>"><?php echo htmlspecialchars($ch["dificultad"]); ?></span>
              <span class="pill"><?php echo (int)$ch["puntos"]; ?> pts</span>
              <span class="pill blue">
                <?php echo htmlspecialchars($ch["tipo_entorno"] === 'descargable' ? 'Descargable' : 'Guacamole'); ?>
              </span>
            </div>

            <div class="card-actions">
              <div class="actions-left">
                <?php if ($ch["tipo_entorno"] === 'guacamole' && !empty($ch["maquina_url"])): ?>
                  <a
                    class="btn-open btn-open-machine"
                    href="<?php echo $cooldownRestante > 0 ? '#' : 'abrir_maquina.php?id=' . (int)$ch["id"]; ?>"
                    data-cooldown="<?php echo (int)$cooldownRestante; ?>"
                    <?php echo ($cooldownRestante > 0 ? 'style="pointer-events:none;opacity:0.5;"' : ''); ?>
                  >
                    <?php echo ($cooldownRestante > 0 ? 'Espera ' . $cooldownRestante . 's' : 'Abrir máquina'); ?>
                  </a>
                <?php endif; ?>

                <?php if ($ch["tipo_entorno"] === 'descargable' && !empty($ch["archivo_descarga"])): ?>
                  <a class="btn-download" href="<?php echo htmlspecialchars($ch["archivo_descarga"]); ?>" download>Descargar</a>
                <?php endif; ?>

                <button
                  type="button"
                  class="btn-open btn-start"
                  data-id="<?php echo (int)$ch["id"]; ?>"
                  data-title="<?php echo htmlspecialchars($ch["titulo"]); ?>"
                >
                  Verificar
                </button>

                <a class="btn-open" href="foro.php?id=<?php echo (int)$ch["id"]; ?>">
                  Foro
                </a>
              </div>

              <span style="color:#777; font-size:12px;">Máquina #<?php echo (int)$ch["id"]; ?></span>
            </div>
          </div>
        <?php endforeach; ?>
      </div>
    <?php endif; ?>

    <h2 class="section-title">Máquinas retiradas</h2>

    <?php if (count($retosRetirados) === 0): ?>
      <div class="empty">No hay máquinas retiradas con esos filtros.</div>
    <?php else: ?>
      <div class="grid">
        <?php foreach ($retosRetirados as $ch): ?>
          <?php
            $difClass = "yellow";
            if ($ch["dificultad"] === "Fácil") $difClass = "green";
            if ($ch["dificultad"] === "Difícil") $difClass = "red";
          ?>
          <div class="card">
            <div class="card-top">
              <h3 class="title"><?php echo htmlspecialchars($ch["titulo"]); ?></h3>
              <span class="badge retired">Retirada</span>
            </div>

            <p class="meta"><?php echo htmlspecialchars($ch["descripcion"]); ?></p>

            <div class="row">
              <span class="pill"><?php echo htmlspecialchars($ch["categoria"]); ?></span>
              <span class="pill <?php echo $difClass; ?>"><?php echo htmlspecialchars($ch["dificultad"]); ?></span>
              <span class="pill"><?php echo (int)$ch["puntos"]; ?> pts</span>
              <span class="pill gray">
                <?php echo htmlspecialchars($ch["tipo_entorno"] === 'descargable' ? 'Descargable' : 'Guacamole'); ?>
              </span>
            </div>

            <div class="card-actions">
              <div class="actions-left">
                <?php if ($ch["tipo_entorno"] === 'guacamole' && !empty($ch["maquina_url"])): ?>
                  <a
                    class="btn-open btn-open-machine"
                    href="<?php echo $cooldownRestante > 0 ? '#' : 'abrir_maquina.php?id=' . (int)$ch["id"]; ?>"
                    data-cooldown="<?php echo (int)$cooldownRestante; ?>"
                    <?php echo ($cooldownRestante > 0 ? 'style="pointer-events:none;opacity:0.5;"' : ''); ?>
                  >
                    <?php echo ($cooldownRestante > 0 ? 'Espera ' . $cooldownRestante . 's' : 'Abrir máquina'); ?>
                  </a>
                <?php endif; ?>

                <?php if ($ch["tipo_entorno"] === 'descargable' && !empty($ch["archivo_descarga"])): ?>
                  <a class="btn-download" href="<?php echo htmlspecialchars($ch["archivo_descarga"]); ?>" download>Descargar</a>
                <?php endif; ?>

                <a class="btn-open" href="foro.php?id=<?php echo (int)$ch["id"]; ?>">
                  Foro
                </a>
              </div>

              <span style="color:#777; font-size:12px;">Máquina #<?php echo (int)$ch["id"]; ?></span>
            </div>
          </div>
        <?php endforeach; ?>
      </div>
    <?php endif; ?>
  </div>

  <div class="modal-backdrop" id="flagModal">
    <div class="modal">
      <div class="modal-head">
        <h3 class="modal-title" id="modalChallengeTitle">Enviar flag</h3>
        <button type="button" class="modal-close" id="closeModal">X</button>
      </div>

      <div class="modal-body">
        <p class="modal-info">
          Introduce la flag del reto. Si es correcta, se registrará en la base de datos y se sumarán los puntos al ranking.
        </p>

        <form method="POST" action="submit_flag.php" autocomplete="off">
          <input type="hidden" name="reto_id" id="retoIdInput">

          <label class="modal-label" for="flagInput">Introduce la flag</label>
          <input
            type="password"
            name="flag"
            id="flagInput"
            class="modal-input"
            placeholder="Introduce la flag"
            autocomplete="new-password"
            autocapitalize="off"
            autocorrect="off"
            spellcheck="false"
            required
          >

          <div class="modal-actions">
            <button type="submit" class="modal-btn">Validar flag</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <footer>
    root@server:~$ sudo shutdown -h now
  </footer>

  <script>
    const modal = document.getElementById('flagModal');
    const closeModal = document.getElementById('closeModal');
    const retoIdInput = document.getElementById('retoIdInput');
    const modalTitle = document.getElementById('modalChallengeTitle');
    const flagInput = document.getElementById('flagInput');

    document.querySelectorAll('.btn-start').forEach(btn => {
      btn.addEventListener('click', () => {
        const retoId = btn.dataset.id;
        const retoTitle = btn.dataset.title;

        retoIdInput.value = retoId;
        flagInput.value = '';
        modalTitle.textContent = 'Máquina: ' + retoTitle;
        modal.classList.add('open');

        setTimeout(() => {
          flagInput.focus();
        }, 100);
      });
    });

    closeModal.addEventListener('click', () => {
      modal.classList.remove('open');
      flagInput.value = '';
    });

    modal.addEventListener('click', (e) => {
      if (e.target === modal) {
        modal.classList.remove('open');
        flagInput.value = '';
      }
    });

    let cooldown = <?php echo (int)$cooldownRestante; ?>;
    const botonesMaquina = document.querySelectorAll('.btn-open-machine');

    if (cooldown > 0 && botonesMaquina.length > 0) {
      const interval = setInterval(() => {
        cooldown--;

        botonesMaquina.forEach(btn => {
          btn.textContent = cooldown > 0 ? 'Espera ' + cooldown + 's' : 'Abrir máquina';
        });

        if (cooldown <= 0) {
          clearInterval(interval);

          botonesMaquina.forEach(btn => {
            const idMatch = btn.getAttribute('href');

            if (idMatch === '#') {
              const card = btn.closest('.card');

              if (card) {
                const verificar = card.querySelector('.btn-start');
                const foro = card.querySelector('a[href^="foro.php?id="]');

                if (verificar) {
                  btn.href = 'abrir_maquina.php?id=' + verificar.dataset.id;
                } else if (foro) {
                  const url = new URL(foro.href);
                  const id = url.searchParams.get('id');
                  btn.href = 'abrir_maquina.php?id=' + id;
                }
              }
            }

            btn.style.pointerEvents = 'auto';
            btn.style.opacity = '1';
          });
        }
      }, 1000);
    }
  </script>
</body>
</html>
