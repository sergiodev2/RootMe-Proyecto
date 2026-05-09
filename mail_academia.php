<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require_once __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/mail_config.php';

function enviarNotificacionesAcademia(mysqli $conn, int $postId, string $titulo, string $contenido): array
{
    $resultado = [
        'enviados' => 0,
        'saltados' => 0,
        'errores' => 0,
    ];

    $sqlUsuarios = "
        SELECT id, username, email
        FROM usuarios
        WHERE email IS NOT NULL
          AND email <> ''
    ";

    $usuarios = $conn->query($sqlUsuarios);

    if (!$usuarios) {
        error_log('Academia mail - error SQL usuarios: ' . $conn->error);
        $resultado['errores']++;
        return $resultado;
    }

    while ($usuario = $usuarios->fetch_assoc()) {
        $usuarioId = (int)$usuario['id'];
        $email = trim((string)$usuario['email']);
        $username = $usuario['username'] ?? 'usuario';

        if ($email === '') {
            $resultado['saltados']++;
            continue;
        }

        $stmtExiste = $conn->prepare("SELECT id FROM academia_email_logs WHERE post_id = ? AND usuario_id = ? LIMIT 1");
        if (!$stmtExiste) {
            error_log('Academia mail - error prepare logs: ' . $conn->error);
            $resultado['errores']++;
            continue;
        }

        $stmtExiste->bind_param("ii", $postId, $usuarioId);
        $stmtExiste->execute();
        $resExiste = $stmtExiste->get_result();
        $yaEnviado = $resExiste->num_rows > 0;
        $stmtExiste->close();

        if ($yaEnviado) {
            $resultado['saltados']++;
            continue;
        }

        $asunto = 'Nuevo post en Academia ROOT ME: ' . $titulo;
        $contenidoPlano = strip_tags($contenido);
        $contenidoCorto = mb_substr($contenidoPlano, 0, 350);
        if (mb_strlen($contenidoPlano) > 350) {
            $contenidoCorto .= '...';
        }

        $bodyHtml = "
            <div style='font-family:Arial,sans-serif;background:#0a0a0a;color:#eeeeee;padding:20px;border-radius:8px;'>
                <h2 style='color:#00ff41;'>Nuevo post en Academia ROOT ME</h2>
                <p>Hola <strong>" . htmlspecialchars($username, ENT_QUOTES, 'UTF-8') . "</strong>,</p>
                <p>Se ha publicado un nuevo post en Academia:</p>
                <h3 style='color:#ffffff;'>" . htmlspecialchars($titulo, ENT_QUOTES, 'UTF-8') . "</h3>
                <p style='line-height:1.5;color:#cccccc;'>" . nl2br(htmlspecialchars($contenidoCorto, ENT_QUOTES, 'UTF-8')) . "</p>
                <p style='margin-top:20px;'>Entra en la plataforma para leerlo completo.</p>
                <hr style='border:0;border-top:1px solid #333;'>
                <p style='font-size:12px;color:#777;'>ROOT ME - Sistema automático de notificaciones</p>
            </div>
        ";

        $bodyText = "Hola $username,

";
        $bodyText .= "Se ha publicado un nuevo post en Academia ROOT ME:

";
        $bodyText .= $titulo . "

";
        $bodyText .= $contenidoCorto . "

";
        $bodyText .= "Entra en la plataforma para leerlo completo.

ROOT ME";

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
            $mail->addAddress($email, $username);

            $mail->isHTML(true);
            $mail->Subject = $asunto;
            $mail->Body = $bodyHtml;
            $mail->AltBody = $bodyText;

            $mail->send();

            $stmtLog = $conn->prepare("INSERT IGNORE INTO academia_email_logs (post_id, usuario_id, email) VALUES (?, ?, ?)");
            if ($stmtLog) {
                $stmtLog->bind_param("iis", $postId, $usuarioId, $email);
                $stmtLog->execute();
                $stmtLog->close();
            } else {
                error_log('Academia mail - correo enviado pero log falló: ' . $conn->error);
            }

            $resultado['enviados']++;
        } catch (Exception $e) {
            error_log('Academia mail - error enviando a ' . $email . ': ' . $mail->ErrorInfo);
            $resultado['errores']++;
            continue;
        }
    }

    return $resultado;
}
