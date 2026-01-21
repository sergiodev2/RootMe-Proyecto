<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);

require_once 'auth.php';   // ya inicia sesión
require_once 'db.php';     // $conn (mysqli)

/* =========================
   FIX user_id desde username
========================= */
if (!isset($_SESSION['user_id']) && isset($_SESSION['username'])) {
    $stmt = $conn->prepare("SELECT id FROM usuarios WHERE username = ?");
    $stmt->bind_param("s", $_SESSION['username']);
    $stmt->execute();
    $res = $stmt->get_result();
    if ($row = $res->fetch_assoc()) {
        $_SESSION['user_id'] = (int)$row['id'];
    }
}

$usuarioId = $_SESSION['user_id'] ?? null;
$retoId    = isset($_POST['reto_id']) ? (int)$_POST['reto_id'] : 0;
$flag      = trim($_POST['flag'] ?? '');

if (!$usuarioId || $retoId <= 0 || $flag === '') {
    $_SESSION['msg'] = "Datos inválidos.";
    $_SESSION['msg_type'] = "err";
    header("Location: start.php");
    exit;
}

/* =========================
   Obtener reto
========================= */
$stmt = $conn->prepare("
    SELECT id, puntos, flag_hash
    FROM retos
    WHERE id = ? AND activo = 1
");
$stmt->bind_param("i", $retoId);
$stmt->execute();
$res = $stmt->get_result();
$reto = $res->fetch_assoc();

if (!$reto) {
    $_SESSION['msg'] = "Reto no encontrado.";
    $_SESSION['msg_type'] = "err";
    header("Location: start.php");
    exit;
}

/* =========================
   ¿Ya resuelto?
========================= */
$stmt = $conn->prepare("
    SELECT 1 FROM solves
    WHERE usuario_id = ? AND reto_id = ?
");
$stmt->bind_param("ii", $usuarioId, $retoId);
$stmt->execute();
$res = $stmt->get_result();

if ($res->num_rows > 0) {
    $_SESSION['msg'] = "Este reto ya estaba resuelto.";
    $_SESSION['msg_type'] = "err";
    header("Location: reto.php?id=".$retoId);
    exit;
}

/* =========================
   Comprobar flag
========================= */
$flagHash = hash('sha256', $flag);
$correcta = hash_equals($reto['flag_hash'], $flagHash);

/* =========================
   Guardar intento
========================= */
$stmt = $conn->prepare("
    INSERT INTO submissions (usuario_id, reto_id, flag_enviada, es_correcta)
    VALUES (?, ?, ?, ?)
");
$ok = $correcta ? 1 : 0;
$stmt->bind_param("iisi", $usuarioId, $retoId, $flag, $ok);
$stmt->execute();

if (!$correcta) {
    $_SESSION['msg'] = "❌ Flag incorrecta.";
    $_SESSION['msg_type'] = "err";
    header("Location: reto.php?id=".$retoId);
    exit;
}

/* =========================
   Flag correcta → SOLVE + PUNTOS
========================= */
$conn->begin_transaction();

try {
    // Insertar solve
    $stmt = $conn->prepare("
        INSERT INTO solves (usuario_id, reto_id)
        VALUES (?, ?)
    ");
    $stmt->bind_param("ii", $usuarioId, $retoId);
    $stmt->execute();

    // Sumar puntos
    $stmt = $conn->prepare("
        UPDATE usuarios
        SET points = points + ?
        WHERE id = ?
    ");
    $stmt->bind_param("ii", $reto['puntos'], $usuarioId);
    $stmt->execute();

    $conn->commit();

    $_SESSION['msg'] = "✔ Flag correcta. +".$reto['puntos']." puntos.";
    $_SESSION['msg_type'] = "ok";

} catch (Exception $e) {
    $conn->rollback();
    $_SESSION['msg'] = "Error interno al guardar el solve.";
    $_SESSION['msg_type'] = "err";
}

header("Location: reto.php?id=".$retoId);
exit;

