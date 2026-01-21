-- phpMyAdmin SQL Dump
-- version 5.1.1deb5ubuntu1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 21-01-2026 a las 08:44:40
-- Versión del servidor: 10.6.22-MariaDB-0ubuntu0.22.04.1
-- Versión de PHP: 8.1.2-1ubuntu2.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `auth_system`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `academia_posts`
--

CREATE TABLE `academia_posts` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `author` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `academia_posts`
--

INSERT INTO `academia_posts` (`id`, `title`, `content`, `image_path`, `author`, `created_at`) VALUES
(1, 'DNSRECON', 'DNSRecon es una herramienta de línea de comandos en Python utilizada en pruebas de penetración para recopilar información sobre la infraestructura DNS de un objetivo, como registros A, MX, SOA, NS y TXT, además de intentar encontrar subdominios mediante la fuerza bruta y realizar transferencias de zona para descubrir más registros DNS.\r\n', 'uploads/1765963201_DNSRECON.png', 'admin', '2025-12-17 09:20:01'),
(2, 'Google Dorks', 'Google Dorks (Google Dorking) es una técnica avanzada para realizar búsquedas en Google utilizando comandos y operadores específicos para encontrar información más precisa como: subdominios ocultos, archivos, etc. \r\n\r\nA continuación una tabla con todos los parámetros.\r\n\r\n', 'uploads/1765965481_Captura de pantalla 2025-12-17 105744.png', 'admin', '2025-12-17 09:58:01'),
(3, 'BlueKeep', 'BlueKeep (CVE-2019-0708) es el nombre dado a una vulnerabilidad del RDP (Protocolo de Escritorio Remoto) en Windows que podría permitir a los atacantes ejecutar código arbitrario de forma remota y obtener acceso a un sistema Windows y, consecuentemente, a la red de la que forma parte ese sistema objetivo.\r\nLa vulnerabilidad BlueKeep fue hecha pública por Microsoft en mayo de 2019.\r\nEl exploit BlueKeep aprovecha una vulnerabilidad en el protocolo RDP de Windows que permite a los atacantes obtener acceso a un fragmento de la memoria del núcleo (kernel memory), permitiéndoles consecuentemente ejecutar código arbitrario a nivel del sistema sin necesidad de autenticación.\r\nLa vulnerabilidad BlueKeep cuenta con varias Pruebas de Concepto (PoC por sus siglas en inglés) y código de exploit ilegítimos que pueden ser de naturaleza maliciosa. Por lo tanto, se recomienda utilizar únicamente código de exploit y módulos verificados para la explotación.\r\nEl exploit BlueKeep tiene un módulo auxiliar de MSF (Metasploit Framework) que se puede usar para verificar si un sistema objetivo es vulnerable al exploit, y también tiene un módulo de exploit que se puede usar para aprovechar la vulnerabilidad en sistemas sin parches.\r\n', 'uploads/1766049700_BlueKeep-1024x585.png', 'admin', '2025-12-18 09:21:40'),
(4, 'Pivoting', 'El pivoting (o pivotaje) es una técnica de post-explotación que implica utilizar un host comprometido para atacar otros sistemas en la red interna privada del host comprometido.\r\nDespués de obtener acceso a un host, podemos usar el host comprometido para explotar otros hosts en la misma red interna a los que no podíamos acceder previamente.\r\n', 'uploads/1766051198_image-20.webp', 'admin', '2025-12-18 09:46:38'),
(6, 'Ping Sweeps', 'Un barrido de ping es una de las técnicas fundamentales en el descubrimiento y mapeo de redes. Aunque es una herramienta básica, es esencial para administradores de red, profesionales de ciberseguridad y hackers éticos.\r\n\r\n¿Cómo funciona exactamente?\r\n\r\nDefinición del Rango: El usuario o la herramienta selecciona un rango contiguo de direcciones IP, como, por ejemplo, de 192.168.1.1 a 192.168.1.254.\r\n\r\nEnvío de Pings: Se envía un paquete ICMP Echo Request a cada dirección IP dentro de ese rango.\r\nObservación de Respuestas:\r\n- Si una dirección IP corresponde a un host activo y no está bloqueando el tráfico ICMP, el host responderá con un paquete ICMP Echo Reply. Esto indica que el dispositivo está en línea.\r\n- Si el host está inactivo o la dirección no está en uso, no se recibirá respuesta.\r\n- Si un firewall está bloqueando el tráfico ICMP, es posible que tampoco haya respuesta, lo cual es una limitación clave de esta técnica', 'uploads/1766081903_hqdefault.jpg', 'admin', '2025-12-18 18:18:23'),
(8, 'WhatWeb', 'WhatWeb es un programa de código abierto para recopilar información sobre una aplicación web. Es un escáner de nueva generación que detecta las tecnologías utilizadas en el desarrollo de una página web. Su nombre, WhatWeb, responde a la pregunta: ¿qué sitio web es este? Por eso, WhatWeb permite identificar tecnologías como:\r\n\r\n- Sistemas de gestión de contenidos.\r\n- Plataformas de blog.\r\n- Paquetes de estadísticas/analítica.\r\n- Librerías de JavaScript.\r\n- Servidores web.\r\n- Dispositivos integrados.\r\n- Versiones de software.\r\n- Direcciones email relacionadas.\r\n- Módulos de frameworks utilizados.', 'uploads/1766084553_whatweb.png', 'admin', '2025-12-18 19:02:33'),
(9, 'Ataque XSS', 'Un ataque XSS (Cross-Site Scripting) es una vulnerabilidad web donde un atacante inyecta código malicioso (generalmente JavaScript) en una página legítima, que luego se ejecuta en el navegador de otros usuarios, permitiendo el robo de cookies, tokens de sesión, suplantación de identidad y otras acciones dañinas, ya que el código se ejecuta con los mismos permisos que la aplicación web.', 'uploads/1766084661_xss-attack.png', 'admin', '2025-12-18 19:04:21'),
(10, 'Vulnerabilidad Dirty Cow', 'El Ataque de Dirty COW es un caso interesante de una vulnerabilidad de race condition. Existe en el kernel de Linux desde Septiembre del 2007, fue descubierta y explotada en Octubre de 2016. Esta vulnerabilidad afecta a todos los sistemas operativos Linux-based incluyendo Android y su impacto en bastante grave:\r\n\r\n-Los atacantes pueden obtener privilegios de root explotando esta condicion. Esta vulnerbilidad reside en el codigo dentro del kernel de Linux en el mecanismo de copy-on-write (COW). Explotando esta vulnerabilidad los atacantes pueden modificar cualquier archivo protegido incluso archivos que son de solo lectura.', 'uploads/1766086421_1520102784792.jpg', 'admin', '2025-12-18 19:33:41');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id`, `nombre`) VALUES
(3, 'Crypto'),
(4, 'Forensics'),
(6, 'OSINT'),
(5, 'Pwn'),
(2, 'Reversing'),
(1, 'Web');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `retos`
--

CREATE TABLE `retos` (
  `id` int(11) NOT NULL,
  `titulo` varchar(120) NOT NULL,
  `descripcion` text NOT NULL,
  `puntos` int(11) NOT NULL DEFAULT 0,
  `dificultad` enum('Fácil','Media','Difícil') NOT NULL,
  `categoria_id` int(11) NOT NULL,
  `flag_hash` varchar(255) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `retos`
--

INSERT INTO `retos` (`id`, `titulo`, `descripcion`, `puntos`, `dificultad`, `categoria_id`, `flag_hash`, `activo`, `creado_en`) VALUES
(1, 'SQLi Básico', 'Bypass del login usando inyección SQL.', 50, 'Fácil', 1, '9857b2f6c80f759de9c4b0a8562890030cd6e5dd4ea9042c9b27d81ea515d92d', 1, '2025-12-22 13:42:33'),
(2, 'XSS Stored', 'Ejecuta JavaScript persistente en comentarios.', 120, 'Media', 1, '12d02966391b1fa02b19046b5f1e02085b66c0ad892b194d65dd5ec0c2d545af', 1, '2025-12-22 13:42:33');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solves`
--

CREATE TABLE `solves` (
  `usuario_id` int(11) NOT NULL,
  `reto_id` int(11) NOT NULL,
  `resuelto_en` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `solves`
--

INSERT INTO `solves` (`usuario_id`, `reto_id`, `resuelto_en`) VALUES
(2, 1, '2025-12-22 14:05:24'),
(2, 2, '2025-12-22 14:06:57');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `submissions`
--

CREATE TABLE `submissions` (
  `id` bigint(20) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `reto_id` int(11) NOT NULL,
  `flag_enviada` varchar(255) NOT NULL,
  `es_correcta` tinyint(1) NOT NULL DEFAULT 0,
  `enviada_en` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `submissions`
--

INSERT INTO `submissions` (`id`, `usuario_id`, `reto_id`, `flag_enviada`, `es_correcta`, `enviada_en`) VALUES
(1, 2, 1, 'FLAG{SQLI_OK}', 1, '2025-12-22 14:05:24'),
(2, 2, 2, 'FLAG{SQLI_OK}', 0, '2025-12-22 14:05:46'),
(3, 2, 2, 'FLAG{XSS_OK}', 1, '2025-12-22 14:06:57');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `fecha_registro` datetime DEFAULT current_timestamp(),
  `points` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `username`, `email`, `password_hash`, `fecha_registro`, `points`) VALUES
(2, 'admin', 'admin@admin.es', '$2y$10$1G4hfBjO28KunIDcGTt8a.2jKBej12w93bWA23xaYLaKXBUNPOoLa', '2025-12-10 10:02:53', 1670),
(6, 'willy', 'willybilly@gmail.com', '$2y$10$a443TpOKrFjGlDOZYfMLu.u3ANijXiCST.J/3y7Acwu1COy1YiT0u', '2025-12-17 09:41:39', 950),
(7, 'usuario', 'usuario@usuario.es', '$2y$10$XEhvNghCwylx56L/QvFFruMCML37HNUjqUGM5yHMMHceiL1olcWOa', '2025-12-17 10:28:56', 1200);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `academia_posts`
--
ALTER TABLE `academia_posts`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `retos`
--
ALTER TABLE `retos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categoria_id` (`categoria_id`);

--
-- Indices de la tabla `solves`
--
ALTER TABLE `solves`
  ADD PRIMARY KEY (`usuario_id`,`reto_id`),
  ADD KEY `reto_id` (`reto_id`);

--
-- Indices de la tabla `submissions`
--
ALTER TABLE `submissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reto_id` (`reto_id`),
  ADD KEY `idx_user_reto` (`usuario_id`,`reto_id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `academia_posts`
--
ALTER TABLE `academia_posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `retos`
--
ALTER TABLE `retos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `submissions`
--
ALTER TABLE `submissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `retos`
--
ALTER TABLE `retos`
  ADD CONSTRAINT `retos_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `solves`
--
ALTER TABLE `solves`
  ADD CONSTRAINT `solves_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `solves_ibfk_2` FOREIGN KEY (`reto_id`) REFERENCES `retos` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `submissions`
--
ALTER TABLE `submissions`
  ADD CONSTRAINT `submissions_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `submissions_ibfk_2` FOREIGN KEY (`reto_id`) REFERENCES `retos` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
