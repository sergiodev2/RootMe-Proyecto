<?php
session_start();
require_once 'db.php';

if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header("Location: start.php");
    exit();
}

$userId = (int)($_SESSION['user_id'] ?? 0);
$retoId = (int)($_POST['reto_id'] ?? 0);
$flagEnviada = trim($_POST['flag'] ?? '');

if ($userId <= 0 || $retoId <= 0 || $flagEnviada === '') {
    $_SESSION['flash_error'] = 'Datos inválidos.';
    header("Location: start.php");
    exit();
}

try {
    $conn->begin_transaction();

    
    $stmtReto = $conn->prepare("SELECT id, titulo, puntos, flag, activo FROM retos WHERE id = ? LIMIT 1");
    if (!$stmtReto) {
        throw new Exception('Error al preparar la consulta del reto: ' . $conn->error);
    }

    $stmtReto->bind_param("i", $retoId);
    $stmtReto->execute();
    $reto = $stmtReto->get_result()->fetch_assoc();
    $stmtReto->close();

    if (!$reto) {
        throw new Exception('El reto no existe.');
    }

    if ((int)$reto['activo'] !== 1) {
        throw new Exception('Este reto está retirado y no permite verificación.');
    }

    $flagCorrecta = trim((string)($reto['flag'] ?? ''));

    if ($flagCorrecta === '') {
        throw new Exception('Este reto no tiene una flag configurada.');
    }

    
    $esCorrecta = hash_equals($flagCorrecta, $flagEnviada) ? 1 : 0;

    
    $stmtSubmission = $conn->prepare("\n        INSERT INTO submissions (usuario_id, reto_id, flag_enviada, es_correcta)\n        VALUES (?, ?, ?, ?)\n    ");
    if (!$stmtSubmission) {
        throw new Exception('Error al preparar el registro de submission: ' . $conn->error);
    }

    $stmtSubmission->bind_param("iisi", $userId, $retoId, $flagEnviada, $esCorrecta);
    $stmtSubmission->execute();
    $stmtSubmission->close();

    if ($esCorrecta === 1) {
        
        $stmtCheck = $conn->prepare("SELECT 1 FROM solves WHERE usuario_id = ? AND reto_id = ? LIMIT 1");
        if (!$stmtCheck) {
            throw new Exception('Error al comprobar solve: ' . $conn->error);
        }

        $stmtCheck->bind_param("ii", $userId, $retoId);
        $stmtCheck->execute();
        $yaResuelto = $stmtCheck->get_result()->fetch_row();
        $stmtCheck->close();

        if (!$yaResuelto) {
            $stmtSolve = $conn->prepare("INSERT INTO solves (usuario_id, reto_id) VALUES (?, ?)");
            if (!$stmtSolve) {
                throw new Exception('Error al insertar solve: ' . $conn->error);
            }

            $stmtSolve->bind_param("ii", $userId, $retoId);
            $stmtSolve->execute();
            $stmtSolve->close();

            $puntos = (int)$reto['puntos'];
            $stmtPoints = $conn->prepare("UPDATE usuarios SET points = points + ? WHERE id = ?");
            if (!$stmtPoints) {
                throw new Exception('Error al actualizar puntos: ' . $conn->error);
            }

            $stmtPoints->bind_param("ii", $puntos, $userId);
            $stmtPoints->execute();
            $stmtPoints->close();

            $_SESSION['flash_success'] = '¡Flag correcta! Has conseguido ' . $puntos . ' puntos.';
        } else {
            $_SESSION['flash_success'] = 'Flag correcta, pero este reto ya lo habías resuelto antes.';
        }
    } else {
        $_SESSION['flash_error'] = 'Flag incorrecta.';
    }

    $conn->commit();
} catch (Exception $e) {
    if (isset($conn) && $conn instanceof mysqli) {
        $conn->rollback();
    }

    $_SESSION['flash_error'] = 'Error: ' . $e->getMessage();
}

header("Location: start.php");
exit();
?>

