<?php
session_start();
require "db.php";

if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

$user_id = $_SESSION['user_id'];

$address = $_POST['address'] ?? null;
$birthdate = $_POST['birthdate'] ?? null;
$phone = $_POST['phone'] ?? null;
$extra_email = $_POST['extra_email'] ?? null;

// ¿Ya existe perfil?
$check = $conn->prepare("SELECT id FROM user_profile WHERE user_id = ?");
$check->bind_param("i", $user_id);
$check->execute();
$check->store_result();

if ($check->num_rows > 0) {
    // UPDATE
    $update = $conn->prepare("UPDATE user_profile 
        SET address=?, birthdate=?, phone=?, extra_email=?
        WHERE user_id=?");
    $update->bind_param("ssssi", $address, $birthdate, $phone, $extra_email, $user_id);
    $update->execute();
} else {
    // INSERT
    $insert = $conn->prepare("INSERT INTO user_profile (user_id, address, birthdate, phone, extra_email)
        VALUES (?, ?, ?, ?, ?)");
    $insert->bind_param("issss", $user_id, $address, $birthdate, $phone, $extra_email);
    $insert->execute();
}

header("Location: profile.php?success=1");
exit();

