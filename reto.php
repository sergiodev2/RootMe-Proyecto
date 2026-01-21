<?php
/* =========================
   DEBUG (puedes quitar luego)
========================= */
ini_set('display_errors', 1);
error_reporting(E_ALL);

/* =========================
   SESIÓN + AUTH
========================= */
require_once 'auth.php';   // auth.php YA hace session_start()
require_once 'db.php';     // usa $conn (mysqli)

/* =========================
   FIX CLAVE:
   Si existe username pero NO user_id,
   lo reconstruimos desde la BD
========================= */
if (!isset($_SESSION['user_id']) && isset($_SESSION['username'])) {
    $stmt = $conn->prepare("SELECT id FROM usuarios WHERE username = ?");
    $stmt->bind_param("s", $_SESSION['username']);
    $stmt->execute();
    $res = $stmt->get_result();
    if ($row = $res->fetch_assoc()) {
        $_SESSION['user_id'] = (int)$row['id'];
    }
}

/* =========================
   VARIABLES DE SESIÓN
========================= */
$is_logged = isset($_SESSION['user_id']);
$username  = $_SESSION['username'] ?? 'Guest';
$usuarioId = $_SESSION['user_id'] ?? null;

/* =========================
   ID DEL RETO
========================= */
$retoId = isset($_GET['id']) ? (int)$_GET['id'] : 0;
if ($retoId <= 0) {
    die("Reto inválido");
}

/* =========================
   OBTENER RETO
========================= */
$stmt = $conn->prepare("
    SELECT r.*, c.nombre AS categoria
    FROM retos r
    JOIN categorias c ON c.id = r.categoria_id
    WHERE r.id = ? AND r.activo = 1
");
$stmt->bind_param("i", $retoId);
$stmt->execute();
$res = $stmt->get_result();
$reto = $res->fetch_assoc();

if (!$reto) {
    die("Reto no encontrado");
}

/* =========================
   ¿RETO RESUELTO?
========================= */
$yaResuelto = false;
if ($is_logged) {
    $stmt = $conn->prepare("
        SELECT 1 FROM solves
        WHERE usuario_id = ? AND reto_id = ?
    ");
    $stmt->bind_param("ii", $usuarioId, $retoId);
    $stmt->execute();
    $res = $stmt->get_result();
    $yaResuelto = $res->num_rows > 0;
}

/* =========================
   MENSAJES FLASH
========================= */
$mensaje  = $_SESSION['msg'] ?? null;
$tipoMsg  = $_SESSION['msg_type'] ?? null;
unset($_SESSION['msg'], $_SESSION['msg_type']);
?>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title><?php echo htmlspecialchars($reto['titulo']); ?> | ROOT ME</title>
<link rel="stylesheet" href="style.css">
</head>

<body>

<nav>
  <div class="logo">>_ root<span>me</span></div>
  <div class="nav-links">
    <a href="start.php">← Retos</a>

    <?php if ($is_logged): ?>
      <span style="color:#d32f2f;margin-left:20px;">
        [ <?php echo htmlspecialchars($username); ?> ]
      </span>
      <a href="logout.php" class="btn-login2"
         style="border-color:#FF0000 !important;color:#FF0000 !important;">
         LOGOUT
      </a>
    <?php else: ?>
      <a href="login.php" class="btn-login2">LOGIN</a>
    <?php endif; ?>
  </div>
</nav>

<div style="max-width:900px;margin:0 auto;padding:24px;color:white;">

  <h1><?php echo htmlspecialchars($reto['titulo']); ?></h1>

  <p>
    <b><?php echo htmlspecialchars($reto['categoria']); ?></b> |
    <?php echo htmlspecialchars($reto['dificultad']); ?> |
    <?php echo (int)$reto['puntos']; ?> pts
    <?php if ($yaResuelto): ?>
      | <span style="color:#7CFC90;">Resuelto</span>
    <?php endif; ?>
  </p>

  <hr>

  <p><?php echo nl2br(htmlspecialchars($reto['descripcion'])); ?></p>

  <hr>

  <?php if ($mensaje): ?>
    <p style="color:<?php echo $tipoMsg === 'ok' ? '#7CFC90' : '#ff7a7a'; ?>">
      <?php echo htmlspecialchars($mensaje); ?>
    </p>
  <?php endif; ?>

  <?php if ($is_logged && !$yaResuelto): ?>
    <form method="POST" action="validar_flag.php">
      <input type="hidden" name="reto_id" value="<?php echo $retoId; ?>">
      <input type="text" name="flag" placeholder="FLAG{...}" required>
      <button type="submit">Enviar flag</button>
    </form>
  <?php elseif ($yaResuelto): ?>
    <p style="color:#7CFC90;">✔ Ya has resuelto este reto.</p>
  <?php else: ?>
    <p style="color:#ff7a7a;">Debes iniciar sesión para enviar flags.</p>
  <?php endif; ?>

</div>

</body>
</html>

