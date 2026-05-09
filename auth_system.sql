-- phpMyAdmin SQL Dump
-- version 5.1.1deb5ubuntu1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 09-05-2026 a las 00:51:50
-- Versión del servidor: 10.6.22-MariaDB-0ubuntu0.22.04.1
-- Versión de PHP: 8.1.2-1ubuntu2.23

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
-- Estructura de tabla para la tabla `academia_email_logs`
--

CREATE TABLE `academia_email_logs` (
  `id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `enviado_en` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
-- Estructura de tabla para la tabla `cooldown_conexiones`
--

CREATE TABLE `cooldown_conexiones` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `ultima_apertura` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cooldown_conexiones`
--

INSERT INTO `cooldown_conexiones` (`id`, `id_usuario`, `ultima_apertura`) VALUES
(1, 21, '2026-04-20 19:09:20'),
(2, 22, '2026-04-20 19:09:55'),
(3, 20, '2026-05-06 23:45:03'),
(4, 19, '2026-05-06 22:51:11'),
(5, 14, '2026-04-22 09:21:03'),
(6, 25, '2026-04-22 10:59:06'),
(7, 26, '2026-04-22 23:28:51'),
(8, 27, '2026-04-29 10:54:49'),
(9, 28, '2026-04-22 10:53:25'),
(10, 30, '2026-05-07 21:04:21'),
(11, 29, '2026-05-08 13:22:58'),
(12, 15, '2026-05-08 22:14:29');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `foro_retos`
--

CREATE TABLE `foro_retos` (
  `id` int(11) NOT NULL,
  `reto_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `comentario` text NOT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `foro_retos`
--

INSERT INTO `foro_retos` (`id`, `reto_id`, `usuario_id`, `username`, `comentario`, `creado_en`) VALUES
(1, 1, 30, 'tiago.adm', 'test', '2026-05-06 07:36:24'),
(2, 1, 30, 'tiago.adm', 'asas', '2026-05-06 08:00:59'),
(3, 1, 20, 'carmen', 'Maquina muy amena para el usuario', '2026-05-06 08:01:07'),
(5, 10, 30, 'tiago.adm', 'Este foro es un foro', '2026-05-06 08:15:49'),
(6, 10, 29, 'tiago', 'Ya ves', '2026-05-06 08:16:03'),
(7, 16, 15, 'sergio', 'Me encanto esta maquina, gracias por subir contenido a esta maravillosa web.', '2026-05-08 20:14:08');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `login_activity`
--

CREATE TABLE `login_activity` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `login_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `login_activity`
--

INSERT INTO `login_activity` (`id`, `usuario_id`, `username`, `ip_address`, `user_agent`, `login_at`) VALUES
(8, 15, 'sergio', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-15 08:41:25'),
(11, 16, 'willy', '172.20.10.8', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-04-15 08:53:27'),
(13, 16, 'willy', '172.20.10.8', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-04-15 08:54:32'),
(14, 16, 'willy', '172.20.10.8', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-04-15 08:55:09'),
(16, 15, 'sergio', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-15 14:43:47'),
(17, 16, 'willy', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-15 15:19:41'),
(18, 15, 'sergio', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-15 16:09:44'),
(19, 16, 'willy', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-15 18:10:47'),
(20, 15, 'sergio', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-15 19:05:20'),
(21, 15, 'sergio', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-15 19:07:16'),
(22, 16, 'willy', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-15 19:24:22'),
(23, 15, 'sergio', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-15 19:33:40'),
(25, 15, 'sergio', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-15 21:06:38'),
(26, 15, 'sergio', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-20 14:17:04'),
(27, 18, 'loli', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-20 15:39:57'),
(28, 19, 'luis', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-20 16:09:01'),
(29, 20, 'carmen', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-20 16:18:38'),
(30, 21, 'adolfo', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-20 16:55:09'),
(31, 22, 'jesus', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-20 17:09:51'),
(32, 15, 'sergio', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-20 17:47:02'),
(33, 20, 'carmen', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-20 17:50:23'),
(34, 19, 'luis', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-20 17:56:05'),
(37, 15, 'sergio', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-22 07:21:29'),
(39, 26, 'bale', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-22 07:23:07'),
(40, 26, 'bale', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-22 07:27:41'),
(41, 26, 'bale', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-22 07:45:03'),
(43, 15, 'sergio', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-22 08:09:24'),
(44, 20, 'carmen', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-22 08:09:32'),
(45, 26, 'bale', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-22 08:11:55'),
(46, 27, 'julia', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-22 08:12:50'),
(47, 27, 'julia', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-22 08:19:55'),
(48, 26, 'bale', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-22 08:44:29'),
(49, 26, 'bale', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-22 08:46:24'),
(50, 27, 'julia', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-22 08:46:56'),
(51, 28, 'pablo', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-22 08:50:49'),
(52, 28, 'pablo', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-22 08:53:23'),
(53, 27, 'julia', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-22 08:54:03'),
(55, 20, 'carmen', '100.127.7.116', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-22 08:59:37'),
(56, 29, 'tiago', '100.127.7.116', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-22 09:03:38'),
(57, 15, 'sergio', '100.127.7.116', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-22 09:04:04'),
(58, 29, 'tiago', '100.127.7.116', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-22 09:04:19'),
(59, 30, 'tiago.adm', '100.127.7.116', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-22 09:04:26'),
(60, 26, 'bale', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-22 09:05:21'),
(61, 29, 'tiago', '100.127.7.116', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-22 09:05:26'),
(62, 26, 'bale', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-22 21:28:39'),
(63, 27, 'julia', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-22 21:31:46'),
(64, 29, 'tiago', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-29 08:44:25'),
(65, 27, 'julia', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-29 08:47:20'),
(66, 29, 'tiago', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-29 08:52:23'),
(67, 27, 'julia', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-29 08:53:31'),
(68, 30, 'tiago.adm', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-29 08:59:22'),
(69, 27, 'julia', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-04-29 15:26:18'),
(70, 30, 'tiago.adm', '100.127.7.116', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-05-06 07:29:03'),
(71, 20, 'carmen', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-05-06 08:00:27'),
(72, 30, 'tiago.adm', '100.114.123.21', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-05-06 08:00:53'),
(73, 29, 'tiago', '100.114.123.21', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-05-06 08:15:53'),
(74, 30, 'tiago.adm', '100.114.123.21', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-05-06 08:16:08'),
(75, 29, 'tiago', '100.114.123.21', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-05-06 08:16:24'),
(76, 30, 'tiago.adm', '100.114.123.21', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-05-06 08:39:45'),
(77, 20, 'carmen', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-05-06 08:57:31'),
(78, 29, 'tiago', '100.114.123.21', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-05-06 09:02:20'),
(79, 30, 'tiago.adm', '100.114.123.21', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-05-06 09:02:27'),
(80, 30, 'tiago.adm', '100.114.123.21', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-05-06 11:55:06'),
(81, 29, 'tiago', '100.114.123.21', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-05-06 12:23:34'),
(82, 20, 'carmen', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-05-06 16:47:27'),
(83, 15, 'sergio', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-05-06 16:48:16'),
(84, 20, 'carmen', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-05-06 17:46:49'),
(85, 15, 'sergio', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-05-06 18:19:06'),
(86, 29, 'tiago', '100.67.140.106', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-05-06 19:04:24'),
(87, 15, 'sergio', '127.0.0.1', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:147.0) Gecko/20100101 Firefox/147.0', '2026-05-06 20:02:30'),
(88, 30, 'tiago.adm', '100.67.140.106', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-05-06 20:14:35'),
(89, 29, 'tiago', '100.67.140.106', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-05-06 20:18:30'),
(90, 30, 'tiago.adm', '100.67.140.106', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-05-06 20:18:39'),
(91, 20, 'carmen', '100.76.130.112', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-06 20:31:38'),
(92, 19, 'luis', '100.76.130.112', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-06 20:33:05'),
(93, 15, 'sergio', '100.76.130.112', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-06 20:34:18'),
(94, 29, 'tiago', '100.67.140.106', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-05-06 20:36:31'),
(95, 20, 'carmen', '100.76.130.112', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-06 20:37:05'),
(96, 30, 'tiago.adm', '100.67.140.106', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-05-06 20:45:36'),
(97, 15, 'sergio', '100.67.140.106', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-05-06 20:48:52'),
(98, 20, 'carmen', '100.67.140.106', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-05-06 20:50:31'),
(99, 19, 'luis', '100.67.140.106', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-05-06 20:51:08'),
(100, 20, 'carmen', '100.76.130.112', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-06 21:44:58'),
(101, 15, 'sergio', '100.76.130.112', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-07 17:50:47'),
(102, 20, 'carmen', '100.76.130.112', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-07 17:51:18'),
(103, 30, 'tiago.adm', '100.67.140.106', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-05-07 19:04:18'),
(104, 15, 'sergio', '100.76.130.112', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-07 19:32:04'),
(105, 30, 'tiago.adm', '100.67.140.106', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-05-07 19:49:42'),
(106, 29, 'tiago', '100.98.238.69', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/147.0.7727.99 Mobile/15E148 Safari/604.1', '2026-05-08 10:04:21'),
(107, 29, 'tiago', '100.98.238.69', 'Mozilla/5.0 (iPhone; CPU iPhone OS 26_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/147.0.7727.99 Mobile/15E148 Safari/604.1', '2026-05-08 11:21:35'),
(108, 30, 'tiago.adm', '100.98.238.69', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/147 Version/11.1.1 Safari/605.1.15', '2026-05-08 11:25:30'),
(109, 15, 'sergio', '100.76.130.112', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-08 16:24:36'),
(110, 20, 'carmen', '100.76.130.112', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-08 17:20:04'),
(111, 15, 'sergio', '100.76.130.112', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-08 19:30:04'),
(112, 15, 'sergio', '100.76.130.112', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-08 20:04:35'),
(113, 30, 'tiago.adm', '100.67.140.106', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-05-08 21:59:35'),
(114, 20, 'carmen', '100.76.130.112', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-08 22:02:32'),
(115, 29, 'tiago', '100.67.140.106', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-05-08 22:03:12'),
(116, 15, 'sergio', '100.76.130.112', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-08 22:05:34'),
(117, 31, 'asd', '100.67.140.106', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-05-08 22:07:48'),
(118, 30, 'tiago.adm', '100.67.140.106', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0', '2026-05-08 22:22:59'),
(119, 15, 'sergio', '100.76.130.112', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-08 22:31:20');

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
  `flag` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `tipo_entorno` enum('guacamole','descargable') NOT NULL DEFAULT 'guacamole',
  `maquina_url` varchar(255) DEFAULT NULL,
  `archivo_descarga` varchar(255) DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `retos`
--

INSERT INTO `retos` (`id`, `titulo`, `descripcion`, `puntos`, `dificultad`, `categoria_id`, `flag`, `activo`, `tipo_entorno`, `maquina_url`, `archivo_descarga`, `creado_en`) VALUES
(1, 'Broken SSH', 'Serás capaz de vulnerar un SSH y conseguir las credenciales del administrador.', 50000, 'Fácil', 1, 'estrella', 1, 'guacamole', 'http://100.74.192.110:8080/guacamole/#/client/MQBnAG15c3Fs', NULL, '2025-12-22 13:42:33'),
(10, 'Shadow Login', 'Máquina retirada enfocada en enumeración web, revisión de paneles ocultos y análisis básico de credenciales expuestas.', 40, 'Fácil', 1, NULL, 0, 'descargable', NULL, 'descargas/shadow_login.zip', '2026-05-06 08:14:26'),
(11, 'Broken Gallery', 'Reto retirado basado en una galería vulnerable donde se practican subidas de archivos, validaciones débiles y bypass de extensiones.', 70, 'Media', 1, NULL, 0, 'descargable', NULL, 'descargas/broken_gallery.zip', '2026-05-06 08:14:26'),
(12, 'Old Backup', 'Máquina retirada centrada en búsqueda de backups expuestos, análisis de ficheros sensibles y extracción de información de configuración.', 55, 'Fácil', 1, NULL, 0, 'descargable', NULL, 'descargas/old_backup.zip', '2026-05-06 08:14:26'),
(13, 'Internal Notes', 'Reto retirado donde se trabaja la enumeración de servicios internos, lectura de notas filtradas y escalada lógica de privilegios.', 90, 'Media', 1, NULL, 0, 'descargable', NULL, 'descargas/internal_notes.zip', '2026-05-06 08:14:26'),
(14, 'Root Factory', 'Máquina retirada de dificultad alta orientada a explotación web inicial, análisis de permisos incorrectos y obtención de acceso privilegiado.', 130, 'Difícil', 1, NULL, 0, 'descargable', NULL, 'descargas/root_factory.zip', '2026-05-06 08:14:26'),
(16, 'WhereIsMyShell', 'Reto activo orientado a enumeración web básica y búsqueda de una shell.', 50, 'Fácil', 1, 'contraseñaderoot123', 1, 'guacamole', '/guacamole/#/client/MgBnAG15c3Fs', NULL, '2026-05-06 12:26:58'),
(17, 'Panel Ghost', 'Máquina activa centrada en búsqueda de paneles ocultos, fuerza bruta controlada y análisis de credenciales filtradas.', 60, 'Fácil', 1, 'asd', 1, 'guacamole', '/guacamole/#/client/MQBjAG15c3Fs', NULL, '2026-05-06 12:26:58'),
(19, 'Cookie Monster', 'Máquina enfocada en manipulación de cookies, sesiones inseguras y escalada lógica dentro de una aplicación web vulnerable.', 75, 'Media', 1, 'asd', 1, 'guacamole', '/guacamole/#/client/MQBjAG15c3Fs', NULL, '2026-05-06 12:26:58'),
(20, 'XSS Mirror', 'Reto activo para practicar Cross-Site Scripting reflejado, robo simulado de sesión y análisis de entradas no saneadas.', 65, 'Fácil', 1, 'asd', 1, 'guacamole', '/guacamole/#/client/MQBjAG15c3Fs', NULL, '2026-05-06 12:26:58'),
(22, 'Backup Hunter', 'Reto basado en búsqueda de copias de seguridad olvidadas, análisis de configuración y extracción de credenciales.', 70, 'Fácil', 1, 'asd', 1, 'guacamole', '/guacamole/#/client/MQBjAG15c3Fs', NULL, '2026-05-06 12:26:58'),
(23, 'Pivot Lab', 'Máquina activa orientada a reconocimiento de red interna, descubrimiento de servicios y pivoting básico entre máquinas.', 120, 'Difícil', 1, 'asd', 1, 'guacamole', '/guacamole/#/client/MQBjAG15c3Fs', NULL, '2026-05-06 12:26:58'),
(24, 'Token Breaker', 'Reto centrado en análisis de tokens débiles, manipulación de JWT y acceso a funcionalidades administrativas.', 110, 'Difícil', 1, 'asd', 1, 'guacamole', '/guacamole/#/client/MQBjAG15c3Fs', NULL, '2026-05-06 12:26:58');

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
(15, 16, '2026-05-08 20:13:32'),
(20, 1, '2026-05-06 08:03:23'),
(30, 1, '2026-05-06 08:03:12');

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
(4, 20, 1, 'tusmuertos', 0, '2026-05-06 08:02:51'),
(5, 30, 1, 'tusmuerto', 1, '2026-05-06 08:03:12'),
(6, 20, 1, 'tusmuerto', 1, '2026-05-06 08:03:23'),
(11, 30, 1, 'prueba', 1, '2026-05-06 08:09:17'),
(12, 30, 1, 'prueba', 1, '2026-05-06 08:10:33'),
(15, 30, 1, 'prueba', 1, '2026-05-06 08:11:02'),
(16, 30, 1, 'prueba', 1, '2026-05-06 08:11:16'),
(19, 15, 16, 'contraseñaderoot123', 1, '2026-05-08 20:13:32');

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
  `points` int(11) DEFAULT 0,
  `rol` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `username`, `email`, `password_hash`, `fecha_registro`, `points`, `rol`) VALUES
(15, 'sergio', 'sergiocastillaroncel@gmail.com', '$2y$10$5TerYWAMshFafnvDyO8RlelPL5ci02VMVucol01eoVfor7H.ADpHm', '2026-04-15 10:39:14', 3050, 1),
(16, 'willy', 'willy@willy.es', '$2y$10$9NGKXMiyLJbowh5.LsYqe..PVzAWavgp6Qhj0QWZAFXDsXUVsQl5y', '2026-04-15 10:48:47', 0, 0),
(18, 'loli', 'loli@gmail.com', '$2y$10$RLi4QGKpkeWB.nYSYw7miesmaZychkwmveTUvlNcpDYAAsiVwkrnG', '2026-04-20 17:39:10', 0, 0),
(19, 'luis', 'luis@gmail.com', '$2y$10$MVu8Ds7xs.n/yGAxkhz4TOPBSqaEGLThzDil27y250wdrMpaZdwpK', '2026-04-20 18:08:54', 0, 0),
(20, 'carmen', 'carmen@gmail.com', '$2y$10$qMLowr8k3WECeex7CjF/keD7UhXxRISOKndvOlaRxWhwzuhchtX5O', '2026-04-20 18:18:29', 260, 0),
(21, 'adolfo', 'adolfo@gmail.com', '$2y$10$/xmwW3y1Kf4odFvrTKLb/eS10AMEJ2afDG4i6IKteGA4PmYQIaObe', '2026-04-20 18:55:03', 0, 0),
(22, 'jesus', 'jesus@gmail.com', '$2y$10$v9JYaFkViKgyMgeUXTzjdO3dV3b0bEZhelnENLQK6uWzcHdNEXgEi', '2026-04-20 19:09:46', 0, 0),
(23, 'nico', 'nico@gmail.com', '$2y$10$N87J7z7d0Qm77bDFFwJtDezUOtJE.je/UMDti.kFJe.B8mtiQhF9q', '2026-04-20 20:53:00', 0, 0),
(24, 'kiko', 'kiko@gmail.com', '$2y$10$7SUrcQJ3Nndk0L349eyuQ.Q5emLX/c9Au0qaZnTcZDiDn0SSqDqu2', '2026-04-20 20:56:11', 0, 0),
(26, 'bale', 'bale@gmail.com', '$2y$10$7ya2fgqttuthmfHM3CSuwOUWZvNHlODleafk0spABHUZaISyhoVo2', '2026-04-22 09:23:00', 0, 0),
(27, 'julia', 'julia@gmail.com', '$2y$10$xCPIcCOb5xMarSgJsc/n1.fiG757jO6sZ1nt4LvV87NnBAsrzq9PK', '2026-04-22 10:12:45', 0, 0),
(28, 'pablo', 'pablo@gmail.com', '$2y$10$9h7lyREtkY5ycus9X8zEw.3MUv7tQ8YK3ojKGWtM1XBykK3EnshUu', '2026-04-22 10:50:43', 0, 0),
(29, 'tiago', 'tiagofernandezdelahera@gmail.com', '$2y$10$.6ZLrPqa5a.EWcyfjq84q.MC9i7WLbRUYGJwshfKPj6WxiSUm8vR.', '2026-04-22 11:03:36', 200, 0),
(30, 'tiago.adm', 'tiago.adm@tiago.adm.es', '$2y$10$DhSvmNvGEOIO5Gx9N5scxuzboc8kM2JJOHYngMKQWjCnzhVH.BRE.', '2026-04-22 11:03:59', 750, 1),
(31, 'asd', 'asd@asd.es', '$2y$10$/gDSsgXI0MLtGi.RtuqFEefhIni1o1dw0LIt3IgjQp.ibQvsrWjPW', '2026-05-09 00:07:46', 0, 0);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `academia_email_logs`
--
ALTER TABLE `academia_email_logs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_post_usuario` (`post_id`,`usuario_id`),
  ADD KEY `usuario_id` (`usuario_id`);

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
-- Indices de la tabla `cooldown_conexiones`
--
ALTER TABLE `cooldown_conexiones`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `foro_retos`
--
ALTER TABLE `foro_retos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_reto_id` (`reto_id`);

--
-- Indices de la tabla `login_activity`
--
ALTER TABLE `login_activity`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_login_usuario` (`usuario_id`),
  ADD KEY `idx_login_fecha` (`login_at`);

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
  ADD UNIQUE KEY `unique_solve_usuario_reto` (`usuario_id`,`reto_id`),
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
-- AUTO_INCREMENT de la tabla `academia_email_logs`
--
ALTER TABLE `academia_email_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=127;

--
-- AUTO_INCREMENT de la tabla `academia_posts`
--
ALTER TABLE `academia_posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `cooldown_conexiones`
--
ALTER TABLE `cooldown_conexiones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `foro_retos`
--
ALTER TABLE `foro_retos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `login_activity`
--
ALTER TABLE `login_activity`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=120;

--
-- AUTO_INCREMENT de la tabla `retos`
--
ALTER TABLE `retos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `submissions`
--
ALTER TABLE `submissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `academia_email_logs`
--
ALTER TABLE `academia_email_logs`
  ADD CONSTRAINT `academia_email_logs_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `academia_posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `academia_email_logs_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `foro_retos`
--
ALTER TABLE `foro_retos`
  ADD CONSTRAINT `fk_foro_reto` FOREIGN KEY (`reto_id`) REFERENCES `retos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `login_activity`
--
ALTER TABLE `login_activity`
  ADD CONSTRAINT `fk_login_activity_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

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
