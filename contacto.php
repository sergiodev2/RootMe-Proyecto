<?php
session_start();

require_once 'auth.php';
require_once 'db.php';
require_once 'mail_config.php';
require_once __DIR__ . '/vendor/autoload.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

$is_logged = isset($_SESSION['user_id']);
$username = $_SESSION['username'] ?? 'Guest';
$rol = isset($_SESSION['rol']) ? (int)$_SESSION['rol'] : 0;
$destino = 'notificacionrootme@gmail.com';
$success = '';
$error = '';

if (empty($_SESSION['contact_token'])) {
    $_SESSION['contact_token'] = bin2hex(random_bytes(32));
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $token = $_POST['token'] ?? '';
    $honeypot = trim($_POST['website'] ?? '');
    $nombre = trim($_POST['nombre'] ?? '');
    $email = trim($_POST['email'] ?? '');
    $tipo = trim($_POST['tipo'] ?? '');
    $asunto = trim($_POST['asunto'] ?? '');
    $mensaje = trim($_POST['mensaje'] ?? '');

    if (!hash_equals($_SESSION['contact_token'], $token)) {
        $error = 'Token inválido. Recarga la página e inténtalo de nuevo.';
    } elseif ($honeypot !== '') {
        $error = 'Solicitud bloqueada.';
    } elseif ($nombre === '' || $email === '' || $tipo === '' || $asunto === '' || $mensaje === '') {
        $error = 'Completa todos los campos.';
    } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $error = 'El correo introducido no es válido.';
    } elseif (strlen($mensaje) < 10) {
        $error = 'El mensaje debe tener al menos 10 caracteres.';
    } else {
        $mail = new PHPMailer(true);

        try {
            $mail->isSMTP();
            $mail->Host = SMTP_HOST;
            $mail->SMTPAuth = true;
            $mail->Username = SMTP_USER;
            $mail->Password = SMTP_PASS;
            $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
            $mail->Port = SMTP_PORT;
            $mail->CharSet = 'UTF-8';

            $mail->setFrom(SMTP_FROM_EMAIL, SMTP_FROM_NAME);
            $mail->addAddress($destino);
            $mail->addReplyTo($email, $nombre);
            $mail->isHTML(true);
            $mail->Subject = '[ROOT ME] ' . $asunto;

            $usuarioSesion = $is_logged ? $username : 'No autenticado';
            $bodyHtml = "
                <div style='font-family:Arial,sans-serif;background:#0a0a0a;color:#eeeeee;padding:20px;border-radius:8px;'>
                    <h2 style='color:#00ff41;'>Nuevo formulario de contacto - ROOT ME</h2>
                    <p><strong>Nombre:</strong> " . htmlspecialchars($nombre, ENT_QUOTES, 'UTF-8') . "</p>
                    <p><strong>Email:</strong> " . htmlspecialchars($email, ENT_QUOTES, 'UTF-8') . "</p>
                    <p><strong>Usuario sesión:</strong> " . htmlspecialchars($usuarioSesion, ENT_QUOTES, 'UTF-8') . "</p>
                    <p><strong>Tipo:</strong> " . htmlspecialchars($tipo, ENT_QUOTES, 'UTF-8') . "</p>
                    <p><strong>Asunto:</strong> " . htmlspecialchars($asunto, ENT_QUOTES, 'UTF-8') . "</p>
                    <hr style='border:0;border-top:1px solid #333;'>
                    <p><strong>Mensaje:</strong></p>
                    <p>" . nl2br(htmlspecialchars($mensaje, ENT_QUOTES, 'UTF-8')) . "</p>
                </div>
            ";

            $mail->Body = $bodyHtml;
            $mail->AltBody = "Nuevo formulario de contacto - ROOT ME\n\nNombre: $nombre\nEmail: $email\nUsuario sesión: $usuarioSesion\nTipo: $tipo\nAsunto: $asunto\n\nMensaje:\n$mensaje";
            $mail->send();
            $success = 'Mensaje enviado correctamente. El equipo lo revisará pronto.';
            $_SESSION['contact_token'] = bin2hex(random_bytes(32));
            $_POST = [];
        } catch (Exception $e) {
            $error = 'No se pudo enviar el mensaje. Error: ' . $mail->ErrorInfo;
        }
    }
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>ROOT ME - Contacto</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .contact-wrap{max-width:1000px;margin:45px auto;padding:20px}.contact-hero{border:1px solid #222;background:radial-gradient(circle at top left,rgba(0,255,65,.12),transparent 30%),rgba(10,10,10,.95);border-radius:18px;padding:28px;box-shadow:0 0 25px rgba(0,255,65,.06);margin-bottom:22px}.contact-hero h1{color:#fff;margin:0 0 10px;font-size:34px}.contact-hero p{color:#aaa;margin:0;line-height:1.6}.terminal-line{color:#00ff41;font-family:monospace;font-size:14px;margin-bottom:10px}.contact-grid{display:grid;grid-template-columns:1fr 1.5fr;gap:20px}.contact-info,.contact-form{background:#0f0f0f;border:1px solid #222;border-radius:18px;padding:22px}.contact-info h2,.contact-form h2{color:#fff;margin-top:0}.contact-info p{color:#aaa;line-height:1.6}.contact-info code{color:#00ff41;background:#050505;border:1px solid #222;padding:4px 7px;border-radius:8px}.form-group{margin-bottom:14px}.form-group label{display:block;color:#ccc;font-size:14px;margin-bottom:7px}.form-group input,.form-group select,.form-group textarea{width:100%;box-sizing:border-box;background:#080808;border:1px solid #2b2b2b;color:#eaeaea;border-radius:12px;padding:12px 14px;outline:none}.form-group textarea{min-height:150px;resize:vertical}.form-group input:focus,.form-group select:focus,.form-group textarea:focus{border-color:#00ff41;box-shadow:0 0 12px rgba(0,255,65,.12)}.btn-send{width:100%;padding:13px 16px;border-radius:12px;border:1px solid #00ff41;background:transparent;color:#00ff41;cursor:pointer;font-weight:bold;transition:.2s}.btn-send:hover{background:rgba(0,255,65,.08);box-shadow:0 0 18px rgba(0,255,65,.18)}.alert-success{background:rgba(46,125,50,.15);border:1px solid #2e7d32;color:#7CFC90;padding:12px 14px;border-radius:12px;margin-bottom:16px}.alert-error{background:rgba(211,47,47,.15);border:1px solid #d32f2f;color:#ff7a7a;padding:12px 14px;border-radius:12px;margin-bottom:16px}.hidden-field{display:none}@media(max-width:800px){.contact-grid{grid-template-columns:1fr}}
    </style>
</head>
<body>
<nav>
    <a href="index.php"><div class="logo">>_ root<span>me</span></div></a>
    <div class="nav-links">
        <a href="start.php">Retos</a>
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
            <a href="login.php" class="btn-login2">LOGIN</a>
        <?php endif; ?>
    </div>
</nav>
<div class="contact-wrap">
    <section class="contact-hero">
        <div class="terminal-line">root@contact:~$ ./send_report.sh</div>
        <h1>>_ CONTACTO_ROOTME</h1>
        <p>Usa este formulario para reportar errores, problemas con máquinas, dudas sobre retos o sugerencias para mejorar la plataforma.</p>
    </section>
    <div class="contact-grid">
        <aside class="contact-info">
            <h2>Canal de soporte</h2>
            <p>El mensaje será enviado directamente al correo de notificaciones:</p>
            <p><code>notificacionrootme@gmail.com</code></p>
            <p>Si reportas una máquina, indica el nombre del reto, qué estabas haciendo y el error que aparece.</p>
        </aside>
        <section class="contact-form">
            <h2>Enviar mensaje</h2>
            <?php if ($success): ?><div class="alert-success"><?php echo htmlspecialchars($success); ?></div><?php endif; ?>
            <?php if ($error): ?><div class="alert-error"><?php echo htmlspecialchars($error); ?></div><?php endif; ?>
            <form method="POST" action="contacto.php">
                <input type="hidden" name="token" value="<?php echo htmlspecialchars($_SESSION['contact_token']); ?>">
                <div class="hidden-field"><label>Website</label><input type="text" name="website" autocomplete="off"></div>
                <div class="form-group"><label>Nombre</label><input type="text" name="nombre" required value="<?php echo htmlspecialchars($_POST['nombre'] ?? ($is_logged ? $username : '')); ?>"></div>
                <div class="form-group"><label>Correo</label><input type="email" name="email" required value="<?php echo htmlspecialchars($_POST['email'] ?? ''); ?>"></div>
                <div class="form-group"><label>Tipo de consulta</label><select name="tipo" required><option value="">Selecciona una opción</option><option value="Problema con una máquina">Problema con una máquina</option><option value="Duda sobre un reto">Duda sobre un reto</option><option value="Reportar error">Reportar error</option><option value="Sugerencia">Sugerencia</option><option value="Otro">Otro</option></select></div>
                <div class="form-group"><label>Asunto</label><input type="text" name="asunto" required value="<?php echo htmlspecialchars($_POST['asunto'] ?? ''); ?>"></div>
                <div class="form-group"><label>Mensaje</label><textarea name="mensaje" required><?php echo htmlspecialchars($_POST['mensaje'] ?? ''); ?></textarea></div>
                <button type="submit" class="btn-send">Enviar formulario</button>
            </form>
        </section>
    </div>
</div>
<footer>root@server:~$ sudo shutdown -h now</footer>
</body>
</html>
