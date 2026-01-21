<?php
session_start();
$is_logged = isset($_SESSION['user_id']);
$username = $is_logged ? $_SESSION['username'] : 'Guest';
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
            <a href="#">Retos</a>
            <a href="#">Ranking</a>
            
            <?php if ($is_logged): ?>
                <span style="color: #d32f2f; margin-left:20px;">[ <?php echo htmlspecialchars($username); ?> ]</span>
                <a href="logout.php" class="btn-login" style="border-color:#d32f2f; color:#d32f2f;">LOGOUT</a>
            <?php else: ?>
                <a href="login.php" class="btn-login">LOGIN</a>
            <?php endif; ?>
        </div>
    </nav>

    <section class="hero">
        <p style="color: white; letter-spacing: 3px;">INITIALIZING SYSTEM...</p>
        <h1>BECOME <span style="color:white">ROOT</span><span class="cursor"></span></h1>
        <p>Entrena tus habilidades de hacking en entornos seguros.</p>
        
	<div class="cta-container">
    <a href="login.php" class="cta-btn">Start Hacking</a>
</div>

    </section>

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

    <footer>
        root@server:~$ sudo shutdown -h now
    </footer>

</body>
</html>
