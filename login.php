<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

session_start();
require __DIR__ . "/db.php";
require __DIR__ . '/guacamole_functions.php';

$error = '';
$registerError = '';
$registerSuccess = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    
    if (isset($_POST['login'])) {
        $username = trim($_POST['username'] ?? '');
        $password = trim($_POST['password'] ?? '');

        $sql = "SELECT id, username, password_hash, rol FROM usuarios WHERE username = ? LIMIT 1";
        $stmt = mysqli_prepare($conn, $sql);
        if (!$stmt) {
            die("ERROR PREPARE LOGIN: " . mysqli_error($conn));
        }

        mysqli_stmt_bind_param($stmt, "s", $username);
        mysqli_stmt_execute($stmt);
        mysqli_stmt_bind_result($stmt, $idUsuario, $usernameBD, $hash, $rol);

        $loginCorrecto = false;
        $idLogin = 0;
        $usernameLogin = '';
        $rolLogin = 0;

        if (mysqli_stmt_fetch($stmt)) {
            if (password_verify($password, $hash)) {
                $loginCorrecto = true;
                $idLogin = (int)$idUsuario;
                $usernameLogin = $usernameBD;
                $rolLogin = (int)$rol;
            } else {
                $error = "❌ Credenciales incorrectas";
            }
        } else {
            $error = "❌ Usuario no encontrado";
        }

        mysqli_stmt_close($stmt);

        if ($loginCorrecto) {
            $_SESSION['user_id'] = $idLogin;
            $_SESSION['username'] = $usernameLogin;
            $_SESSION['rol'] = $rolLogin;

            $ip = $_SERVER['REMOTE_ADDR'] ?? null;
            $userAgent = substr($_SERVER['HTTP_USER_AGENT'] ?? '', 0, 255);

            $stmtLog = mysqli_prepare($conn, "INSERT INTO login_activity (usuario_id, username, ip_address, user_agent) VALUES (?, ?, ?, ?)");
            if ($stmtLog) {
                mysqli_stmt_bind_param($stmtLog, "isss", $idLogin, $usernameLogin, $ip, $userAgent);
                mysqli_stmt_execute($stmtLog);
                mysqli_stmt_close($stmtLog);
            }

            header("Location: index.php");
            exit();
        }
    }

    
    if (isset($_POST['register'])) {
        $newUser = trim($_POST['username'] ?? '');
        $newEmail = trim($_POST['email'] ?? '');
        $newPassword = trim($_POST['password'] ?? '');

        if ($newUser === '' || $newEmail === '' || $newPassword === '') {
            $registerError = "❌ Todos los campos son obligatorios";
        } else {
            $sql = "SELECT id FROM usuarios WHERE username = ? OR email = ?";
            $stmt = mysqli_prepare($conn, $sql);
            if (!$stmt) {
                die("ERROR PREPARE REGISTRO: " . mysqli_error($conn));
            }

            mysqli_stmt_bind_param($stmt, "ss", $newUser, $newEmail);
            mysqli_stmt_execute($stmt);
            mysqli_stmt_store_result($stmt);

            if (mysqli_stmt_num_rows($stmt) > 0) {
                $registerError = "❌ El usuario o email ya existen";
                mysqli_stmt_close($stmt);
            } else {
                mysqli_stmt_close($stmt);

                $hash = password_hash($newPassword, PASSWORD_DEFAULT);

                $sql = "INSERT INTO usuarios (username, email, password_hash, rol) VALUES (?, ?, ?, 0)";
                $insert = mysqli_prepare($conn, $sql);
                if (!$insert) {
                    die("ERROR INSERT PREPARE: " . mysqli_error($conn));
                }

                mysqli_stmt_bind_param($insert, "sss", $newUser, $newEmail, $hash);

                if (mysqli_stmt_execute($insert)) {
                    mysqli_stmt_close($insert);

                    try {
                        crearUsuarioGuacamole($newUser, $newPassword, $newUser, $newEmail);
                        $registerSuccess = "✅ Usuario registrado correctamente. Por favor, inicia sesión.";
                    } catch (Exception $e) {
                        $registerError = "❌ Usuario creado en la web, pero no en Guacamole: " . $e->getMessage();
                    }
                } else {
                    $registerError = "❌ Error al registrar usuario: " . mysqli_error($conn);
                    mysqli_stmt_close($insert);
                }
            }
        }
    }
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>ROOT ME - Auth</title>
    <link rel="stylesheet" href="login.css">
</head>
<body>

<div class="login-box">

    <div id="login-form" style="display:block;">
        <h2>>_ LOGIN</h2>

        <?php if ($error): ?>
            <p style="color:red; font-weight:bold; margin-bottom:10px;"><?php echo htmlspecialchars($error); ?></p>
        <?php endif; ?>

        <?php if ($registerSuccess): ?>
            <p style="color:green; font-weight:bold; margin-bottom:10px;"><?php echo htmlspecialchars($registerSuccess); ?></p>
        <?php endif; ?>

        <form action="login.php" method="POST">
            <label>usr:</label>
            <input type="text" name="username" placeholder="root" required autocomplete="off">

            <label>pwd:</label>
            <input type="password" name="password" placeholder="******" required>

            <button type="submit" name="login">CONNECT</button>
        </form>

        <span class="toggle-link" onclick="toggleForms()">[ Crear nueva cuenta ]</span>
    </div>

    <div id="register-form" style="display:none;">
        <h2>>_ NEW USER</h2>

        <?php if ($registerError): ?>
            <p style="color:red; font-weight:bold; margin-bottom:10px;"><?php echo htmlspecialchars($registerError); ?></p>
        <?php endif; ?>

        <form action="login.php" method="POST">
            <label>usr:</label>
            <input type="text" name="username" placeholder="username" required autocomplete="off">

            <label>email:</label>
            <input type="email" name="email" placeholder="mail@host.com" required autocomplete="off">

            <label>pwd:</label>
            <input type="password" name="password" required>

            <label style="display:flex; align-items:center; gap:8px; margin-top:12px; font-size:13px; color:#ddd; cursor:pointer;">
                <input type="checkbox" name="recibir_novedades" value="1" style="width:auto; margin:0;">
                Recibir novedades, nuevos retos y avisos de la plataforma
            </label>

            <button type="submit" name="register">REGISTER</button>
        </form>

        <span class="toggle-link" onclick="toggleForms()">[ Volver al Login ]</span>
    </div>

</div>

<script>
function toggleForms() {
    var login = document.getElementById('login-form');
    var register = document.getElementById('register-form');

    if (login.style.display === "none") {
        login.style.display = "block";
        register.style.display = "none";
    } else {
        login.style.display = "none";
        register.style.display = "block";
    }
}

<?php if ($registerSuccess): ?>
document.getElementById('login-form').style.display = 'block';
document.getElementById('register-form').style.display = 'none';
<?php endif; ?>

<?php if ($registerError): ?>
document.getElementById('login-form').style.display = 'none';
document.getElementById('register-form').style.display = 'block';
<?php endif; ?>
</script>

</body>
</html>
