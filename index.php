<?php
session_start();

$is_logged = isset($_SESSION['user_id']) && isset($_SESSION['username']);
$username = $is_logged ? $_SESSION['username'] : 'Guest';
$rol = isset($_SESSION['rol']) ? (int)$_SESSION['rol'] : 0;
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ROOT ME - Hacking Platform</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

    <nav>
        <div class="logo">>_ root<span>me</span></div>
        <div class="nav-links">
            <?php if ($is_logged): ?>
                
                <?php if ($rol === 1): ?>
                    <a href="admin_dashboard.php" style="color: #EBFF00; margin-left:20px; text-decoration:none;">[ <?php echo htmlspecialchars($username); ?> ]</a>
                <?php else: ?>
                    <span style="color: #EBFF00; margin-left:20px;">[ <?php echo htmlspecialchars($username); ?> ]</span>
                <?php endif; ?>

                <a href="logout.php" class="btn-login2 red">LOGOUT</a>
            <?php else: ?>
                <a href="start.php">Retos</a>
                <a href="#">Ranking</a>
                <a href="login.php" class="btn-login">LOGIN</a>
            <?php endif; ?>
        </div>
    </nav>

    <section class="hero">
        <?php if ($is_logged): ?>
            <h1>Bienvenido de nuevo <span style="color:white"><?php echo htmlspecialchars($username); ?></span><span class="cursor"></span></h1>
            <p>Entrena tus habilidades de hacking en entornos seguros.</p>
            <div class="cta-container">
                <a href="start.php" class="cta-btn" style="margin-right:20px;">Retos</a>
                <a href="academia.php" class="cta-btn">Academia</a>
            </div>
        <?php else: ?>
            <p style="color: white; letter-spacing: 3px;">INITIALIZING SYSTEM...</p>
            <h1>BECOME <span style="color:white">ROOT</span><span class="cursor"></span></h1>
            <p>Entrena tus habilidades de hacking en entornos seguros.</p>
            <div class="cta-container">
                <a href="login.php" class="cta-btn">Start Hacking</a>
            </div>
        <?php endif; ?>
    </section>

    <?php if (!$is_logged): ?>
    <section class="stats-bar">
        <div class="stat-item">
            <h3>150+</h3>
            <p>VIRTUAL MACHINES</p>
        </div>
        <div class="stat-item">
            <h3>12k</h3>
            <p>ACTIVE USERS</p>
        </div>
        <div class="stat-item">
            <h3>450</h3>
            <p>CTF CHALLENGES</p>
        </div>
    </section>
    <?php endif; ?>

    <footer>
        root@server:~$ sudo shutdown -h now
    </footer>

</body>
</html>
