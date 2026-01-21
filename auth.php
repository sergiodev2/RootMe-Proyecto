<?php
session_start();

// Verificamos si la variable de sesión 'username' o 'user_id' existe
if (!isset($_SESSION['username'])) {
    // Si no está loggeado, lo mandamos al login
    header("Location: login.php");
    exit();
}else{
	echo "DEBUG 1: NO TIENES LA SESIÓN INICIADA";

};

// Opcional: Definir variables globales para usar en el resto de la página
$username = $_SESSION['username'];
?>
