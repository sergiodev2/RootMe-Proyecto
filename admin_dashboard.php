<?php
session_start();
require_once 'db.php';
require_once 'auth.php';
require_once 'mail_academia.php';

if (!isset($_SESSION['user_id']) || !isset($_SESSION['rol']) || (int)$_SESSION['rol'] !== 1) {
    header("Location: index.php");
    exit();
}

$userIdSesion = (int)$_SESSION['user_id'];
$usernameSesion = $_SESSION['username'] ?? 'admin';

$editandoUsuario = null;
$editandoReto = null;
$editandoPost = null;

function setFlash($tipo, $mensaje) {
    $_SESSION['flash_' . $tipo] = $mensaje;
}

function limpiarTexto($valor) {
    return trim($valor ?? '');
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $accion = $_POST['accion'] ?? '';

    
    if ($accion === 'crear_usuario') {
        $username = limpiarTexto($_POST['username']);
        $email = limpiarTexto($_POST['email']);
        $password = limpiarTexto($_POST['password']);
        $points = (int)($_POST['points'] ?? 0);
        $rol = isset($_POST['rol']) ? (int)$_POST['rol'] : 0;
        $rol = ($rol === 1) ? 1 : 0;

        if ($username === '' || $email === '' || $password === '') {
            setFlash('error', 'Completa username, email y password.');
            header("Location: admin_dashboard.php#usuarios");
            exit();
        }

        $check = $conn->prepare("SELECT id FROM usuarios WHERE username = ? OR email = ? LIMIT 1");
        $check->bind_param("ss", $username, $email);
        $check->execute();
        $res = $check->get_result();

        if ($res->num_rows > 0) {
            setFlash('error', 'Ya existe un usuario con ese username o email.');
            header("Location: admin_dashboard.php#usuarios");
            exit();
        }

        $passwordHash = password_hash($password, PASSWORD_DEFAULT);

        $stmt = $conn->prepare("INSERT INTO usuarios (username, email, password_hash, points, rol) VALUES (?, ?, ?, ?, ?)");
        $stmt->bind_param("sssii", $username, $email, $passwordHash, $points, $rol);

        if ($stmt->execute()) {
            setFlash('success', 'Usuario creado correctamente.');
        } else {
            setFlash('error', 'Error al crear el usuario.');
        }

        $stmt->close();
        header("Location: admin_dashboard.php#usuarios");
        exit();
    }

    if ($accion === 'editar_usuario') {
        $id = (int)($_POST['id'] ?? 0);
        $username = limpiarTexto($_POST['username']);
        $email = limpiarTexto($_POST['email']);
        $password = limpiarTexto($_POST['password']);
        $points = (int)($_POST['points'] ?? 0);
        $rol = isset($_POST['rol']) ? (int)$_POST['rol'] : 0;
        $rol = ($rol === 1) ? 1 : 0;

        if ($id <= 0 || $username === '' || $email === '') {
            setFlash('error', 'Datos inválidos para editar usuario.');
            header("Location: admin_dashboard.php#usuarios");
            exit();
        }

        if ($id === $userIdSesion && $rol !== 1) {
            setFlash('error', 'No puedes quitarte el rol admin a ti mismo.');
            header("Location: admin_dashboard.php?edit_user=" . $id . "#usuarios");
            exit();
        }

        $check = $conn->prepare("SELECT id FROM usuarios WHERE (username = ? OR email = ?) AND id <> ? LIMIT 1");
        $check->bind_param("ssi", $username, $email, $id);
        $check->execute();
        $res = $check->get_result();

        if ($res->num_rows > 0) {
            setFlash('error', 'Ya existe otro usuario con ese username o email.');
            header("Location: admin_dashboard.php?edit_user=" . $id . "#usuarios");
            exit();
        }

        if ($password !== '') {
            $passwordHash = password_hash($password, PASSWORD_DEFAULT);
            $stmt = $conn->prepare("UPDATE usuarios SET username = ?, email = ?, password_hash = ?, points = ?, rol = ? WHERE id = ?");
            $stmt->bind_param("sssiii", $username, $email, $passwordHash, $points, $rol, $id);
        } else {
            $stmt = $conn->prepare("UPDATE usuarios SET username = ?, email = ?, points = ?, rol = ? WHERE id = ?");
            $stmt->bind_param("ssiii", $username, $email, $points, $rol, $id);
        }

        if ($stmt->execute()) {
            if ($id === $userIdSesion) {
                $_SESSION['username'] = $username;
                $_SESSION['rol'] = $rol;
            }
            setFlash('success', 'Usuario actualizado correctamente.');
        } else {
            setFlash('error', 'Error al actualizar el usuario.');
        }

        $stmt->close();
        header("Location: admin_dashboard.php#usuarios");
        exit();
    }

    if ($accion === 'eliminar_usuario') {
        $id = (int)($_POST['id'] ?? 0);

        if ($id <= 0) {
            setFlash('error', 'ID inválido.');
            header("Location: admin_dashboard.php#usuarios");
            exit();
        }

        if ($id === $userIdSesion) {
            setFlash('error', 'No puedes eliminar tu propio usuario.');
            header("Location: admin_dashboard.php#usuarios");
            exit();
        }

        $stmt = $conn->prepare("DELETE FROM usuarios WHERE id = ?");
        $stmt->bind_param("i", $id);

        if ($stmt->execute()) {
            setFlash('success', 'Usuario eliminado correctamente.');
        } else {
            setFlash('error', 'Error al eliminar el usuario.');
        }

        $stmt->close();
        header("Location: admin_dashboard.php#usuarios");
        exit();
    }

    
    if ($accion === 'crear_reto') {
        $titulo = limpiarTexto($_POST['titulo']);
        $descripcion = limpiarTexto($_POST['descripcion']);
        $puntos = (int)($_POST['puntos'] ?? 0);
        $dificultad = limpiarTexto($_POST['dificultad']);
        $categoria_id = (int)($_POST['categoria_id'] ?? 0);
        $activo = isset($_POST['activo']) ? (int)$_POST['activo'] : 1;
        $tipo_entorno = limpiarTexto($_POST['tipo_entorno']);
        $maquina_url = limpiarTexto($_POST['maquina_url']);
        $flag = limpiarTexto($_POST['flag']);

        if ($titulo === '' || $descripcion === '' || $categoria_id <= 0) {
            setFlash('error', 'Completa título, descripción y categoría.');
            header("Location: admin_dashboard.php#crear-reto");
            exit();
        }

        if (!in_array($dificultad, ['Fácil', 'Media', 'Difícil'], true)) {
            setFlash('error', 'Dificultad no válida.');
            header("Location: admin_dashboard.php#retos");
            exit();
        }

        if (!in_array($tipo_entorno, ['guacamole', 'descargable'], true)) {
            setFlash('error', 'Tipo de entorno no válido.');
            header("Location: admin_dashboard.php#retos");
            exit();
        }

        if ($activo === 1 && $flag === '') {
            setFlash('error', 'Las máquinas activas deben tener flag.');
            header("Location: admin_dashboard.php#retos");
            exit();
        }

        if ($tipo_entorno === 'guacamole' && $maquina_url === '') {
            setFlash('error', 'Debes indicar URL de máquina para Guacamole.');
            header("Location: admin_dashboard.php#retos");
            exit();
        }

        $archivo_descarga_db = null;

        if ($tipo_entorno === 'descargable') {
            if (!isset($_FILES['archivo_descarga_file']) || $_FILES['archivo_descarga_file']['error'] !== 0) {
                setFlash('error', 'Debes subir un archivo para un reto descargable.');
                header("Location: admin_dashboard.php#retos");
                exit();
            }

            $uploadDir = __DIR__ . '/descargas/';
            if (!is_dir($uploadDir)) {
                mkdir($uploadDir, 0777, true);
            }

            $nombreOriginal = basename($_FILES['archivo_descarga_file']['name']);
            $nombreSeguro = time() . '_' . preg_replace('/[^A-Za-z0-9._-]/', '_', $nombreOriginal);
            $rutaFisica = $uploadDir . $nombreSeguro;
            $rutaBD = 'descargas/' . $nombreSeguro;

            if (!move_uploaded_file($_FILES['archivo_descarga_file']['tmp_name'], $rutaFisica)) {
                setFlash('error', 'No se pudo subir el archivo descargable.');
                header("Location: admin_dashboard.php#retos");
                exit();
            }

            $archivo_descarga_db = $rutaBD;
        }

        $flag_db = null;
        if ($activo === 1 && $flag !== '') {
            $flag_db = $flag;
        }

        $maquina_url_db = ($tipo_entorno === 'guacamole') ? $maquina_url : null;

        $stmt = $conn->prepare("
            INSERT INTO retos (
                titulo, descripcion, puntos, dificultad, categoria_id, flag,
                activo, tipo_entorno, maquina_url, archivo_descarga
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ");
        $stmt->bind_param(
            "ssisisssss",
            $titulo,
            $descripcion,
            $puntos,
            $dificultad,
            $categoria_id,
            $flag_db,
            $activo,
            $tipo_entorno,
            $maquina_url_db,
            $archivo_descarga_db
        );

        if ($stmt->execute()) {
            setFlash('success', 'Reto creado correctamente.');
        } else {
            setFlash('error', 'Error al crear el reto.');
        }

        $stmt->close();
        header("Location: admin_dashboard.php#retos");
        exit();
    }

    if ($accion === 'editar_reto') {
        $id = (int)($_POST['id'] ?? 0);
        $titulo = limpiarTexto($_POST['titulo']);
        $descripcion = limpiarTexto($_POST['descripcion']);
        $puntos = (int)($_POST['puntos'] ?? 0);
        $dificultad = limpiarTexto($_POST['dificultad']);
        $categoria_id = (int)($_POST['categoria_id'] ?? 0);
        $activo = isset($_POST['activo']) ? (int)($_POST['activo']) : 1;
        $tipo_entorno = limpiarTexto($_POST['tipo_entorno']);
        $maquina_url = limpiarTexto($_POST['maquina_url']);
        $flag = limpiarTexto($_POST['flag']);

        if ($id <= 0 || $titulo === '' || $descripcion === '' || $categoria_id <= 0) {
            setFlash('error', 'Datos inválidos para editar reto.');
            header("Location: admin_dashboard.php#retos");
            exit();
        }

        $stmtOld = $conn->prepare("SELECT flag, archivo_descarga FROM retos WHERE id = ? LIMIT 1");
        $stmtOld->bind_param("i", $id);
        $stmtOld->execute();
        $old = $stmtOld->get_result()->fetch_assoc();
        $stmtOld->close();

        if (!$old) {
            setFlash('error', 'El reto no existe.');
            header("Location: admin_dashboard.php#retos");
            exit();
        }

        if ($activo === 1 && $flag === '') {
            $flag_db = $old['flag'] ?? null;

            if ($flag_db === null || trim((string)$flag_db) === '') {
                setFlash('error', 'Las máquinas activas deben tener flag.');
                header("Location: admin_dashboard.php?edit_reto=" . $id . "#retos");
                exit();
            }
        } else {
            $flag_db = ($activo === 1 && $flag !== '') ? $flag : null;
        }

        $archivo_descarga_db = null;

        if ($tipo_entorno === 'descargable') {
            $archivo_descarga_db = $old['archivo_descarga'] ?? null;

            if (isset($_FILES['archivo_descarga_file']) && $_FILES['archivo_descarga_file']['error'] === 0) {
                $uploadDir = __DIR__ . '/descargas/';
                if (!is_dir($uploadDir)) {
                    mkdir($uploadDir, 0777, true);
                }

                $nombreOriginal = basename($_FILES['archivo_descarga_file']['name']);
                $nombreSeguro = time() . '_' . preg_replace('/[^A-Za-z0-9._-]/', '_', $nombreOriginal);
                $rutaFisica = $uploadDir . $nombreSeguro;
                $rutaBD = 'descargas/' . $nombreSeguro;

                if (!move_uploaded_file($_FILES['archivo_descarga_file']['tmp_name'], $rutaFisica)) {
                    setFlash('error', 'No se pudo subir el nuevo archivo descargable.');
                    header("Location: admin_dashboard.php?edit_reto=" . $id . "#retos");
                    exit();
                }

                $archivo_descarga_db = $rutaBD;
            }

            if ($archivo_descarga_db === null || trim((string)$archivo_descarga_db) === '') {
                setFlash('error', 'Debes subir un archivo para un reto descargable.');
                header("Location: admin_dashboard.php?edit_reto=" . $id . "#retos");
                exit();
            }
        }

        $maquina_url_db = ($tipo_entorno === 'guacamole') ? $maquina_url : null;
        if ($tipo_entorno !== 'descargable') {
            $archivo_descarga_db = null;
        }

        $stmt = $conn->prepare("
            UPDATE retos
            SET titulo = ?, descripcion = ?, puntos = ?, dificultad = ?, categoria_id = ?,
                flag = ?, activo = ?, tipo_entorno = ?, maquina_url = ?, archivo_descarga = ?
            WHERE id = ?
        ");
        $stmt->bind_param(
            "ssisisssssi",
            $titulo,
            $descripcion,
            $puntos,
            $dificultad,
            $categoria_id,
            $flag_db,
            $activo,
            $tipo_entorno,
            $maquina_url_db,
            $archivo_descarga_db,
            $id
        );

        if ($stmt->execute()) {
            setFlash('success', 'Reto actualizado correctamente.');
        } else {
            setFlash('error', 'Error al actualizar el reto.');
        }

        $stmt->close();
        header("Location: admin_dashboard.php#retos");
        exit();
    }

    if ($accion === 'eliminar_reto') {
        $id = (int)($_POST['id'] ?? 0);

        if ($id <= 0) {
            setFlash('error', 'ID de reto inválido.');
            header("Location: admin_dashboard.php#retos");
            exit();
        }

        $stmtGet = $conn->prepare("SELECT archivo_descarga FROM retos WHERE id = ? LIMIT 1");
        $stmtGet->bind_param("i", $id);
        $stmtGet->execute();
        $reto = $stmtGet->get_result()->fetch_assoc();
        $stmtGet->close();

        $stmt = $conn->prepare("DELETE FROM retos WHERE id = ?");
        $stmt->bind_param("i", $id);

        if ($stmt->execute()) {
            if (!empty($reto['archivo_descarga'])) {
                $rutaFisica = __DIR__ . '/' . $reto['archivo_descarga'];
                if (is_file($rutaFisica)) {
                    @unlink($rutaFisica);
                }
            }
            setFlash('success', 'Reto eliminado correctamente.');
        } else {
            setFlash('error', 'Error al eliminar el reto.');
        }

        $stmt->close();
        header("Location: admin_dashboard.php#retos");
        exit();
    }

    
    if ($accion === 'crear_post') {
        $title = limpiarTexto($_POST['title']);
        $content = limpiarTexto($_POST['content']);
        $image_path = null;

        if ($title === '' || $content === '') {
            setFlash('error', 'Completa título y contenido del post.');
            header("Location: admin_dashboard.php#academia");
            exit();
        }

        if (isset($_FILES['image']) && $_FILES['image']['error'] === 0) {
            $upload_dir = './uploads/';
            if (!is_dir($upload_dir)) {
                mkdir($upload_dir, 0777, true);
            }

            $allowed_types = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
            $mime_type = mime_content_type($_FILES['image']['tmp_name']);

            if (!in_array($mime_type, $allowed_types, true)) {
                setFlash('error', 'La imagen debe ser JPG, PNG, WEBP o GIF.');
                header("Location: admin_dashboard.php#academia");
                exit();
            }

            $original_name = basename($_FILES['image']['name']);
            $safe_name = preg_replace('/[^a-zA-Z0-9._-]/', '_', $original_name);
            $file_name = time() . '_' . $safe_name;
            $target_file = $upload_dir . $file_name;

            if (move_uploaded_file($_FILES['image']['tmp_name'], $target_file)) {
                $image_path = $target_file;
            } else {
                setFlash('error', 'No se pudo subir la imagen del post.');
                header("Location: admin_dashboard.php#academia");
                exit();
            }
        }

        $stmt = $conn->prepare("INSERT INTO academia_posts (title, content, image_path, author) VALUES (?, ?, ?, ?)");
        $stmt->bind_param("ssss", $title, $content, $image_path, $usernameSesion);

        if ($stmt->execute()) {
            $nuevoPostId = $stmt->insert_id;
            $resultadoMail = enviarNotificacionesAcademia($conn, $nuevoPostId, $title, $content);

            if ($resultadoMail['enviados'] > 0) {
                setFlash('success', 'Post publicado correctamente. Correos enviados: ' . $resultadoMail['enviados'] . '.');
            } else {
                setFlash('success', 'Post publicado correctamente. No se enviaron correos. Revisa que los usuarios tengan email o el log de errores.');
            }
        } else {
            setFlash('error', 'Error al publicar el post.');
        }

        $stmt->close();
        header("Location: admin_dashboard.php#academia");
        exit();
    }

    if ($accion === 'editar_post') {
        $id = (int)($_POST['id'] ?? 0);
        $title = limpiarTexto($_POST['title']);
        $content = limpiarTexto($_POST['content']);

        if ($id <= 0 || $title === '' || $content === '') {
            setFlash('error', 'Datos inválidos para editar el post.');
            header("Location: admin_dashboard.php#academia");
            exit();
        }

        $stmt = $conn->prepare("UPDATE academia_posts SET title = ?, content = ? WHERE id = ?");
        $stmt->bind_param("ssi", $title, $content, $id);

        if ($stmt->execute()) {
            setFlash('success', 'Post actualizado correctamente.');
        } else {
            setFlash('error', 'Error al actualizar el post.');
        }

        $stmt->close();
        header("Location: admin_dashboard.php#academia");
        exit();
    }

    if ($accion === 'eliminar_post') {
        $id = (int)($_POST['id'] ?? 0);

        if ($id <= 0) {
            setFlash('error', 'ID de post inválido.');
            header("Location: admin_dashboard.php#academia");
            exit();
        }

        $stmt = $conn->prepare("DELETE FROM academia_posts WHERE id = ?");
        $stmt->bind_param("i", $id);

        if ($stmt->execute()) {
            setFlash('success', 'Post eliminado correctamente.');
        } else {
            setFlash('error', 'Error al eliminar el post.');
        }

        $stmt->close();
        header("Location: admin_dashboard.php#academia");
        exit();
    }
}


if (isset($_GET['edit_user'])) {
    $idEditar = (int)$_GET['edit_user'];
    if ($idEditar > 0) {
        $stmt = $conn->prepare("SELECT * FROM usuarios WHERE id = ? LIMIT 1");
        $stmt->bind_param("i", $idEditar);
        $stmt->execute();
        $editandoUsuario = $stmt->get_result()->fetch_assoc();
        $stmt->close();
    }
}

if (isset($_GET['edit_reto'])) {
    $idEditar = (int)$_GET['edit_reto'];
    if ($idEditar > 0) {
        $stmt = $conn->prepare("SELECT * FROM retos WHERE id = ? LIMIT 1");
        $stmt->bind_param("i", $idEditar);
        $stmt->execute();
        $editandoReto = $stmt->get_result()->fetch_assoc();
        $stmt->close();
    }
}

if (isset($_GET['edit_post'])) {
    $idEditar = (int)$_GET['edit_post'];
    if ($idEditar > 0) {
        $stmt = $conn->prepare("SELECT * FROM academia_posts WHERE id = ? LIMIT 1");
        $stmt->bind_param("i", $idEditar);
        $stmt->execute();
        $editandoPost = $stmt->get_result()->fetch_assoc();
        $stmt->close();
    }
}


$stats = [
    'usuarios_total' => 0,
    'admins_total' => 0,
    'usuarios_normales' => 0,
    'retos_total' => 0,
    'retos_activos' => 0,
    'retos_retirados' => 0,
    'posts_total' => 0,
    'submissions_total' => 0,
    'solves_total' => 0,
    'puntos_total' => 0,
];

$q = $conn->query("
    SELECT
        COUNT(*) AS usuarios_total,
        SUM(CASE WHEN rol = 1 THEN 1 ELSE 0 END) AS admins_total,
        SUM(CASE WHEN rol = 0 THEN 1 ELSE 0 END) AS usuarios_normales,
        SUM(points) AS puntos_total
    FROM usuarios
");
if ($q) {
    $row = $q->fetch_assoc();
    $stats['usuarios_total'] = (int)($row['usuarios_total'] ?? 0);
    $stats['admins_total'] = (int)($row['admins_total'] ?? 0);
    $stats['usuarios_normales'] = (int)($row['usuarios_normales'] ?? 0);
    $stats['puntos_total'] = (int)($row['puntos_total'] ?? 0);
}

$q = $conn->query("
    SELECT
        COUNT(*) AS retos_total,
        SUM(CASE WHEN activo = 1 THEN 1 ELSE 0 END) AS retos_activos,
        SUM(CASE WHEN activo = 0 THEN 1 ELSE 0 END) AS retos_retirados
    FROM retos
");
if ($q) {
    $row = $q->fetch_assoc();
    $stats['retos_total'] = (int)($row['retos_total'] ?? 0);
    $stats['retos_activos'] = (int)($row['retos_activos'] ?? 0);
    $stats['retos_retirados'] = (int)($row['retos_retirados'] ?? 0);
}

$q = $conn->query("SELECT COUNT(*) AS total FROM academia_posts");
if ($q) {
    $stats['posts_total'] = (int)($q->fetch_assoc()['total'] ?? 0);
}

$q = $conn->query("SELECT COUNT(*) AS total FROM submissions");
if ($q) {
    $stats['submissions_total'] = (int)($q->fetch_assoc()['total'] ?? 0);
}

$q = $conn->query("SELECT COUNT(*) AS total FROM solves");
if ($q) {
    $stats['solves_total'] = (int)($q->fetch_assoc()['total'] ?? 0);
}


function getParam($key, $default = '') {
    return trim($_GET[$key] ?? $default);
}

function getIntParam($key, $default = 1) {
    $value = isset($_GET[$key]) ? (int)$_GET[$key] : $default;
    return $value > 0 ? $value : $default;
}

function pagesCount($total, $perPage) {
    return max(1, (int)ceil($total / $perPage));
}

function buildUrl($params = []) {
    $query = array_merge($_GET, $params);
    foreach ($query as $k => $v) {
        if ($v === '' || $v === null) unset($query[$k]);
    }
    return 'admin_dashboard.php' . (count($query) ? '?' . http_build_query($query) : '');
}

function renderPagination($page, $totalPages, $pageKey, $anchor) {
    if ($totalPages <= 1) return;
    echo '<div class="pagination">';
    if ($page > 1) {
        echo '<a href="' . htmlspecialchars(buildUrl([$pageKey => $page - 1])) . '#' . $anchor . '">← Anterior</a>';
    }

    $start = max(1, $page - 2);
    $end = min($totalPages, $page + 2);

    if ($start > 1) {
        echo '<a href="' . htmlspecialchars(buildUrl([$pageKey => 1])) . '#' . $anchor . '">1</a>';
        if ($start > 2) echo '<span>...</span>';
    }

    for ($i = $start; $i <= $end; $i++) {
        $active = $i === $page ? ' class="active"' : '';
        echo '<a' . $active . ' href="' . htmlspecialchars(buildUrl([$pageKey => $i])) . '#' . $anchor . '">' . $i . '</a>';
    }

    if ($end < $totalPages) {
        if ($end < $totalPages - 1) echo '<span>...</span>';
        echo '<a href="' . htmlspecialchars(buildUrl([$pageKey => $totalPages])) . '#' . $anchor . '">' . $totalPages . '</a>';
    }

    if ($page < $totalPages) {
        echo '<a href="' . htmlspecialchars(buildUrl([$pageKey => $page + 1])) . '#' . $anchor . '">Siguiente →</a>';
    }
    echo '</div>';
}

$perPageUsuarios = 8;
$perPageRetos = 8;
$perPagePosts = 8;

$pageUsuarios = getIntParam('pu', 1);
$pageRetos = getIntParam('pr', 1);
$pagePosts = getIntParam('pp', 1);

$qUsuarios = getParam('qu');
$qRetos = getParam('qr');
$qPosts = getParam('qp');
$filtroEstadoReto = getParam('estado_reto', 'todos');
$filtroCategoriaReto = getIntParam('cat_reto', 0);

$categorias = [];
$res = $conn->query("SELECT id, nombre FROM categorias ORDER BY nombre ASC");
while ($res && $fila = $res->fetch_assoc()) {
    $categorias[] = $fila;
}


$whereUsuarios = "WHERE 1=1";
$paramsUsuarios = [];
$typesUsuarios = "";
if ($qUsuarios !== '') {
    $whereUsuarios .= " AND (username LIKE ? OR email LIKE ?)";
    $like = '%' . $qUsuarios . '%';
    $paramsUsuarios[] = $like;
    $paramsUsuarios[] = $like;
    $typesUsuarios .= "ss";
}
$stmt = $conn->prepare("SELECT COUNT(*) AS total FROM usuarios $whereUsuarios");
if ($paramsUsuarios) $stmt->bind_param($typesUsuarios, ...$paramsUsuarios);
$stmt->execute();
$totalUsuarios = (int)($stmt->get_result()->fetch_assoc()['total'] ?? 0);
$stmt->close();
$totalPagesUsuarios = pagesCount($totalUsuarios, $perPageUsuarios);
$pageUsuarios = min($pageUsuarios, $totalPagesUsuarios);
$offsetUsuarios = ($pageUsuarios - 1) * $perPageUsuarios;

$usuarios = [];
$stmt = $conn->prepare("SELECT id, username, email, fecha_registro, points, rol FROM usuarios $whereUsuarios ORDER BY id DESC LIMIT ? OFFSET ?");
$paramsUsuariosList = $paramsUsuarios;
$typesUsuariosList = $typesUsuarios . "ii";
$paramsUsuariosList[] = $perPageUsuarios;
$paramsUsuariosList[] = $offsetUsuarios;
$stmt->bind_param($typesUsuariosList, ...$paramsUsuariosList);
$stmt->execute();
$res = $stmt->get_result();
while ($fila = $res->fetch_assoc()) $usuarios[] = $fila;
$stmt->close();


$whereRetos = "WHERE 1=1";
$paramsRetos = [];
$typesRetos = "";
if ($qRetos !== '') {
    $whereRetos .= " AND (r.titulo LIKE ? OR r.descripcion LIKE ? OR c.nombre LIKE ?)";
    $like = '%' . $qRetos . '%';
    $paramsRetos[] = $like;
    $paramsRetos[] = $like;
    $paramsRetos[] = $like;
    $typesRetos .= "sss";
}
if ($filtroEstadoReto === 'activos') {
    $whereRetos .= " AND r.activo = 1";
} elseif ($filtroEstadoReto === 'retirados') {
    $whereRetos .= " AND r.activo = 0";
}
if ($filtroCategoriaReto > 0) {
    $whereRetos .= " AND r.categoria_id = ?";
    $paramsRetos[] = $filtroCategoriaReto;
    $typesRetos .= "i";
}

$stmt = $conn->prepare("SELECT COUNT(*) AS total FROM retos r INNER JOIN categorias c ON c.id = r.categoria_id $whereRetos");
if ($paramsRetos) $stmt->bind_param($typesRetos, ...$paramsRetos);
$stmt->execute();
$totalRetos = (int)($stmt->get_result()->fetch_assoc()['total'] ?? 0);
$stmt->close();
$totalPagesRetos = pagesCount($totalRetos, $perPageRetos);
$pageRetos = min($pageRetos, $totalPagesRetos);
$offsetRetos = ($pageRetos - 1) * $perPageRetos;

$retos = [];
$stmt = $conn->prepare("SELECT r.*, c.nombre AS categoria_nombre FROM retos r INNER JOIN categorias c ON c.id = r.categoria_id $whereRetos ORDER BY r.id DESC LIMIT ? OFFSET ?");
$paramsRetosList = $paramsRetos;
$typesRetosList = $typesRetos . "ii";
$paramsRetosList[] = $perPageRetos;
$paramsRetosList[] = $offsetRetos;
$stmt->bind_param($typesRetosList, ...$paramsRetosList);
$stmt->execute();
$res = $stmt->get_result();
while ($fila = $res->fetch_assoc()) $retos[] = $fila;
$stmt->close();


$wherePosts = "WHERE 1=1";
$paramsPosts = [];
$typesPosts = "";
if ($qPosts !== '') {
    $wherePosts .= " AND (title LIKE ? OR content LIKE ? OR author LIKE ?)";
    $like = '%' . $qPosts . '%';
    $paramsPosts[] = $like;
    $paramsPosts[] = $like;
    $paramsPosts[] = $like;
    $typesPosts .= "sss";
}
$stmt = $conn->prepare("SELECT COUNT(*) AS total FROM academia_posts $wherePosts");
if ($paramsPosts) $stmt->bind_param($typesPosts, ...$paramsPosts);
$stmt->execute();
$totalPosts = (int)($stmt->get_result()->fetch_assoc()['total'] ?? 0);
$stmt->close();
$totalPagesPosts = pagesCount($totalPosts, $perPagePosts);
$pagePosts = min($pagePosts, $totalPagesPosts);
$offsetPosts = ($pagePosts - 1) * $perPagePosts;

$posts = [];
$stmt = $conn->prepare("SELECT * FROM academia_posts $wherePosts ORDER BY created_at DESC LIMIT ? OFFSET ?");
$paramsPostsList = $paramsPosts;
$typesPostsList = $typesPosts . "ii";
$paramsPostsList[] = $perPagePosts;
$paramsPostsList[] = $offsetPosts;
$stmt->bind_param($typesPostsList, ...$paramsPostsList);
$stmt->execute();
$res = $stmt->get_result();
while ($fila = $res->fetch_assoc()) $posts[] = $fila;
$stmt->close();

$topUsuarios = [];
$res = $conn->query("
    SELECT u.id, u.username, u.points, COUNT(s.reto_id) AS solves
    FROM usuarios u
    LEFT JOIN solves s ON s.usuario_id = u.id
    GROUP BY u.id, u.username, u.points
    ORDER BY u.points DESC, solves DESC, u.username ASC
    LIMIT 5
");
while ($res && $fila = $res->fetch_assoc()) {
    $topUsuarios[] = $fila;
}

$ultimosSolves = [];
$res = $conn->query("
    SELECT s.resuelto_en, u.username, r.titulo
    FROM solves s
    INNER JOIN usuarios u ON u.id = s.usuario_id
    INNER JOIN retos r ON r.id = s.reto_id
    ORDER BY s.resuelto_en DESC
    LIMIT 6
");
while ($res && $fila = $res->fetch_assoc()) {
    $ultimosSolves[] = $fila;
}

$ultimasConexiones = [];
$res = $conn->query("
    SELECT username, ip_address, login_at
    FROM login_activity
    ORDER BY login_at DESC
    LIMIT 6
");
while ($res && $fila = $res->fetch_assoc()) {
    $ultimasConexiones[] = $fila;
}

$hayEdicion = $editandoUsuario || $editandoReto || $editandoPost;
$panelInicial = 'inicio';
if ($editandoUsuario) $panelInicial = 'usuarios';
if ($editandoReto) $panelInicial = 'retos';
if ($editandoPost) $panelInicial = 'academia';
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ROOT ME - Panel de administración</title>
    <link rel="stylesheet" href="style.css">
    <style>
        :root{
            --rm-bg:#070707;
            --rm-card:#101010;
            --rm-card2:#151515;
            --rm-border:#292929;
            --rm-yellow:#EBFF00;
            --rm-text:#f1f1f1;
            --rm-muted:#aaa;
            --rm-red:#d32f2f;
            --rm-green:#39d353;
            --rm-blue:#58a6ff;
        }
        body{background:var(--rm-bg);}
        .admin-shell{max-width:1320px;margin:0 auto;padding:24px;}
        .hero-admin{display:grid;grid-template-columns:1fr 1fr;gap:18px;margin-bottom:18px;align-items:stretch;}
        .hero-box,.soft-panel{background:linear-gradient(180deg,#111,#0b0b0b);border:1px solid var(--rm-border);border-radius:22px;padding:22px;box-shadow:0 18px 40px rgba(0,0,0,.24);height:100%;box-sizing:border-box;}
        .eyebrow{color:var(--rm-yellow);font-size:13px;letter-spacing:.12em;text-transform:uppercase;font-weight:800;margin-bottom:8px;}
        .page-title{color:#fff;font-size:34px;margin:0 0 8px;line-height:1.1;}
        .page-sub{color:var(--rm-muted);margin:0;font-size:15px;line-height:1.5;}
        .quick-actions{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:12px;margin-top:18px;}
        .quick-card{display:block;text-decoration:none;background:#0b0b0b;border:1px solid var(--rm-border);border-radius:18px;padding:16px;transition:.18s ease;min-height:88px;}
        .quick-card:hover{border-color:var(--rm-yellow);transform:translateY(-2px);}
        .quick-icon{font-size:25px;margin-bottom:8px;}
        .quick-title{display:block;color:#fff;font-weight:800;margin-bottom:4px;}
        .quick-desc{display:block;color:#aaa;font-size:13px;line-height:1.35;}
        .stats-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:12px;}
        .stat-card{background:#0b0b0b;border:1px solid var(--rm-border);border-radius:18px;padding:16px;}
        .stat-label{color:#aaa;font-size:13px;margin-bottom:6px;}
        .stat-value{color:#fff;font-size:28px;font-weight:900;}
        .summary-help{margin-top:14px;background:#0b0b0b;border:1px solid var(--rm-border);border-radius:18px;padding:16px;}
        .summary-help-title{color:#fff;font-weight:900;margin-bottom:10px;display:flex;align-items:center;gap:8px;}
        .summary-help-grid{display:grid;grid-template-columns:1fr 1fr;gap:10px;}
        .summary-help-item{border:1px solid #242424;border-radius:14px;padding:11px;background:#080808;}
        .summary-help-label{color:#999;font-size:12px;margin-bottom:5px;}
        .summary-help-value{color:#fff;font-size:14px;font-weight:800;line-height:1.3;}
        .summary-status-dot{display:inline-block;width:9px;height:9px;border-radius:50%;background:var(--rm-green);box-shadow:0 0 12px rgba(57,211,83,.65);}
        .admin-tabs{position:sticky;top:0;z-index:20;background:rgba(7,7,7,.92);backdrop-filter:blur(10px);border:1px solid var(--rm-border);border-radius:18px;padding:10px;display:flex;gap:8px;flex-wrap:wrap;margin:18px 0;}
        .tab-btn{border:1px solid transparent;background:transparent;color:#ddd;padding:11px 14px;border-radius:12px;cursor:pointer;font-weight:800;text-decoration:none;display:inline-flex;gap:8px;align-items:center;}
        .tab-btn:hover,.tab-btn.active{border-color:var(--rm-yellow);color:var(--rm-yellow);background:#111;}
        .tab-panel{display:none;}
        .tab-panel.active{display:block;}
        .panel-head{display:flex;align-items:flex-start;justify-content:space-between;gap:14px;margin-bottom:16px;}
        .panel-title{color:#fff;font-size:24px;margin:0 0 4px;}
        .panel-help{color:#aaa;margin:0;font-size:14px;line-height:1.45;}
        .big-button{border:1px solid var(--rm-yellow);background:var(--rm-yellow);color:#000;text-decoration:none;border-radius:14px;padding:12px 16px;font-weight:900;cursor:pointer;white-space:nowrap;}
        .big-button.dark{background:transparent;color:var(--rm-yellow);}
        .big-button.red{border-color:var(--rm-red);background:transparent;color:#ff7878;}
        .split{display:grid;grid-template-columns:1.05fr .95fr;gap:18px;}
        .form-card{background:#0b0b0b;border:1px solid var(--rm-border);border-radius:18px;padding:18px;margin-bottom:18px;}
        .form-card.hidden-by-default:not(.open){display:none;}
        .form-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:12px;}
        .form-grid input,.form-grid select,.form-grid textarea,.searchbar input,.searchbar select{width:100%;box-sizing:border-box;background:#080808;border:1px solid #303030;color:#eee;padding:12px 13px;border-radius:12px;outline:none;}
        .form-grid input:focus,.form-grid select:focus,.form-grid textarea:focus,.searchbar input:focus,.searchbar select:focus{border-color:var(--rm-yellow);}
        .form-grid textarea{grid-column:1/-1;min-height:120px;resize:vertical;}
        .file-note{color:#aaa;font-size:13px;grid-column:1/-1;}
        .form-actions{display:flex;gap:10px;flex-wrap:wrap;margin-top:14px;}
        .searchbar{display:grid;grid-template-columns:1fr auto auto auto;gap:10px;margin-bottom:14px;align-items:center;}
        .searchbar.retos{grid-template-columns:1fr 180px 220px auto auto;}
        .table-wrap{overflow-x:auto;border:1px solid var(--rm-border);border-radius:16px;}
        table{width:100%;border-collapse:collapse;background:#0b0b0b;}
        th,td{padding:13px;border-bottom:1px solid #222;text-align:left;color:#eaeaea;vertical-align:middle;}
        tr:last-child td{border-bottom:0;}
        th{color:var(--rm-yellow);font-weight:800;background:#101010;white-space:nowrap;}
        .row-main{font-weight:900;color:#fff;}
        .row-sub{color:#999;font-size:12px;margin-top:4px;}
        .actions{display:flex;gap:8px;flex-wrap:wrap;align-items:center;}
        .inline-form{display:inline;}
        .btn-admin{padding:9px 12px;border-radius:11px;border:1px solid var(--rm-red);background:transparent;color:#ff7a7a;cursor:pointer;text-decoration:none;display:inline-block;font-weight:800;font-size:13px;}
        .btn-admin.yellow{border-color:var(--rm-yellow);color:var(--rm-yellow);}
        .btn-admin.white{border-color:#777;color:#fff;}
        .btn-admin.green{border-color:#2e7d32;color:#7CFC90;}
        .badge{display:inline-block;padding:6px 10px;border-radius:999px;font-size:12px;border:1px solid #444;background:#080808;font-weight:800;white-space:nowrap;}
        .badge-admin{color:#7CFC90;border-color:#2e7d32;}.badge-user{color:#8ec5ff;border-color:#1976d2;}.badge-active{color:#7CFC90;border-color:#2e7d32;}.badge-retired{color:#ccc;border-color:#666;}.badge-hard{color:#ff8b8b;border-color:#d32f2f;}.badge-mid{color:#ffe066;border-color:#b7950b;}.badge-easy{color:#7CFC90;border-color:#2e7d32;}
        .alert-success,.alert-error{padding:13px 15px;border-radius:15px;margin:14px 0;font-weight:700;}
        .alert-success{background:#0d1b0f;border:1px solid #2e7d32;color:#7CFC90;}.alert-error{background:#1b0d0d;border:1px solid #d32f2f;color:#ff8b8b;}
        .mini-list{display:grid;gap:10px;}
        .mini-item{border:1px solid var(--rm-border);border-radius:14px;background:#0b0b0b;padding:13px;color:#ddd;line-height:1.45;}
        .mini-item strong{color:#fff;}
        .pagination{display:flex;gap:8px;flex-wrap:wrap;margin-top:14px;align-items:center;}
        .pagination a,.pagination span{padding:9px 12px;border-radius:10px;border:1px solid #333;text-decoration:none;color:#ddd;background:#0b0b0b;font-weight:800;}
        .pagination a.active{border-color:var(--rm-yellow);color:#000;background:var(--rm-yellow);}
        .empty-state{text-align:center;color:#aaa;padding:28px!important;}
        .mobile-card-list{display:none;gap:12px;}
        .mobile-card{background:#0b0b0b;border:1px solid var(--rm-border);border-radius:16px;padding:14px;}
        .anchor-target{scroll-margin-top:105px;}
        .mobile-card-top{display:flex;justify-content:space-between;gap:10px;margin-bottom:10px;}
        .mobile-card-title{color:#fff;font-weight:900;}
        .mobile-card-meta{color:#aaa;font-size:13px;line-height:1.45;margin:8px 0;}
        @media(max-width:1050px){.hero-admin,.split{grid-template-columns:1fr}.quick-actions{grid-template-columns:1fr}.stats-grid{grid-template-columns:repeat(2,1fr)}.searchbar,.searchbar.retos{grid-template-columns:1fr}.panel-head{flex-direction:column}.big-button{width:100%;text-align:center}.form-grid{grid-template-columns:1fr}}
        @media(max-width:760px){.admin-shell{padding:14px}.desktop-table{display:none}.mobile-card-list{display:grid}.page-title{font-size:28px}.stats-grid{grid-template-columns:1fr}.admin-tabs{position:static}.tab-btn{width:100%;justify-content:center}}
    </style>
</head>
<body>

<nav>
    <a href="index.php" style="text-decoration:none;"><div class="logo">>_ root<span>me</span></div></a>
    <div class="nav-links">
        <a href="start.php">Retos</a>
        <a href="academia.php">Academia</a>
        <a href="ranking.php">Ranking</a>
            <a href="contacto.php">Contacto</a>
        <span style="color:#EBFF00; margin-left:20px;">[ <?php echo htmlspecialchars($usernameSesion); ?> ]</span>
        <a href="logout.php" class="btn-login2 red">LOGOUT</a>
    </div>
</nav>

<div class="admin-shell">
    <?php if (!empty($_SESSION['flash_success'])): ?>
        <div class="alert-success"><?php echo htmlspecialchars($_SESSION['flash_success']); unset($_SESSION['flash_success']); ?></div>
    <?php endif; ?>
    <?php if (!empty($_SESSION['flash_error'])): ?>
        <div class="alert-error"><?php echo htmlspecialchars($_SESSION['flash_error']); unset($_SESSION['flash_error']); ?></div>
    <?php endif; ?>

    <section id="inicio" class="tab-panel <?php echo $panelInicial === 'inicio' ? 'active' : ''; ?>">
        <div class="hero-admin">
            <div class="hero-box">
                <div class="eyebrow">Panel de administración</div>
                <h1 class="page-title">¿Qué quieres hacer?</h1>
                <p class="page-sub">Cada botón lleva a una zona distinta. Dentro de cada zona están sus acciones: crear, buscar, editar o eliminar.</p>

                <div class="quick-actions">
                    <a class="quick-card" href="#usuarios" data-open-tab="usuarios">
                        <span class="quick-icon">👤</span>
                        <span class="quick-title">Usuarios</span>
                        <span class="quick-desc">Crear, buscar, editar o eliminar cuentas.</span>
                    </a>
                    <a class="quick-card" href="#retos" data-open-tab="retos" data-scroll-target="retos">
                        <span class="quick-icon">🎯</span>
                        <span class="quick-title">Retos</span>
                        <span class="quick-desc">Crear máquinas, modificar flags o retirar retos.</span>
                    </a>
                    <a class="quick-card" href="#academia" data-open-tab="academia">
                        <span class="quick-icon">📰</span>
                        <span class="quick-title">Academia</span>
                        <span class="quick-desc">Publicar, editar o borrar posts.</span>
                    </a>
                    <a class="quick-card" href="#actividad" data-open-tab="actividad">
                        <span class="quick-icon">📊</span>
                        <span class="quick-title">Actividad</span>
                        <span class="quick-desc">Solves, conexiones y top usuarios.</span>
                    </a>
                    <a class="quick-card" href="start.php">
                        <span class="quick-icon">🖥️</span>
                        <span class="quick-title">Ver retos públicos</span>
                        <span class="quick-desc">Comprobar cómo lo ve un usuario normal.</span>
                    </a>
                    <a class="quick-card" href="ranking.php">
                        <span class="quick-icon">🏆</span>
                        <span class="quick-title">Ver ranking</span>
                        <span class="quick-desc">Abrir la clasificación pública.</span>
                    </a>
                </div>
            </div>

            <div class="soft-panel">
                <div class="eyebrow">Resumen rápido</div>
                <div class="stats-grid">
                    <div class="stat-card"><div class="stat-label">Usuarios</div><div class="stat-value"><?php echo (int)$stats['usuarios_total']; ?></div></div>
                    <div class="stat-card"><div class="stat-label">Admins</div><div class="stat-value"><?php echo (int)$stats['admins_total']; ?></div></div>
                    <div class="stat-card"><div class="stat-label">Retos activos</div><div class="stat-value"><?php echo (int)$stats['retos_activos']; ?></div></div>
                    <div class="stat-card"><div class="stat-label">Retos retirados</div><div class="stat-value"><?php echo (int)$stats['retos_retirados']; ?></div></div>
                    <div class="stat-card"><div class="stat-label">Posts</div><div class="stat-value"><?php echo (int)$stats['posts_total']; ?></div></div>
                    <div class="stat-card"><div class="stat-label">Solves</div><div class="stat-value"><?php echo (int)$stats['solves_total']; ?></div></div>
                </div>

                <div class="summary-help">
                    <div class="summary-help-title"><span class="summary-status-dot"></span> Estado del panel</div>
                    <div class="summary-help-grid">
                        <div class="summary-help-item">
                            <div class="summary-help-label">Retos totales</div>
                            <div class="summary-help-value"><?php echo (int)$stats['retos_total']; ?> creados</div>
                        </div>
                        <div class="summary-help-item">
                            <div class="summary-help-label">Flags enviadas</div>
                            <div class="summary-help-value"><?php echo (int)$stats['submissions_total']; ?> intentos</div>
                        </div>
                        <div class="summary-help-item">
                            <div class="summary-help-label">Puntos repartidos</div>
                            <div class="summary-help-value"><?php echo (int)$stats['puntos_total']; ?> pts</div>
                        </div>
                        <div class="summary-help-item">
                            <div class="summary-help-label">Top usuario</div>
                            <div class="summary-help-value"><?php echo !empty($topUsuarios) ? htmlspecialchars($topUsuarios[0]['username']) . ' · ' . (int)$topUsuarios[0]['points'] . ' pts' : 'Sin ranking'; ?></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <div class="admin-tabs">
        <button class="tab-btn <?php echo $panelInicial === 'inicio' ? 'active' : ''; ?>" data-tab="inicio">🏠 Inicio</button>
        <button class="tab-btn <?php echo $panelInicial === 'usuarios' ? 'active' : ''; ?>" data-tab="usuarios">👤 Usuarios</button>
        <button class="tab-btn <?php echo $panelInicial === 'retos' ? 'active' : ''; ?>" data-tab="retos">🎯 Retos</button>
        <button class="tab-btn <?php echo $panelInicial === 'academia' ? 'active' : ''; ?>" data-tab="academia">📰 Academia</button>
        <button class="tab-btn <?php echo $panelInicial === 'actividad' ? 'active' : ''; ?>" data-tab="actividad">📊 Actividad</button>
    </div>

    <section id="usuarios" class="tab-panel <?php echo $panelInicial === 'usuarios' ? 'active' : ''; ?>">
        <div class="soft-panel">
            <div class="panel-head">
                <div>
                    <h2 class="panel-title">Usuarios</h2>
                    <p class="panel-help">Aquí están todas las acciones de usuarios. Usa el botón de la derecha para crear uno nuevo o la tabla para editar/eliminar.</p>
                </div>
                <button type="button" class="big-button" data-toggle-form="formUsuario"><?php echo $editandoUsuario ? 'Editando usuario' : '+ Crear usuario'; ?></button>
            </div>

            <div id="formUsuario" class="form-card hidden-by-default <?php echo $editandoUsuario ? 'open' : ''; ?>">
                <h3 class="panel-title" style="font-size:19px;"><?php echo $editandoUsuario ? 'Editar usuario' : 'Nuevo usuario'; ?></h3>
                <form method="POST" autocomplete="off">
                    <input type="hidden" name="accion" value="<?php echo $editandoUsuario ? 'editar_usuario' : 'crear_usuario'; ?>">
                    <?php if ($editandoUsuario): ?><input type="hidden" name="id" value="<?php echo (int)$editandoUsuario['id']; ?>"><?php endif; ?>
                    <div class="form-grid">
                        <input type="text" name="username" placeholder="Username" required value="<?php echo htmlspecialchars($editandoUsuario['username'] ?? ''); ?>">
                        <input type="email" name="email" placeholder="Email" required value="<?php echo htmlspecialchars($editandoUsuario['email'] ?? ''); ?>">
                        <input type="password" name="password" placeholder="<?php echo $editandoUsuario ? 'Nueva password, opcional' : 'Password'; ?>" <?php echo $editandoUsuario ? '' : 'required'; ?>>
                        <input type="number" name="points" placeholder="Puntos" min="0" value="<?php echo htmlspecialchars($editandoUsuario['points'] ?? '0'); ?>">
                        <select name="rol" required>
                            <option value="0" <?php echo (isset($editandoUsuario['rol']) && (int)$editandoUsuario['rol'] === 0) ? 'selected' : ''; ?>>Usuario normal</option>
                            <option value="1" <?php echo (isset($editandoUsuario['rol']) && (int)$editandoUsuario['rol'] === 1) ? 'selected' : ''; ?>>Administrador</option>
                        </select>
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="big-button"><?php echo $editandoUsuario ? 'Guardar cambios' : 'Crear usuario'; ?></button>
                        <?php if ($editandoUsuario): ?><a href="admin_dashboard.php#usuarios" class="big-button dark">Cancelar</a><?php endif; ?>
                    </div>
                </form>
            </div>

            <form class="searchbar" method="GET" action="admin_dashboard.php#usuarios">
                <input type="text" name="qu" placeholder="Buscar usuario por nombre o email..." value="<?php echo htmlspecialchars($qUsuarios); ?>">
                <input type="hidden" name="pu" value="1">
                <button class="big-button dark" type="submit">Buscar</button>
                <a class="btn-admin white" href="admin_dashboard.php#usuarios">Limpiar</a>
            </form>

            <div class="table-wrap desktop-table">
                <table>
                    <thead><tr><th>Usuario</th><th>Email</th><th>Registro</th><th>Puntos</th><th>Rol</th><th>Acciones</th></tr></thead>
                    <tbody>
                    <?php foreach ($usuarios as $u): ?>
                        <tr>
                            <td><div class="row-main"><?php echo htmlspecialchars($u['username']); ?></div><div class="row-sub">ID <?php echo (int)$u['id']; ?></div></td>
                            <td><?php echo htmlspecialchars($u['email']); ?></td>
                            <td><?php echo htmlspecialchars($u['fecha_registro']); ?></td>
                            <td><?php echo (int)$u['points']; ?></td>
                            <td><?php echo ((int)$u['rol'] === 1) ? '<span class="badge badge-admin">Admin</span>' : '<span class="badge badge-user">Usuario</span>'; ?></td>
                            <td><div class="actions"><a href="admin_dashboard.php?edit_user=<?php echo (int)$u['id']; ?>#usuarios" class="btn-admin yellow">Editar</a><?php if ((int)$u['id'] !== $userIdSesion): ?><form method="POST" class="inline-form" onsubmit="return confirm('¿Eliminar este usuario?');"><input type="hidden" name="accion" value="eliminar_usuario"><input type="hidden" name="id" value="<?php echo (int)$u['id']; ?>"><button type="submit" class="btn-admin">Eliminar</button></form><?php else: ?><span style="color:#777;">Tu usuario</span><?php endif; ?></div></td>
                        </tr>
                    <?php endforeach; ?>
                    <?php if (count($usuarios) === 0): ?><tr><td colspan="6" class="empty-state">No se encontraron usuarios.</td></tr><?php endif; ?>
                    </tbody>
                </table>
            </div>

            <div class="mobile-card-list">
                <?php foreach ($usuarios as $u): ?>
                    <div class="mobile-card"><div class="mobile-card-top"><div class="mobile-card-title"><?php echo htmlspecialchars($u['username']); ?></div><?php echo ((int)$u['rol'] === 1) ? '<span class="badge badge-admin">Admin</span>' : '<span class="badge badge-user">Usuario</span>'; ?></div><div class="mobile-card-meta"><?php echo htmlspecialchars($u['email']); ?><br>Puntos: <?php echo (int)$u['points']; ?> · ID <?php echo (int)$u['id']; ?></div><div class="actions"><a href="admin_dashboard.php?edit_user=<?php echo (int)$u['id']; ?>#usuarios" class="btn-admin yellow">Editar</a><?php if ((int)$u['id'] !== $userIdSesion): ?><form method="POST" class="inline-form" onsubmit="return confirm('¿Eliminar este usuario?');"><input type="hidden" name="accion" value="eliminar_usuario"><input type="hidden" name="id" value="<?php echo (int)$u['id']; ?>"><button type="submit" class="btn-admin">Eliminar</button></form><?php endif; ?></div></div>
                <?php endforeach; ?>
            </div>
            <?php renderPagination($pageUsuarios, $totalPagesUsuarios, 'pu', 'usuarios'); ?>
        </div>
    </section>

    <section id="retos" class="tab-panel <?php echo $panelInicial === 'retos' ? 'active' : ''; ?>">
        <div class="soft-panel">
            <div class="panel-head">
                <div><h2 class="panel-title">Retos</h2><p class="panel-help">Aquí están todas las acciones de retos. Usa el botón de la derecha para crear uno nuevo o la tabla para modificar/eliminar.</p></div>
                <button type="button" class="big-button" data-toggle-form="formReto"><?php echo $editandoReto ? 'Editando reto' : '+ Crear reto'; ?></button>
            </div>

            <div id="crear-reto" class="anchor-target"></div>
            <div id="formReto" class="form-card hidden-by-default <?php echo $editandoReto ? 'open' : ''; ?>">
                <h3 class="panel-title" style="font-size:19px;"><?php echo $editandoReto ? 'Editar reto' : 'Nuevo reto'; ?></h3>
                <form method="POST" enctype="multipart/form-data" autocomplete="off">
                    <input type="hidden" name="accion" value="<?php echo $editandoReto ? 'editar_reto' : 'crear_reto'; ?>">
                    <?php if ($editandoReto): ?><input type="hidden" name="id" value="<?php echo (int)$editandoReto['id']; ?>"><?php endif; ?>
                    <div class="form-grid">
                        <input type="text" name="titulo" placeholder="Título del reto" required value="<?php echo htmlspecialchars($editandoReto['titulo'] ?? ''); ?>">
                        <input type="number" name="puntos" placeholder="Puntos" min="0" value="<?php echo htmlspecialchars($editandoReto['puntos'] ?? '0'); ?>" required>
                        <select name="dificultad" required><option value="">Dificultad</option><?php foreach (['Fácil','Media','Difícil'] as $dif): ?><option value="<?php echo $dif; ?>" <?php echo (isset($editandoReto['dificultad']) && $editandoReto['dificultad'] === $dif) ? 'selected' : ''; ?>><?php echo $dif; ?></option><?php endforeach; ?></select>
                        <select name="categoria_id" required><option value="">Categoría</option><?php foreach ($categorias as $cat): ?><option value="<?php echo (int)$cat['id']; ?>" <?php echo (isset($editandoReto['categoria_id']) && (int)$editandoReto['categoria_id'] === (int)$cat['id']) ? 'selected' : ''; ?>><?php echo htmlspecialchars($cat['nombre']); ?></option><?php endforeach; ?></select>
                        <select name="activo" required><option value="1" <?php echo (isset($editandoReto['activo']) && (int)$editandoReto['activo'] === 1) ? 'selected' : ''; ?>>Activa</option><option value="0" <?php echo (isset($editandoReto['activo']) && (int)$editandoReto['activo'] === 0) ? 'selected' : ''; ?>>Retirada</option></select>
                        <select name="tipo_entorno" required><option value="guacamole" <?php echo (isset($editandoReto['tipo_entorno']) && $editandoReto['tipo_entorno'] === 'guacamole') ? 'selected' : ''; ?>>Guacamole</option><option value="descargable" <?php echo (isset($editandoReto['tipo_entorno']) && $editandoReto['tipo_entorno'] === 'descargable') ? 'selected' : ''; ?>>Descargable</option></select>
                        <input type="text" name="maquina_url" placeholder="URL máquina Guacamole" value="<?php echo htmlspecialchars($editandoReto['maquina_url'] ?? ''); ?>">
                        <input type="file" name="archivo_descarga_file">
                        <?php if (!empty($editandoReto['archivo_descarga'])): ?><div class="file-note">Archivo actual: <?php echo htmlspecialchars($editandoReto['archivo_descarga']); ?></div><?php endif; ?>
                        <input type="text" name="flag" placeholder="FLAG{...}" autocomplete="new-password">
                        <textarea name="descripcion" placeholder="Descripción del reto" required><?php echo htmlspecialchars($editandoReto['descripcion'] ?? ''); ?></textarea>
                    </div>
                    <div class="form-actions"><button type="submit" class="big-button"><?php echo $editandoReto ? 'Guardar cambios' : 'Crear reto'; ?></button><?php if ($editandoReto): ?><a href="admin_dashboard.php#retos" class="big-button dark">Cancelar</a><?php endif; ?></div>
                </form>
            </div>

            <div id="listado-retos" class="anchor-target"></div>
            <form class="searchbar retos" method="GET" action="admin_dashboard.php#retos">
                <input type="text" name="qr" placeholder="Buscar reto por título, descripción o categoría..." value="<?php echo htmlspecialchars($qRetos); ?>">
                <select name="estado_reto"><option value="todos" <?php echo $filtroEstadoReto === 'todos' ? 'selected' : ''; ?>>Todos</option><option value="activos" <?php echo $filtroEstadoReto === 'activos' ? 'selected' : ''; ?>>Activos</option><option value="retirados" <?php echo $filtroEstadoReto === 'retirados' ? 'selected' : ''; ?>>Retirados</option></select>
                <select name="cat_reto"><option value="0">Todas las categorías</option><?php foreach ($categorias as $cat): ?><option value="<?php echo (int)$cat['id']; ?>" <?php echo $filtroCategoriaReto === (int)$cat['id'] ? 'selected' : ''; ?>><?php echo htmlspecialchars($cat['nombre']); ?></option><?php endforeach; ?></select>
                <input type="hidden" name="pr" value="1"><button class="big-button dark" type="submit">Filtrar</button><a class="btn-admin white" href="admin_dashboard.php#retos">Limpiar</a>
            </form>

            <div class="table-wrap desktop-table"><table><thead><tr><th>Reto</th><th>Categoría</th><th>Dificultad</th><th>Puntos</th><th>Estado</th><th>Entorno</th><th>Acciones</th></tr></thead><tbody>
            <?php foreach ($retos as $r): ?>
                <tr><td><div class="row-main"><?php echo htmlspecialchars($r['titulo']); ?></div><div class="row-sub">ID <?php echo (int)$r['id']; ?></div></td><td><?php echo htmlspecialchars($r['categoria_nombre']); ?></td><td><?php $difClass = $r['dificultad']==='Fácil'?'badge-easy':($r['dificultad']==='Media'?'badge-mid':'badge-hard'); ?><span class="badge <?php echo $difClass; ?>"><?php echo htmlspecialchars($r['dificultad']); ?></span></td><td><?php echo (int)$r['puntos']; ?></td><td><?php echo ((int)$r['activo'] === 1) ? '<span class="badge badge-active">Activa</span>' : '<span class="badge badge-retired">Retirada</span>'; ?></td><td><?php echo htmlspecialchars($r['tipo_entorno']); ?></td><td><div class="actions"><a href="admin_dashboard.php?edit_reto=<?php echo (int)$r['id']; ?>#retos" class="btn-admin yellow">Editar</a><form method="POST" class="inline-form" onsubmit="return confirm('¿Eliminar este reto?');"><input type="hidden" name="accion" value="eliminar_reto"><input type="hidden" name="id" value="<?php echo (int)$r['id']; ?>"><button type="submit" class="btn-admin">Eliminar</button></form></div></td></tr>
            <?php endforeach; ?>
            <?php if (count($retos) === 0): ?><tr><td colspan="7" class="empty-state">No se encontraron retos.</td></tr><?php endif; ?>
            </tbody></table></div>
            <div class="mobile-card-list"><?php foreach ($retos as $r): ?><div class="mobile-card"><div class="mobile-card-top"><div class="mobile-card-title"><?php echo htmlspecialchars($r['titulo']); ?></div><?php echo ((int)$r['activo'] === 1) ? '<span class="badge badge-active">Activa</span>' : '<span class="badge badge-retired">Retirada</span>'; ?></div><div class="mobile-card-meta"><?php echo htmlspecialchars($r['categoria_nombre']); ?> · <?php echo htmlspecialchars($r['dificultad']); ?><br><?php echo (int)$r['puntos']; ?> puntos · <?php echo htmlspecialchars($r['tipo_entorno']); ?></div><div class="actions"><a href="admin_dashboard.php?edit_reto=<?php echo (int)$r['id']; ?>#retos" class="btn-admin yellow">Editar</a><form method="POST" class="inline-form" onsubmit="return confirm('¿Eliminar este reto?');"><input type="hidden" name="accion" value="eliminar_reto"><input type="hidden" name="id" value="<?php echo (int)$r['id']; ?>"><button type="submit" class="btn-admin">Eliminar</button></form></div></div><?php endforeach; ?></div>
            <?php renderPagination($pageRetos, $totalPagesRetos, 'pr', 'retos'); ?>
        </div>
    </section>

    <section id="academia" class="tab-panel <?php echo $panelInicial === 'academia' ? 'active' : ''; ?>">
        <div class="soft-panel">
            <div class="panel-head"><div><h2 class="panel-title">Academia</h2><p class="panel-help">Aquí están todas las acciones de Academia. Usa el botón de la derecha para publicar o la tabla para editar/eliminar.</p></div><button type="button" class="big-button" data-toggle-form="formPost"><?php echo $editandoPost ? 'Editando post' : '+ Publicar post'; ?></button></div>
            <div id="formPost" class="form-card hidden-by-default <?php echo $editandoPost ? 'open' : ''; ?>">
                <h3 class="panel-title" style="font-size:19px;"><?php echo $editandoPost ? 'Editar post' : 'Nuevo post'; ?></h3>
                <?php if ($editandoPost): ?>
                    <form method="POST"><input type="hidden" name="accion" value="editar_post"><input type="hidden" name="id" value="<?php echo (int)$editandoPost['id']; ?>"><div class="form-grid"><input type="text" name="title" placeholder="Título" required value="<?php echo htmlspecialchars($editandoPost['title']); ?>"><textarea name="content" placeholder="Contenido" required><?php echo htmlspecialchars($editandoPost['content']); ?></textarea></div><div class="form-actions"><button type="submit" class="big-button">Guardar cambios</button><a href="admin_dashboard.php#academia" class="big-button dark">Cancelar</a></div></form>
                <?php else: ?>
                    <form method="POST" enctype="multipart/form-data"><input type="hidden" name="accion" value="crear_post"><div class="form-grid"><input type="text" name="title" placeholder="Título del artículo" required><input type="file" name="image" accept="image/*"><textarea name="content" placeholder="Contenido del artículo" required></textarea></div><div class="form-actions"><button type="submit" class="big-button">Publicar post</button></div></form>
                <?php endif; ?>
            </div>
            <form class="searchbar" method="GET" action="admin_dashboard.php#academia"><input type="text" name="qp" placeholder="Buscar post por título, contenido o autor..." value="<?php echo htmlspecialchars($qPosts); ?>"><input type="hidden" name="pp" value="1"><button class="big-button dark" type="submit">Buscar</button><a class="btn-admin white" href="admin_dashboard.php#academia">Limpiar</a></form>
            <div class="table-wrap desktop-table"><table><thead><tr><th>Post</th><th>Autor</th><th>Fecha</th><th>Imagen</th><th>Acciones</th></tr></thead><tbody><?php foreach ($posts as $p): ?><tr><td><div class="row-main"><?php echo htmlspecialchars($p['title']); ?></div><div class="row-sub">ID <?php echo (int)$p['id']; ?></div></td><td><?php echo htmlspecialchars($p['author']); ?></td><td><?php echo htmlspecialchars($p['created_at']); ?></td><td><?php echo $p['image_path'] ? '<span class="badge badge-active">Sí</span>' : '<span class="badge badge-retired">No</span>'; ?></td><td><div class="actions"><a href="admin_dashboard.php?edit_post=<?php echo (int)$p['id']; ?>#academia" class="btn-admin yellow">Editar</a><form method="POST" class="inline-form" onsubmit="return confirm('¿Eliminar este post?');"><input type="hidden" name="accion" value="eliminar_post"><input type="hidden" name="id" value="<?php echo (int)$p['id']; ?>"><button type="submit" class="btn-admin">Eliminar</button></form></div></td></tr><?php endforeach; ?><?php if (count($posts) === 0): ?><tr><td colspan="5" class="empty-state">No se encontraron posts.</td></tr><?php endif; ?></tbody></table></div>
            <div class="mobile-card-list"><?php foreach ($posts as $p): ?><div class="mobile-card"><div class="mobile-card-title"><?php echo htmlspecialchars($p['title']); ?></div><div class="mobile-card-meta">Autor: <?php echo htmlspecialchars($p['author']); ?><br><?php echo htmlspecialchars($p['created_at']); ?></div><div class="actions"><a href="admin_dashboard.php?edit_post=<?php echo (int)$p['id']; ?>#academia" class="btn-admin yellow">Editar</a><form method="POST" class="inline-form" onsubmit="return confirm('¿Eliminar este post?');"><input type="hidden" name="accion" value="eliminar_post"><input type="hidden" name="id" value="<?php echo (int)$p['id']; ?>"><button type="submit" class="btn-admin">Eliminar</button></form></div></div><?php endforeach; ?></div>
            <?php renderPagination($pagePosts, $totalPagesPosts, 'pp', 'academia'); ?>
        </div>
    </section>

    <section id="actividad" class="tab-panel <?php echo $panelInicial === 'actividad' ? 'active' : ''; ?>">
        <div class="split">
            <div class="soft-panel"><h2 class="panel-title">Últimos solves</h2><div class="mini-list"><?php if (count($ultimosSolves)): foreach ($ultimosSolves as $solve): ?><div class="mini-item"><strong><?php echo htmlspecialchars($solve['username']); ?></strong> resolvió <strong><?php echo htmlspecialchars($solve['titulo']); ?></strong><br><span style="color:#aaa;"><?php echo htmlspecialchars($solve['resuelto_en']); ?></span></div><?php endforeach; else: ?><div class="mini-item">Todavía no hay solves registrados.</div><?php endif; ?></div></div>
            <div class="soft-panel"><h2 class="panel-title">Últimas conexiones</h2><div class="mini-list"><?php if (count($ultimasConexiones)): foreach ($ultimasConexiones as $login): ?><div class="mini-item"><strong><?php echo htmlspecialchars($login['username']); ?></strong><br>IP: <?php echo htmlspecialchars($login['ip_address']); ?><br><span style="color:#aaa;"><?php echo htmlspecialchars($login['login_at']); ?></span></div><?php endforeach; else: ?><div class="mini-item">No hay conexiones registradas.</div><?php endif; ?></div></div>
        </div>
        <div class="soft-panel" style="margin-top:18px;"><h2 class="panel-title">Top usuarios</h2><div class="table-wrap"><table><thead><tr><th>#</th><th>Usuario</th><th>Puntos</th><th>Solves</th></tr></thead><tbody><?php $pos=1; foreach ($topUsuarios as $u): ?><tr><td><?php echo $pos++; ?></td><td><?php echo htmlspecialchars($u['username']); ?></td><td><?php echo (int)$u['points']; ?></td><td><?php echo (int)$u['solves']; ?></td></tr><?php endforeach; ?><?php if (count($topUsuarios) === 0): ?><tr><td colspan="4" class="empty-state">Sin datos.</td></tr><?php endif; ?></tbody></table></div></div>
    </section>
</div>

<footer>root@server:~$ sudo shutdown -h now</footer>

<script>
(function(){
    const tabButtons = document.querySelectorAll('[data-tab]');
    const panels = document.querySelectorAll('.tab-panel');

    function openTab(name, hashName){
        panels.forEach(p => p.classList.toggle('active', p.id === name));
        tabButtons.forEach(b => b.classList.toggle('active', b.dataset.tab === name));
        history.replaceState(null, '', '#' + (hashName || name));
    }

    function scrollToTarget(targetId){
        const target = document.getElementById(targetId);
        if(target){
            setTimeout(() => target.scrollIntoView({behavior:'smooth', block:'start'}), 80);
        }else{
            window.scrollTo({top:0, behavior:'smooth'});
        }
    }

    tabButtons.forEach(btn => btn.addEventListener('click', () => openTab(btn.dataset.tab)));

    document.querySelectorAll('[data-open-tab]').forEach(link => {
        link.addEventListener('click', function(e){
            e.preventDefault();
            const hashName = (this.getAttribute('href') || '').replace('#','') || this.dataset.openTab;
            openTab(this.dataset.openTab, hashName);
            const formId = this.dataset.openForm;
            if(formId){
                const form = document.getElementById(formId);
                if(form) form.classList.add('open');
            }
            scrollToTarget(this.dataset.scrollTarget || this.dataset.openTab);
        });
    });

    document.querySelectorAll('[data-toggle-form]').forEach(btn => {
        btn.addEventListener('click', function(){
            const form = document.getElementById(this.dataset.toggleForm);
            if(form) form.classList.toggle('open');
        });
    });

    const hash = window.location.hash.replace('#','');
    if(hash){
        const tabNames = ['inicio','usuarios','retos','academia','actividad'];
        const innerTargets = {
            'crear-reto': 'retos',
            'listado-retos': 'retos'
        };
        if(tabNames.includes(hash)){
            openTab(hash);
        }else if(innerTargets[hash]){
            openTab(innerTargets[hash], hash);
            if(hash === 'crear-reto'){
                const form = document.getElementById('formReto');
                if(form) form.classList.add('open');
            }
            scrollToTarget(hash);
        }
    }
})();
</script>

</body>
</html>
