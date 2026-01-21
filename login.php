<?php

session_start();
require "db.php";


// Inicialización de variables
$error = '';
$registerError = '';
$registerSuccess = '';



if ($_SERVER['REQUEST_METHOD'] === 'POST') {


    // ------------------ LOGIN ------------------
    if (isset($_POST['login'])) {
        $username = $_POST['username'] ?? '';
        $password = $_POST['password'] ?? '';

        $stmt = $conn->prepare("SELECT password_hash FROM usuarios WHERE username = ?");
        if (!$stmt) {
            die("ERROR PREPARE LOGIN: " . $conn->error);
        }

        $stmt->bind_param("s", $username);
        $stmt->execute();
        $stmt->store_result();

        if ($stmt->num_rows > 0) {
            $stmt->bind_result($hash);
            $stmt->fetch();

            if (password_verify($password, $hash)) {
                echo "DEBUG: PASSWORD CORRECTA<br>";
		$_SESSION['username'] = $username;
                header("Location: indexlogged.php");

                exit();
            } else {
                $error = "❌ Credenciales incorrectas";
            }
        } else {
            $error = "❌ Usuario no encontrado";
        }

        $stmt->close();
    }

    // ------------------ REGISTRO ------------------
    if (isset($_POST['register'])) {

        echo "DEBUG: REGISTRO DETECTADO<br>";

        $newUser = $_POST['username'] ?? '';
        $newEmail = $_POST['email'] ?? '';
        $newPassword = $_POST['password'] ?? '';

        echo "DEBUG: PREPARANDO CONSULTA REGISTRO<br>";

        $stmt = $conn->prepare("SELECT id FROM usuarios WHERE username = ? OR email = ?");
        if (!$stmt) {
            die("ERROR PREPARE REGISTRO: " . $conn->error);
        }

        $stmt->bind_param("ss", $newUser, $newEmail);
        $stmt->execute();
        $stmt->store_result();

        echo "DEBUG: CONSULTA REGISTRO EJECUTADA<br>";

        if ($stmt->num_rows > 0) {
            $registerError = "❌ El usuario o email ya existen";
        } else {

            echo "DEBUG: INSERTANDO USUARIO<br>";

            $hash = password_hash($newPassword, PASSWORD_DEFAULT);

            $insert = $conn->prepare("INSERT INTO usuarios (username, email, password_hash) VALUES (?, ?, ?)");
            if (!$insert) {
                die("ERROR INSERT PREPARE: " . $conn->error);
            }

            $insert->bind_param("sss", $newUser, $newEmail, $hash);

            if ($insert->execute()) {
                $registerSuccess = "✅ Usuario registrado correctamente. Por favor, inicia sesión.";
            } else {
                $registerError = "❌ Error al registrar usuario";
            }

            $insert->close();
        }

        $stmt->close();
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

    <!-- LOGIN -->
    <div id="login-form" style="display:block;">
        <h2>>_ LOGIN</h2>

        <!-- Mensaje de error en rojo -->
        <?php if ($error): ?>
        <p style="color:red; font-weight:bold; margin-bottom:10px;"><?php echo $error; ?></p>
        <?php endif; ?>

        <!-- Mensaje de registro exitoso en verde -->
        <?php if ($registerSuccess): ?>
        <p style="color:green; font-weight:bold; margin-bottom:10px;"><?php echo $registerSuccess; ?></p>
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

    <!-- REGISTRO -->
    <div id="register-form" style="display:none;">
        <h2>>_ NEW USER</h2>

        <?php if ($registerError): ?>
        <p style="color:red; font-weight:bold; margin-bottom:10px;"><?php echo $registerError; ?></p>
        <?php endif; ?>

        <form action="login.php" method="POST">
            <label>usr:</label>
            <input type="text" name="username" placeholder="username" required autocomplete="off">

            <label>email:</label>
            <input type="email" name="email" placeholder="mail@host.com" required autocomplete="off">

            <label>pwd:</label>
            <input type="password" name="password" required>

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

// Si se registró correctamente, mostrar login automáticamente
<?php if ($registerSuccess): ?>
document.getElementById('login-form').style.display = 'block';
document.getElementById('register-form').style.display = 'none';
<?php endif; ?>
</script>

</body>
</html>

