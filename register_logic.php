<?php
require 'db.php';

$username = $_POST['username'];
$email    = $_POST['email'];
$password = $_POST['password'];

if (!$username || !$email || !$password) {
    die("Faltan datos");
}

$password_hash = password_hash($password, PASSWORD_DEFAULT);

$sql = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("sss", $username, $email, $password_hash);

if ($stmt->execute()) {
    echo "Usuario creado correctamente <br>";
    echo "<a href='index.html'>Volver al login</a>";
} else {
    echo "Error: " . $stmt->error;
}
?>

