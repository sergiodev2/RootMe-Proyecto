<?php
session_start();
require 'auth.php'; // Verifica login y sesion
require 'db.php'; // Verifica conexion a la db

// Verificamos si es admin
$is_admin = ($username === 'admin'); // Pilla el nombre y mira si es admin, si es así TRUE a la variab. $is_admin

// ---------------------------------------------------------
// 1. LÓGICA: BORRAR POST (Solo Admin)
// ---------------------------------------------------------
if ($is_admin && isset($_POST['delete_id'])) { // Si la variable es que si (la de admin) y le ha dado al boton de borrar (abajo en el code)
    $id_to_delete = $_POST['delete_id'];
    

	$sql = "DELETE FROM academia_posts WHERE id = ?";
	$stmt = mysqli_prepare($conn, $sql);
	mysqli_stmt_bind_param($stmt, "i", $id_to_delete);
		if (mysqli_stmt_execute($stmt)) {
		    // Si se borró de la BD, intentamos borrar el archivo físico
		   $msg = "<p style='color:red; font-weight:bold;'>[!] ARCHIVO ELIMINADO DEL SISTEMA.</p>";
}
	mysqli_stmt_close($stmt);
}

// ---------------------------------------------------------
// 2. LÓGICA: SUBIR POST (Solo Admin)
// ---------------------------------------------------------
if ($is_admin && $_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['create_post'])) {
    $title = $_POST['title'];
    $content = $_POST['content'];
    $image_path = null;
    
    if (isset($_FILES['image']) && $_FILES['image']['error'] === 0) {
        $upload_dir = 'uploads/';
        if (!is_dir($upload_dir)) mkdir($upload_dir, 0777, true);
        $file_name = time() . '_' . basename($_FILES['image']['name']);
        $target_file = $upload_dir . $file_name;
        if (move_uploaded_file($_FILES['image']['tmp_name'], $target_file)) {
            $image_path = $target_file;
        }
    }

    $stmt = $conn->prepare("INSERT INTO academia_posts (title, content, image_path, author) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("ssss", $title, $content, $image_path, $username);
    if ($stmt->execute()) {
        $msg = "<p style='color:green; font-weight:bold;'>[+] NUEVOS DATOS PUBLICADOS.</p>";
    }
    $stmt->close();
}

// ---------------------------------------------------------
// 3. CONSULTA: LEER POSTS
// ---------------------------------------------------------
$sql = "SELECT * FROM academia_posts ORDER BY created_at DESC";
$posts = $conn->query($sql);
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>ROOT ME - Academia</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .container { max-width: 900px; margin: 40px auto; padding: 20px; position: relative; }
        
        /* Panel de subida */
        .admin-panel {
            border: 1px dashed #d32f2f;
            padding: 20px;
            margin-bottom: 40px;
            background: rgba(40, 0, 0, 0.3);
        }
        .admin-panel input, .admin-panel textarea {
            width: 100%; background: #000; border: 1px solid #333;
            color: #00ff41; padding: 10px; margin-bottom: 10px;
            font-family: 'Courier New', monospace; box-sizing: border-box;
        }
	
	.admin-panel button:hover {
	box-shadow: 0 0 15px red;

	

}

        /* --- ESTILOS DE LA LISTA (PREVIEWS) --- */
        .posts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }

        .post-card {
            border: 1px solid #333;
            background: rgba(10, 10, 10, 0.9);
            padding: 15px;
            transition: 0.3s;
            cursor: pointer; /* Manito al pasar el mouse */
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        
        .post-card:hover {
            border-color: #00ff41;
            box-shadow: 0 0 15px rgba(0, 255, 65, 0.2);
            transform: translateY(-5px);
        }

        .card-title {
            color: #fff;
            margin: 0 0 10px 0;
            font-size: 1.2rem;
            text-transform: uppercase;
        }

        .card-preview {
            font-size: 0.85rem;
            color: #aaa;
            margin-bottom: 10px;
            /* Limitar a 3 lineas */
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .card-meta {
            font-size: 0.7rem;
            color: #555;
            border-top: 1px solid #222;
            padding-top: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* Botón de borrar (pequeño y rojo) */
        .btn-delete {
            background: transparent;
            border: 1px solid #d32f2f;
            color: #d32f2f;
            font-size: 0.7rem;
            padding: 2px 5px;
            cursor: pointer;
            z-index: 10; /* Para que quede encima del enlace del modal */
        }
        .btn-delete:hover { background: #d32f2f; color: white; }

        /* --- ESTILOS DEL MODAL (VENTANA EMERGENTE) --- */
        .modal {
            display: none; /* Oculto por defecto */
            position: fixed; 
            z-index: 1000; 
            left: 0; top: 0;
            width: 100%; height: 100%; 
            background-color: rgba(0,0,0,0.9); /* Fondo negro semi-transparente */
            backdrop-filter: blur(5px);
        }

        .modal-content {
            background-color: #0a0a0a;
            border: 2px solid #00ff41;
            margin: 5% auto; 
            padding: 40px;
            width: 80%;
            max-width: 800px;
            max-height: 80vh; /* Altura máxima */
            overflow-y: auto; /* Scroll si es muy largo */
            box-shadow: 0 0 50px rgba(0, 255, 65, 0.2);
            position: relative;
        }

        /* Boton Cerrar Modal */
        .close-btn {
            color: #d32f2f;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        .close-btn:hover { color: #fff; }

        /* Estilos dentro del modal */
        #modalTitle { color: #fff; font-size: 2rem; border-bottom: 1px solid #333; padding-bottom: 10px; }
        #modalBody { font-size: 1rem; line-height: 1.6; margin-top: 20px; color: #ddd; white-space: pre-wrap; }
        #modalImg { 
            margin-top: 30px; 
            width: 100%; 
            height: auto; 
            border: 1px solid #333; 
            display: none; /* Se muestra con JS si hay imagen */
        }
    </style>
</head>
<body>

    <nav>
        <div class="logo">>_ root<span>me</span></div>
        <div class="nav-links">
            <a href="indexlogged.php">HOME</a>
            <span style="color: #EBFF00; margin-left:20px;">[ <?php echo htmlspecialchars($username); ?> ]</span>
            <a href="logout.php" class="btn-login2">LOGOUT</a>
        </div>
    </nav>

    <div class="container">
        <h1>>_ ACADEMIA_ROOT</h1>
        <p>Base de datos de inteligencia colectiva.</p>
        <hr style="border-color:#333; margin-bottom:30px;">
        
        <?php if(isset($msg)) echo $msg; ?>

        <?php if ($is_admin): ?>
            <div class="admin-panel">
                <h3 style="color:#d32f2f; margin-top:0;">SUBIR ARTICULOS A LA ACADEMINA</h3>
                <form action="academia.php" method="POST" enctype="multipart/form-data">
                    <input type="text" name="title" required placeholder="TITULO DEL HACK...">
                    <textarea name="content" rows="4" required placeholder="CONTENIDO..."></textarea>
                    <input type="file" name="image" accept="image/*" style="border:none;">
                    <button type="submit" name="create_post" class="cta-btn" style="color:red; width:100%;border-color:#d32f2f; margin-top:10px; !important">PUBLICAR</button>
                </form>
            </div>
        <?php endif; ?>

        <div class="posts-grid">
            <?php if ($posts->num_rows > 0): ?>
                <?php while($row = $posts->fetch_assoc()): ?>
                    
                    <div class="post-card" onclick="openModal(this)">
                        
                        <div class="hidden-data" style="display:none;">
                            <div class="full-title"><?php echo htmlspecialchars($row['title']); ?></div>
                            <div class="full-content"><?php echo htmlspecialchars($row['content']); ?></div>
                            <div class="full-author"><?php echo htmlspecialchars($row['author']); ?></div>
                            <div class="full-date"><?php echo $row['created_at']; ?></div>
                            <div class="full-img"><?php echo $row['image_path'] ? htmlspecialchars($row['image_path']) : ''; ?></div>
                        </div>

                        <h3 class="card-title"><?php echo htmlspecialchars($row['title']); ?></h3>
                        
                        <div class="card-preview">
                            <?php echo substr(htmlspecialchars($row['content']), 0, 100) . '...'; ?>
                        </div>

                        <div class="card-meta">
                            <span>BY: <?php echo htmlspecialchars($row['author']); ?></span>
                            
                            <?php if ($is_admin): ?>
                                <form method="POST" action="academia.php" onsubmit="return confirm('¿Eliminar definitivamente?');" style="display:inline;" onclick="event.stopPropagation();">
                                    <input type="hidden" name="delete_id" value="<?php echo $row['id']; ?>">
                                    <button type="submit" class="btn-delete">[ DEL ]</button>
                                </form>
                            <?php endif; ?>
                        </div>
                    </div>

                <?php endwhile; ?>
            <?php else: ?>
                <p style="color:#666;">[ SYSTEM EMPTY ] No hay registros.</p>
            <?php endif; ?>
        </div>
    </div>

    <div id="articleModal" class="modal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeModal()">&times;</span>
            <h2 id="modalTitle">Titulo</h2>
            <div style="color:#d32f2f; font-size:0.8rem; margin-bottom:20px;" id="modalMeta"></div>
            <div id="modalBody">Contenido del artículo...</div>
            <img id="modalImg" src="" alt="Evidence">
        </div>
    </div>

    <footer>
        root@server:~$ sudo shutdown -h now
    </footer>

    <script>
        function openModal(cardElement) {
            // Obtener los datos ocultos dentro de la tarjeta clickeada
            var title = cardElement.querySelector('.full-title').innerText;
            var content = cardElement.querySelector('.full-content').innerText;
            var author = cardElement.querySelector('.full-author').innerText;
            var date = cardElement.querySelector('.full-date').innerText;
            var imgPath = cardElement.querySelector('.full-img').innerText;

            // Rellenar el modal
            document.getElementById('modalTitle').innerText = title;
            document.getElementById('modalBody').innerText = content; // Mantiene saltos de linea gracias a CSS white-space
            document.getElementById('modalMeta').innerText = "USR: " + author + " // TIME: " + date;

            var imgElement = document.getElementById('modalImg');
            if (imgPath && imgPath.trim() !== "") {
                imgElement.src = imgPath;
                imgElement.style.display = "block";
            } else {
                imgElement.style.display = "none";
            }

            // Mostrar modal
            document.getElementById('articleModal').style.display = "block";
        }

        function closeModal() {
            document.getElementById('articleModal').style.display = "none";
        }

        // Cerrar si se hace click fuera del contenido
        window.onclick = function(event) {
            var modal = document.getElementById('articleModal');
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }
    </script>

</body>
</html>
