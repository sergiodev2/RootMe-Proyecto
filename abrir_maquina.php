<?php
session_start();
require_once 'db.php';
require_once 'auth.php';

if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

$id_usuario = (int) $_SESSION['user_id'];
$id_reto = (int) ($_GET['id'] ?? 0);
$cooldown = 60;

if ($id_reto <= 0) {
    $_SESSION['flash_error'] = 'Reto no válido.';
    header("Location: start.php");
    exit();
}


$sqlCooldown = "SELECT ultima_apertura FROM cooldown_conexiones WHERE id_usuario = ? LIMIT 1";
$stmtCooldown = $conn->prepare($sqlCooldown);

if (!$stmtCooldown) {
    $_SESSION['flash_error'] = 'Error al comprobar cooldown: ' . $conn->error;
    header("Location: start.php");
    exit();
}

$stmtCooldown->bind_param("i", $id_usuario);
$stmtCooldown->execute();
$resultCooldown = $stmtCooldown->get_result();
$filaCooldown = $resultCooldown->fetch_assoc();
$stmtCooldown->close();

$ahora = time();

if ($filaCooldown) {
    $ultimo = strtotime($filaCooldown['ultima_apertura']);
    $diferencia = $ahora - $ultimo;

    if ($diferencia < $cooldown) {
        $restante = $cooldown - $diferencia;
        $_SESSION['flash_error'] = "Debes esperar {$restante} segundos antes de volver a abrir una máquina.";
        header("Location: start.php?cooldown=" . $restante);
        exit();
    }

    $stmtUpdate = $conn->prepare("UPDATE cooldown_conexiones SET ultima_apertura = NOW() WHERE id_usuario = ?");
    if ($stmtUpdate) {
        $stmtUpdate->bind_param("i", $id_usuario);
        $stmtUpdate->execute();
        $stmtUpdate->close();
    }
} else {
    $stmtInsert = $conn->prepare("INSERT INTO cooldown_conexiones (id_usuario, ultima_apertura) VALUES (?, NOW())");
    if ($stmtInsert) {
        $stmtInsert->bind_param("i", $id_usuario);
        $stmtInsert->execute();
        $stmtInsert->close();
    }
}


$stmtReto = $conn->prepare("
    SELECT maquina_url, titulo, tipo_entorno, activo
    FROM retos
    WHERE id = ?
    LIMIT 1
");

if (!$stmtReto) {
    $_SESSION['flash_error'] = 'Error al preparar la apertura de la máquina: ' . $conn->error;
    header("Location: start.php");
    exit();
}

$stmtReto->bind_param("i", $id_reto);
$stmtReto->execute();
$resultReto = $stmtReto->get_result();
$reto = $resultReto->fetch_assoc();
$stmtReto->close();

if (!$reto) {
    $_SESSION['flash_error'] = 'La máquina no existe.';
    header("Location: start.php");
    exit();
}

if ((int)$reto['activo'] !== 1) {
    $_SESSION['flash_error'] = 'Esta máquina no está activa.';
    header("Location: start.php");
    exit();
}

if ($reto['tipo_entorno'] !== 'guacamole') {
    $_SESSION['flash_error'] = 'Esta máquina no es de tipo Guacamole.';
    header("Location: start.php");
    exit();
}

if (empty($reto['maquina_url'])) {
    $_SESSION['flash_error'] = 'La máquina no tiene URL configurada.';
    header("Location: start.php");
    exit();
}

header("Location: " . $reto['maquina_url']);
exit();
