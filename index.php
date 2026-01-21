<?php
session_start();
require_once 'db.php';

$is_logged = isset($_SESSION['user_id']);
$username  = $is_logged ? $_SESSION['username'] : null;
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Inicio</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<header>
    <h1>Mi Web</h1>

    <?php if ($is_logged): ?>
        <p>Bienvenido, <?= htmlspecialchars($username) ?></p>
        <a href="logout.php">Cerrar sesión</a>
    <?php else: ?>
        <a href="login.php">Iniciar sesión</a>
    <?php endif; ?>
</header>

<main>
<?php if ($is_logged): ?>
    <h2>Zona privada</h2>
<?php else: ?>
    <h2>Zona pública</h2>
<?php endif; ?>
</main>

</body>
</html>
