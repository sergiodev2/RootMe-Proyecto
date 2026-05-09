<?php
session_start();
require_once 'auth.php';
require_once 'db.php';

$is_logged = isset($_SESSION['user_id']);
$username  = $_SESSION['username'] ?? 'Guest';
$rol = isset($_SESSION['rol']) ? (int)$_SESSION['rol'] : 0;
$is_admin = ($rol === 1);

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
        .posts-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 20px; }
        .post-card { border: 1px solid #333; background: rgba(10,10,10,.9); padding: 15px; transition: .3s; cursor: pointer; position: relative; display: flex; flex-direction: column; justify-content: space-between; }
        .post-card:hover { border-color: #00ff41; box-shadow: 0 0 15px rgba(0,255,65,.2); transform: translateY(-5px); }
        .card-title { color: #fff; margin: 0 0 10px 0; font-size: 1.2rem; text-transform: uppercase; }
        .card-preview { font-size: .85rem; color: #aaa; margin-bottom: 10px; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; }
        .card-meta { font-size: .7rem; color: #555; border-top: 1px solid #222; padding-top: 10px; display: flex; justify-content: space-between; align-items: center; }
        .admin-link { color:#EBFF00; text-decoration:none; font-size:.7rem; border:1px solid #EBFF00; padding:2px 6px; }
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,.9); backdrop-filter: blur(5px); }
        .modal-content { background-color: #0a0a0a; border: 2px solid #00ff41; margin: 5% auto; padding: 40px; width: 80%; max-width: 800px; max-height: 80vh; overflow-y: auto; box-shadow: 0 0 50px rgba(0,255,65,.2); position: relative; }
        .close-btn { color: #d32f2f; float: right; font-size: 28px; font-weight: bold; cursor: pointer; }
        .close-btn:hover { color: #fff; }
        #modalTitle { color: #fff; font-size: 2rem; border-bottom: 1px solid #333; padding-bottom: 10px; }
        #modalBody { font-size: 1rem; line-height: 1.6; margin-top: 20px; color: #ddd; white-space: pre-wrap; }
        #modalImg { margin-top: 30px; width: 100%; height: auto; border: 1px solid #333; display: none; }
    </style>
</head>
<body>

    <nav>
        <div class="logo"><a href="index.php">>_ root<span>me</span></a></div>
        <div class="nav-links">
            <a href="start.php">Retos</a>
            <a href="ranking.php">Ranking</a>
            <a href="contacto.php">Contacto</a>
            <?php if ($is_logged): ?>
                <?php if ($is_admin): ?>
                    <a href="admin_dashboard.php" style="color:#EBFF00; margin-left:20px; text-decoration:none;">[ <?php echo htmlspecialchars($username); ?> ]</a>
                <?php else: ?>
                    <span style="color:#EBFF00; margin-left:20px;">[ <?php echo htmlspecialchars($username); ?> ]</span>
                <?php endif; ?>
                <a href="logout.php" class="btn-login2">LOGOUT</a>
            <?php endif; ?>
        </div>
    </nav>

    <div class="container">
        <h1>>_ ACADEMIA_ROOT</h1>
        <p>Base de datos de inteligencia colectiva.</p>
        <?php if ($is_admin): ?>
            <p style="color:#777;font-size:.85rem;">La publicación de posts se gestiona desde <a href="admin_dashboard.php#academia" style="color:#EBFF00;">Admin Control Center</a>.</p>
        <?php endif; ?>
        <hr style="border-color:#333; margin-bottom:30px;">

        <div class="posts-grid">
            <?php if ($posts && $posts->num_rows > 0): ?>
                <?php while ($row = $posts->fetch_assoc()): ?>
                    <div class="post-card" onclick="openModal(this)">
                        <div class="hidden-data" style="display:none;">
                            <div class="full-title"><?php echo htmlspecialchars($row['title']); ?></div>
                            <div class="full-content"><?php echo htmlspecialchars($row['content']); ?></div>
                            <div class="full-author"><?php echo htmlspecialchars($row['author']); ?></div>
                            <div class="full-date"><?php echo htmlspecialchars($row['created_at']); ?></div>
                            <div class="full-img"><?php echo !empty($row['image_path']) ? htmlspecialchars($row['image_path']) : ''; ?></div>
                        </div>
                        <h3 class="card-title"><?php echo htmlspecialchars($row['title']); ?></h3>
                        <div class="card-preview"><?php echo htmlspecialchars(mb_substr($row['content'], 0, 100)) . '...'; ?></div>
                        <div class="card-meta">
                            <span>BY: <?php echo htmlspecialchars($row['author']); ?></span>
                            <?php if ($is_admin): ?>
                                <a class="admin-link" href="admin_dashboard.php?edit_post=<?php echo (int)$row['id']; ?>#academia" onclick="event.stopPropagation();">EDIT</a>
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
            <h2 id="modalTitle">Título</h2>
            <div style="color:#d32f2f; font-size:.8rem; margin-bottom:20px;" id="modalMeta"></div>
            <div id="modalBody">Contenido del artículo...</div>
            <img id="modalImg" src="" alt="Imagen del artículo">
        </div>
    </div>

    <footer>root@server:~$ sudo shutdown -h now</footer>

    <script>
        function openModal(cardElement) {
            var title = cardElement.querySelector('.full-title').innerText;
            var content = cardElement.querySelector('.full-content').innerText;
            var author = cardElement.querySelector('.full-author').innerText;
            var date = cardElement.querySelector('.full-date').innerText;
            var imgPath = cardElement.querySelector('.full-img').innerText;
            document.getElementById('modalTitle').innerText = title;
            document.getElementById('modalBody').innerText = content;
            document.getElementById('modalMeta').innerText = "USR: " + author + " // TIME: " + date;
            var imgElement = document.getElementById('modalImg');
            if (imgPath && imgPath.trim() !== "") {
                imgElement.src = imgPath.trim();
                imgElement.style.display = "block";
            } else {
                imgElement.src = "";
                imgElement.style.display = "none";
            }
            document.getElementById('articleModal').style.display = "block";
        }
        function closeModal() { document.getElementById('articleModal').style.display = "none"; }
        window.onclick = function(event) {
            var modal = document.getElementById('articleModal');
            if (event.target === modal) modal.style.display = "none";
        }
    </script>
</body>
</html>
