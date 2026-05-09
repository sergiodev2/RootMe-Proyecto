<?php
session_start();
require_once 'db.php';
require_once 'auth.php';

$is_logged = isset($_SESSION['user_id']);
$userId = $_SESSION['user_id'] ?? 0;
$username  = $_SESSION['username'] ?? 'Guest';
$rol = isset($_SESSION['rol']) ? (int)$_SESSION['rol'] : 0;

$sql = "
    SELECT 
        u.id,
        u.username,
        u.points,
        COUNT(s.reto_id) AS solves
    FROM usuarios u
    LEFT JOIN solves s ON s.usuario_id = u.id
    GROUP BY u.id, u.username, u.points
    ORDER BY u.points DESC, solves DESC, u.username ASC
";

$result = $conn->query($sql);

$ranking = [];
if ($result && $result->num_rows > 0) {
    while ($fila = $result->fetch_assoc()) {
        $ranking[] = $fila;
    }
}

$top1 = $ranking[0] ?? null;
$top2 = $ranking[1] ?? null;
$top3 = $ranking[2] ?? null;

$totalUsuarios = count($ranking);
$totalPuntos = 0;
$totalSolves = 0;
$miPosicion = null;

foreach ($ranking as $i => $user) {
    $totalPuntos += (int)$user['points'];
    $totalSolves += (int)$user['solves'];

    if ((int)$user['id'] === (int)$userId) {
        $miPosicion = $i + 1;
    }
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ranking - ROOT ME</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .page-wrap{max-width:1200px;margin:0 auto;padding:24px;}
        .page-title{color:#fff;font-size:38px;margin:10px 0 6px;text-align:center;}
        .page-sub{color:#b9b9b9;margin:0 0 24px;text-align:center;}

        .hero-ranking{
            background: radial-gradient(circle at top, rgba(211,47,47,0.18), transparent 45%),
                        radial-gradient(circle at center, rgba(0,255,65,0.08), transparent 55%),
                        #0f0f0f;
            border:1px solid #222;
            border-radius:18px;
            padding:28px;
            margin-bottom:24px;
            box-shadow: 0 0 35px rgba(0,0,0,0.35);
        }

        .stats-grid{
            display:grid;
            grid-template-columns:repeat(auto-fit, minmax(180px, 1fr));
            gap:14px;
            margin-bottom:26px;
        }

        .stat-card{
            background:#0b0b0b;
            border:1px solid #222;
            border-radius:14px;
            padding:16px;
            text-align:center;
        }

        .stat-label{
            color:#9a9a9a;
            font-size:13px;
            margin-bottom:8px;
            text-transform:uppercase;
            letter-spacing:1px;
        }

        .stat-value{
            color:#fff;
            font-size:30px;
            font-weight:700;
        }

        .stat-value.green{color:#7CFC90;}
        .stat-value.red{color:#ff6b6b;}
        .stat-value.blue{color:#8ec5ff;}
        .stat-value.yellow{color:#ffe082;}

        .podium-title{
            color:#fff;
            font-size:24px;
            margin:0 0 18px;
            text-align:center;
        }

        .podium{
            display:grid;
            grid-template-columns:1fr 1.2fr 1fr;
            gap:18px;
            align-items:end;
            margin-bottom:30px;
        }

        .podium-card{
            background:#0b0b0b;
            border:1px solid #222;
            border-radius:18px;
            padding:18px;
            text-align:center;
            position:relative;
            overflow:hidden;
        }

        .podium-card::before{
            content:"";
            position:absolute;
            inset:0;
            pointer-events:none;
            background:linear-gradient(180deg, rgba(255,255,255,0.04), transparent 35%);
        }

        .podium-card.first{
            min-height:300px;
            border-color:#EBFF00;
            box-shadow:0 0 25px rgba(235,255,0,0.12);
        }

        .podium-card.second{
            min-height:250px;
            border-color:#c0c0c0;
            box-shadow:0 0 20px rgba(192,192,192,0.08);
        }

        .podium-card.third{
            min-height:220px;
            border-color:#cd7f32;
            box-shadow:0 0 20px rgba(205,127,50,0.08);
        }

        .podium-rank{
            font-size:42px;
            margin-bottom:10px;
        }

        .podium-name{
            color:#fff;
            font-size:22px;
            font-weight:700;
            margin-bottom:10px;
            word-break:break-word;
        }

        .podium-meta{
            color:#bbb;
            font-size:14px;
            line-height:1.7;
        }

        .podium-points{
            font-size:30px;
            font-weight:800;
            margin-top:14px;
        }

        .first .podium-points{color:#EBFF00;}
        .second .podium-points{color:#d9d9d9;}
        .third .podium-points{color:#d89a5b;}

        .me-badge{
            display:inline-block;
            margin-top:10px;
            padding:5px 10px;
            border-radius:999px;
            border:1px solid #2e7d32;
            color:#7CFC90;
            font-size:12px;
        }

        .ranking-box{
            background:#0f0f0f;
            border:1px solid #222;
            border-radius:18px;
            overflow:hidden;
            box-shadow:0 0 25px rgba(0,0,0,0.25);
        }

        .ranking-head{
            display:flex;
            justify-content:space-between;
            align-items:center;
            gap:12px;
            padding:18px 20px;
            border-bottom:1px solid #222;
            background:#0b0b0b;
            flex-wrap:wrap;
        }

        .ranking-head h2{
            margin:0;
            color:#fff;
            font-size:22px;
        }

        .ranking-head p{
            margin:0;
            color:#999;
            font-size:14px;
        }

        .table-wrap{
            overflow-x:auto;
        }

        table{
            width:100%;
            border-collapse:collapse;
        }

        th, td{
            padding:16px 18px;
            text-align:left;
            border-bottom:1px solid #1f1f1f;
            color:#eaeaea;
            vertical-align:middle;
        }

        th{
            background:#101010;
            color:#fff;
            font-size:14px;
            text-transform:uppercase;
            letter-spacing:1px;
        }

        tr:hover td{
            background:#141414;
        }

        .pos{
            font-weight:800;
            color:#d32f2f;
            font-size:16px;
            width:80px;
        }

        .points{
            color:#7CFC90;
            font-weight:800;
        }

        .solves{
            color:#8ec5ff;
            font-weight:700;
        }

        .user-cell{
            display:flex;
            align-items:center;
            gap:12px;
        }

        .avatar{
            width:38px;
            height:38px;
            border-radius:50%;
            border:1px solid #333;
            background:#0b0b0b;
            display:flex;
            align-items:center;
            justify-content:center;
            color:#fff;
            font-weight:700;
            flex-shrink:0;
        }

        .medal{
            font-size:18px;
            margin-right:6px;
        }

        .me-row td{
            background:rgba(46, 125, 50, 0.08);
        }

        .me-row:hover td{
            background:rgba(46, 125, 50, 0.14);
        }

        .mini-badge{
            display:inline-block;
            margin-left:8px;
            padding:4px 8px;
            font-size:11px;
            border-radius:999px;
            border:1px solid #2e7d32;
            color:#7CFC90;
        }

        .empty{
            color:#b9b9b9;
            padding:24px;
            text-align:center;
        }

        @media (max-width: 900px){
            .podium{
                grid-template-columns:1fr;
                align-items:stretch;
            }

            .podium-card.first,
            .podium-card.second,
            .podium-card.third{
                min-height:auto;
            }
        }
    </style>
</head>
<body>

    <nav>
        <a href="index.php"><div class="logo">>_ root<span>me</span></div></a>
        <div class="nav-links">
            <a href="academia.php">Academia</a>
            <a href="start.php">Retos</a>

            <?php if ($is_logged): ?>
                <?php if ($rol === 1): ?>
                    <a href="admin_dashboard.php" style="color:#EBFF00; margin-left:20px; text-decoration:none;">[ <?php echo htmlspecialchars($username); ?> ]</a>
                <?php else: ?>
                    <span style="color:#d32f2f; margin-left:20px;">[ <?php echo htmlspecialchars($username); ?> ]</span>
                <?php endif; ?>
                <a href="logout.php" class="btn-login2" style="border-color:#FF0000 !important; color:#FF0000 !important;">LOGOUT</a>
            <?php else: ?>
                <a href="login.php" class="btn-login2">LOGIN</a>
            <?php endif; ?>
        </div>
    </nav>

    <div class="page-wrap">
        <div class="hero-ranking">
            <h1 class="page-title">Hall of Fame</h1>
            <p class="page-sub">Los mejores operadores de ROOT ME. Solo los más constantes dominan el ranking.</p>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-label">Usuarios en ranking</div>
                    <div class="stat-value red"><?php echo $totalUsuarios; ?></div>
                </div>

                <div class="stat-card">
                    <div class="stat-label">Puntos globales</div>
                    <div class="stat-value green"><?php echo $totalPuntos; ?></div>
                </div>

                <div class="stat-card">
                    <div class="stat-label">Solves totales</div>
                    <div class="stat-value blue"><?php echo $totalSolves; ?></div>
                </div>

                <div class="stat-card">
                    <div class="stat-label">Tu posición</div>
                    <div class="stat-value yellow"><?php echo $miPosicion !== null ? '#' . $miPosicion : '--'; ?></div>
                </div>
            </div>

            <h2 class="podium-title">Top 3 Operadores</h2>

            <div class="podium">
                <?php if ($top2): ?>
                    <div class="podium-card second">
                        <div class="podium-rank">🥈</div>
                        <div class="podium-name"><?php echo htmlspecialchars($top2['username']); ?></div>
                        <div class="podium-meta">
                            Solves: <?php echo (int)$top2['solves']; ?><br>
                            Posición: #2
                        </div>
                        <div class="podium-points"><?php echo (int)$top2['points']; ?> pts</div>
                        <?php if ((int)$top2['id'] === (int)$userId): ?>
                            <span class="me-badge">Tú</span>
                        <?php endif; ?>
                    </div>
                <?php else: ?>
                    <div class="podium-card second">
                        <div class="podium-rank">🥈</div>
                        <div class="podium-name">Sin rival</div>
                        <div class="podium-meta">Todavía no hay suficientes usuarios</div>
                    </div>
                <?php endif; ?>

                <?php if ($top1): ?>
                    <div class="podium-card first">
                        <div class="podium-rank">👑</div>
                        <div class="podium-name"><?php echo htmlspecialchars($top1['username']); ?></div>
                        <div class="podium-meta">
                            Solves: <?php echo (int)$top1['solves']; ?><br>
                            Posición: #1
                        </div>
                        <div class="podium-points"><?php echo (int)$top1['points']; ?> pts</div>
                        <?php if ((int)$top1['id'] === (int)$userId): ?>
                            <span class="me-badge">Tú</span>
                        <?php endif; ?>
                    </div>
                <?php else: ?>
                    <div class="podium-card first">
                        <div class="podium-rank">👑</div>
                        <div class="podium-name">Vacante</div>
                        <div class="podium-meta">Aún no hay datos</div>
                    </div>
                <?php endif; ?>

                <?php if ($top3): ?>
                    <div class="podium-card third">
                        <div class="podium-rank">🥉</div>
                        <div class="podium-name"><?php echo htmlspecialchars($top3['username']); ?></div>
                        <div class="podium-meta">
                            Solves: <?php echo (int)$top3['solves']; ?><br>
                            Posición: #3
                        </div>
                        <div class="podium-points"><?php echo (int)$top3['points']; ?> pts</div>
                        <?php if ((int)$top3['id'] === (int)$userId): ?>
                            <span class="me-badge">Tú</span>
                        <?php endif; ?>
                    </div>
                <?php else: ?>
                    <div class="podium-card third">
                        <div class="podium-rank">🥉</div>
                        <div class="podium-name">Vacante</div>
                        <div class="podium-meta">Aún no hay datos</div>
                    </div>
                <?php endif; ?>
            </div>
        </div>

        <div class="ranking-box">
            <div class="ranking-head">
                <div>
                    <h2>Clasificación completa</h2>
                    <p>Ordenada por puntos, solves y nombre de usuario.</p>
                </div>
            </div>

            <div class="table-wrap">
                <table>
                    <thead>
                        <tr>
                            <th>Pos.</th>
                            <th>Usuario</th>
                            <th>Puntos</th>
                            <th>Solves</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php if (count($ranking) > 0): ?>
                            <?php $pos = 1; ?>
                            <?php foreach ($ranking as $user): ?>
                                <?php
                                    $esMio = ((int)$user['id'] === (int)$userId);
                                    $medal = '';
                                    if ($pos === 1) $medal = '👑';
                                    if ($pos === 2) $medal = '🥈';
                                    if ($pos === 3) $medal = '🥉';
                                    $inicial = strtoupper(substr($user['username'], 0, 1));
                                ?>
                                <tr class="<?php echo $esMio ? 'me-row' : ''; ?>">
                                    <td class="pos">
                                        <?php if ($medal !== ''): ?>
                                            <span class="medal"><?php echo $medal; ?></span>
                                        <?php endif; ?>
                                        #<?php echo $pos; ?>
                                    </td>

                                    <td>
                                        <div class="user-cell">
                                            <div class="avatar"><?php echo htmlspecialchars($inicial); ?></div>
                                            <div>
                                                <?php echo htmlspecialchars($user['username']); ?>
                                                <?php if ($esMio): ?>
                                                    <span class="mini-badge">Tú</span>
                                                <?php endif; ?>
                                            </div>
                                        </div>
                                    </td>

                                    <td class="points"><?php echo (int)$user['points']; ?> pts</td>
                                    <td class="solves"><?php echo (int)$user['solves']; ?></td>
                                </tr>
                                <?php $pos++; ?>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <tr>
                                <td colspan="4" class="empty">No hay usuarios en el ranking.</td>
                            </tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <footer>
        root@server:~$ sudo shutdown -h now
    </footer>

</body>
</html>
