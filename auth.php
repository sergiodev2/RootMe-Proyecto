<?php
session_start();

if (!isset($_SESSION['user_id']) || !isset($_SESSION['username'])) {
    header("Location: login.php");
    exit();
}

$userId = (int)$_SESSION['user_id'];
$username = $_SESSION['username'];
$rol = isset($_SESSION['rol']) ? (int)$_SESSION['rol'] : 0;
?>
