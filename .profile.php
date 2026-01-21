<?php
session_start();
require "db.php";

$user_id = $_SESSION['user_id'];

// Obtener datos actuales del perfil
$stmt = $conn->prepare("SELECT address, birthdate, phone, extra_email FROM user_profile WHERE user_id = ?");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();
$profile = $result->fetch_assoc();

// Valores actuales (o vacíos si no existe perfil)
$address = $profile['address'] ?? '';
$birthdate = $profile['birthdate'] ?? '';
$phone = $profile['phone'] ?? '';
$extra_email = $profile['extra_email'] ?? '';
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Perfil del Usuario</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<h2 style="color:white;">Editar Perfil</h2>

<form action="profile_save.php" method="POST" class="profile-form">

    <label>Dirección de casa:</label>
    <input type="text" name="address" value="<?php echo htmlspecialchars($address); ?>">

    <label>Fecha de nacimiento:</label>
    <input type="date" name="birthdate" value="<?php echo htmlspecialchars($birthdate); ?>">

    <label>Teléfono:</label>
    <input type="text" name="phone" value="<?php echo htmlspecialchars($phone); ?>">

    <label>Email alternativo:</label>
    <input type="email" name="extra_email" value="<?php echo htmlspecialchars($extra_email); ?>">

    <button type="submit" class="btn-login2">Guardar cambios</button>
</form>

</body>
</html>

