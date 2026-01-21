<?php
session_start();
require 'db.php'; 

$is_logged = isset($_SESSION['username']);
$username = $is_logged ? $_SESSION['username'] : 'Guest';

// Consulta Ranking
$sql = "SELECT username, points FROM usuarios ORDER BY points DESC LIMIT 3";
$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ROOT ME - Global Ranking</title>
    <link rel="stylesheet" href="style2.css">
</head>
<body>

    <nav>
        <div class="logo">>_ root<span>me</span></div>
        <div class="nav-links">
            <a href="indexlogged.php">HOME</a>
                <?php if ($is_logged): ?>
                <span style="color: #EBFF00; margin-left:20px;">[ <?php echo htmlspecialchars($username); ?> ]</span>
                <a href="logout.php" class="btn-login2">LOGOUT</a>
            <?php else: ?>
            <?php endif; ?>

        </div>
    </nav>

    <section class="hero" style="height: auto; min-height: 80vh; padding-top: 50px;">
        <h1><span style="color:white">SYSTEM</span> LEADERBOARD</h1>
        <p>Top 3 Operadores con mayor puntuación.</p>

        <div class="table-container">
            <table class="hack-table">
                <thead>
                    <tr>
                        <th>POS</th>
                        <th>OPERATOR</th>
                        <th>POINTS</th>
                        <th>BADGE</th>
                    </tr>
                </thead>
                <tbody>
                <?php 
                if ($result && $result->num_rows > 0) {
                    $rank = 1;
                    while($row = $result->fetch_assoc()) {
                        
                        // Definir trofeos y clases según la posición
                        $trophy = '';
                        $rowClass = '';

                        if($rank == 1) { 
                            $trophy = '👑 ROOT';
                            $rowClass = 'row-gold';
                        } elseif($rank == 2) { 
                            $trophy = '🥈 MASTER';
                            $rowClass = 'row-silver';
                        } elseif($rank == 3) { 
                            $trophy = '🥉 HACKER';
                            $rowClass = 'row-bronze';
                        }

                        echo "<tr class='$rowClass'>";
                        echo "<td>#$rank</td>";
                        echo "<td>" . htmlspecialchars($row['username']) . "</td>";
                        echo "<td>" . ($row['points'] ? $row['points'] : 0) . "</td>";
                        echo "<td>$trophy</td>";
                        echo "</tr>";
                        
                        $rank++;
                    }
                } else {
                    echo "<tr><td colspan='4'>No data found in /var/db/users</td></tr>";
                }
                ?>
                </tbody>
            </table>
        </div>

        <div class="cta-container">
            <a href="indexlogged.php" class="cta-btn">< Back to Shell</a>
        </div>
    </section>

    <footer>
        root@server:~$ cat /var/log/ranking.txt
    </footer>

</body>
</html>
