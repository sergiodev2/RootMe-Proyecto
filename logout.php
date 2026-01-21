<?php
session_start();
session_destroy(); // Destruye toda la información de la sesión
header("Location: index.php"); // Redirige al inicio
exit();
?>
