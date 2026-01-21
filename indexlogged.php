<?php
/*session_start();
$is_logged = isset($_SESSION['user_id']);
$username = $is_logged ? $_SESSION['username'] : 'Guest';
echo "<br>";
*/
?>
<?php
session_start();
require_once 'auth.php';
$username = $_SESSION['username'];
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
            <a href="ranking.php">Ranking</a>
                <span style="color: #EBFF00; margin-left:20px;">[ <?php echo htmlspecialchars($username); ?> ]</span>
            
            <?php if ($is_logged): ?>
                <span style="color: #d32f2f; margin-left:20px;">[ <?php echo htmlspecialchars($username); ?> ]</span>
                <a href="logout.php" class="btn-login2" style="border-color:#FF0000 !important; color:#FF0000 !important;">LOGOUT</a>
            <?php else: ?>
                <a href="logout.php" class="btn-login2">LOGOUT</a>
            <?php endif; ?>
        </div>
    </nav>

    <section class="hero">
      <h1>Bienvenido de nuevo <span style="color:white">
    <?php echo htmlspecialchars($_SESSION['username']); ?>
</span><span class="cursor"></span></h1>

        <p>Entrena tus habilidades de hacking en entornos seguros.</p>
        
	<div class="cta-container">
    <a href="start.php" class="cta-btn" style="margin-right:20px;">Retos</a>
    <a href="academia.php" class="cta-btn">Academia</a>
</div>

    </section>


    <footer>
        root@server:~$ sudo shutdown -h now
    </footer>

</body>
</html>
