-- phpMyAdmin SQL Dump
-- version 5.1.1deb5ubuntu1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 09-05-2026 a las 00:52:12
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
-- Base de datos: `guacamole_db`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guacamole_connection`
--

CREATE TABLE `guacamole_connection` (
  `connection_id` int(11) NOT NULL,
  `connection_name` varchar(128) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `protocol` varchar(32) NOT NULL,
  `proxy_port` int(11) DEFAULT NULL,
  `proxy_hostname` varchar(512) DEFAULT NULL,
  `proxy_encryption_method` enum('NONE','SSL') DEFAULT NULL,
  `max_connections` int(11) DEFAULT NULL,
  `max_connections_per_user` int(11) DEFAULT NULL,
  `connection_weight` int(11) DEFAULT NULL,
  `failover_only` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Volcado de datos para la tabla `guacamole_connection`
--

INSERT INTO `guacamole_connection` (`connection_id`, `connection_name`, `parent_id`, `protocol`, `proxy_port`, `proxy_hostname`, `proxy_encryption_method`, `max_connections`, `max_connections_per_user`, `connection_weight`, `failover_only`) VALUES
(4, 'MV1-RETO1', 1, 'vnc', 4822, 'localhost', NULL, 20, 20, NULL, 0),
(5, 'MV2-RETO1', 1, 'vnc', 4822, 'localhost', NULL, 20, 20, NULL, 0),
(6, 'MV3-RETO1', 1, 'vnc', 4822, 'localhost', NULL, 20, 20, NULL, 0),
(7, 'MV1-RETO2', 2, 'vnc', 4822, 'localhost', NULL, 20, 20, NULL, 0),
(8, 'MV2-RETO2', 2, 'vnc', 4822, 'localhost', NULL, 20, 20, NULL, 0),
(9, 'MV3-RETO2', 2, 'vnc', 4822, 'localhost', NULL, 20, 20, NULL, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guacamole_connection_attribute`
--

CREATE TABLE `guacamole_connection_attribute` (
  `connection_id` int(11) NOT NULL,
  `attribute_name` varchar(128) NOT NULL,
  `attribute_value` varchar(4096) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guacamole_connection_group`
--

CREATE TABLE `guacamole_connection_group` (
  `connection_group_id` int(11) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `connection_group_name` varchar(128) NOT NULL,
  `type` enum('ORGANIZATIONAL','BALANCING') NOT NULL DEFAULT 'ORGANIZATIONAL',
  `max_connections` int(11) DEFAULT NULL,
  `max_connections_per_user` int(11) DEFAULT NULL,
  `enable_session_affinity` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Volcado de datos para la tabla `guacamole_connection_group`
--

INSERT INTO `guacamole_connection_group` (`connection_group_id`, `parent_id`, `connection_group_name`, `type`, `max_connections`, `max_connections_per_user`, `enable_session_affinity`) VALUES
(1, NULL, 'RETO1-BALANCE', 'BALANCING', 3, 1, 1),
(2, NULL, 'RETO2-BALANCE', 'BALANCING', 3, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guacamole_connection_group_attribute`
--

CREATE TABLE `guacamole_connection_group_attribute` (
  `connection_group_id` int(11) NOT NULL,
  `attribute_name` varchar(128) NOT NULL,
  `attribute_value` varchar(4096) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guacamole_connection_group_permission`
--

CREATE TABLE `guacamole_connection_group_permission` (
  `entity_id` int(11) NOT NULL,
  `connection_group_id` int(11) NOT NULL,
  `permission` enum('READ','UPDATE','DELETE','ADMINISTER') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Volcado de datos para la tabla `guacamole_connection_group_permission`
--

INSERT INTO `guacamole_connection_group_permission` (`entity_id`, `connection_group_id`, `permission`) VALUES
(1, 1, 'READ'),
(1, 1, 'UPDATE'),
(1, 1, 'DELETE'),
(1, 1, 'ADMINISTER'),
(1, 2, 'READ'),
(1, 2, 'UPDATE'),
(1, 2, 'DELETE'),
(1, 2, 'ADMINISTER'),
(7, 1, 'READ'),
(7, 2, 'READ'),
(14, 1, 'READ'),
(14, 2, 'READ');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guacamole_connection_history`
--

CREATE TABLE `guacamole_connection_history` (
  `history_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `username` varchar(128) NOT NULL,
  `remote_host` varchar(256) DEFAULT NULL,
  `connection_id` int(11) DEFAULT NULL,
  `connection_name` varchar(128) NOT NULL,
  `sharing_profile_id` int(11) DEFAULT NULL,
  `sharing_profile_name` varchar(128) DEFAULT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Volcado de datos para la tabla `guacamole_connection_history`
--

INSERT INTO `guacamole_connection_history` (`history_id`, `user_id`, `username`, `remote_host`, `connection_id`, `connection_name`, `sharing_profile_id`, `sharing_profile_name`, `start_date`, `end_date`) VALUES
(68, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:00:51', '2025-11-19 11:00:51'),
(69, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:01:38', '2025-11-19 11:01:39'),
(70, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:01:54', '2025-11-19 11:01:54'),
(71, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:02:09', '2025-11-19 11:02:10'),
(72, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:02:25', '2025-11-19 11:02:26'),
(73, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:02:41', '2025-11-19 11:02:42'),
(74, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:03:39', '2025-11-19 11:03:40'),
(75, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:03:48', '2025-11-19 11:03:48'),
(76, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:04:04', '2025-11-19 11:04:04'),
(77, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:04:19', '2025-11-19 11:04:20'),
(78, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:04:35', '2025-11-19 11:04:35'),
(79, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:05:38', '2025-11-19 11:05:38'),
(80, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:06:20', '2025-11-19 11:06:20'),
(81, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:06:35', '2025-11-19 11:06:36'),
(82, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:07:24', '2025-11-19 11:07:24'),
(83, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:07:39', '2025-11-19 11:07:40'),
(84, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:07:55', '2025-11-19 11:07:56'),
(85, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:08:11', '2025-11-19 11:08:11'),
(86, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:08:27', '2025-11-19 11:08:27'),
(87, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:09:23', '2025-11-19 11:09:23'),
(88, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:09:40', '2025-11-19 11:09:41'),
(89, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:09:56', '2025-11-19 11:09:57'),
(90, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:10:12', '2025-11-19 11:10:12'),
(91, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:10:28', '2025-11-19 11:10:29'),
(92, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:10:44', '2025-11-19 11:10:44'),
(93, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:10:59', '2025-11-19 11:11:00'),
(94, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:11:15', '2025-11-19 11:11:15'),
(95, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:11:31', '2025-11-19 11:11:31'),
(96, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:11:46', '2025-11-19 11:11:47'),
(97, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:12:02', '2025-11-19 11:12:02'),
(98, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:12:18', '2025-11-19 11:12:18'),
(99, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:12:34', '2025-11-19 11:12:34'),
(100, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:12:49', '2025-11-19 11:12:50'),
(101, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:13:05', '2025-11-19 11:13:06'),
(102, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:13:21', '2025-11-19 11:13:21'),
(103, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:13:36', '2025-11-19 11:13:37'),
(104, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:13:52', '2025-11-19 11:13:52'),
(105, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:14:08', '2025-11-19 11:14:08'),
(106, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:14:23', '2025-11-19 11:14:24'),
(107, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:14:39', '2025-11-19 11:14:39'),
(108, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:14:56', '2025-11-19 11:14:57'),
(109, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:15:12', '2025-11-19 11:15:13'),
(110, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:15:28', '2025-11-19 11:15:28'),
(111, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:15:43', '2025-11-19 11:15:44'),
(112, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:16:00', '2025-11-19 11:16:01'),
(113, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:16:17', '2025-11-19 11:16:17'),
(114, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:16:34', '2025-11-19 11:16:34'),
(115, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:16:50', '2025-11-19 11:16:51'),
(116, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:17:08', '2025-11-19 11:17:09'),
(117, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:17:26', '2025-11-19 11:17:26'),
(118, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:17:42', '2025-11-19 11:17:42'),
(119, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:17:58', '2025-11-19 11:17:59'),
(120, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:18:15', '2025-11-19 11:18:15'),
(121, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:18:32', '2025-11-19 11:18:32'),
(122, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:18:48', '2025-11-19 11:18:49'),
(123, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:19:07', '2025-11-19 11:19:08'),
(124, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:19:26', '2025-11-19 11:19:26'),
(125, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:19:44', '2025-11-19 11:19:44'),
(126, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:20:00', '2025-11-19 11:20:01'),
(127, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:20:16', '2025-11-19 11:20:17'),
(128, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:20:33', '2025-11-19 11:20:33'),
(129, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:20:50', '2025-11-19 11:20:51'),
(130, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:21:07', '2025-11-19 11:21:10'),
(131, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:21:27', '2025-11-19 11:21:27'),
(132, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:21:44', '2025-11-19 11:21:45'),
(133, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:22:02', '2025-11-19 11:22:02'),
(134, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:22:19', '2025-11-19 11:22:19'),
(135, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:22:36', '2025-11-19 11:22:36'),
(136, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:22:52', '2025-11-19 11:22:52'),
(137, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:23:09', '2025-11-19 11:23:09'),
(138, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:23:27', '2025-11-19 11:23:28'),
(139, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:23:45', '2025-11-19 11:23:45'),
(140, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:24:01', '2025-11-19 11:24:02'),
(141, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:24:17', '2025-11-19 11:24:18'),
(142, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:24:34', '2025-11-19 11:24:34'),
(143, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:24:51', '2025-11-19 11:24:51'),
(144, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:25:08', '2025-11-19 11:25:08'),
(145, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:25:26', '2025-11-19 11:25:26'),
(146, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:25:42', '2025-11-19 11:25:43'),
(147, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:25:59', '2025-11-19 11:25:59'),
(148, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:26:16', '2025-11-19 11:26:16'),
(149, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:26:33', '2025-11-19 11:26:33'),
(150, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:26:50', '2025-11-19 11:26:51'),
(151, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:27:07', '2025-11-19 11:27:08'),
(152, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:27:23', '2025-11-19 11:27:24'),
(153, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:27:41', '2025-11-19 11:27:42'),
(154, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:27:57', '2025-11-19 11:27:58'),
(155, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:28:14', '2025-11-19 11:28:14'),
(156, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:28:30', '2025-11-19 11:28:31'),
(157, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:28:48', '2025-11-19 11:28:48'),
(158, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:29:04', '2025-11-19 11:29:05'),
(159, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:29:20', '2025-11-19 11:29:21'),
(160, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:29:38', '2025-11-19 11:29:38'),
(161, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:29:55', '2025-11-19 11:29:55'),
(162, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:30:12', '2025-11-19 11:30:12'),
(163, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:30:29', '2025-11-19 11:30:29'),
(164, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:30:45', '2025-11-19 11:30:46'),
(165, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:31:04', '2025-11-19 11:31:05'),
(166, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:31:22', '2025-11-19 11:31:23'),
(167, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:31:39', '2025-11-19 11:31:40'),
(168, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:31:56', '2025-11-19 11:31:56'),
(169, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:32:12', '2025-11-19 11:32:13'),
(170, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:32:29', '2025-11-19 11:32:29'),
(171, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:32:45', '2025-11-19 11:32:45'),
(172, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:33:03', '2025-11-19 11:33:03'),
(173, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:33:19', '2025-11-19 11:33:19'),
(174, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:33:36', '2025-11-19 11:33:37'),
(175, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:33:55', '2025-11-19 11:33:55'),
(176, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:34:13', '2025-11-19 11:34:14'),
(177, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:34:31', '2025-11-19 11:34:31'),
(178, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:34:47', '2025-11-19 11:34:48'),
(179, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:35:06', '2025-11-19 11:35:07'),
(180, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:35:23', '2025-11-19 11:35:24'),
(181, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:35:41', '2025-11-19 11:35:41'),
(182, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:35:57', '2025-11-19 11:35:58'),
(183, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:36:14', '2025-11-19 11:36:14'),
(184, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:36:31', '2025-11-19 11:36:31'),
(185, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:36:48', '2025-11-19 11:36:48'),
(186, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:37:06', '2025-11-19 11:37:07'),
(187, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:37:24', '2025-11-19 11:37:24'),
(188, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:37:40', '2025-11-19 11:37:41'),
(189, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:37:57', '2025-11-19 11:37:58'),
(190, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:38:14', '2025-11-19 11:38:15'),
(191, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:38:31', '2025-11-19 11:38:32'),
(192, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:38:49', '2025-11-19 11:38:49'),
(193, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:39:05', '2025-11-19 11:39:06'),
(194, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:39:23', '2025-11-19 11:39:23'),
(195, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:39:40', '2025-11-19 11:39:40'),
(196, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:39:56', '2025-11-19 11:39:56'),
(197, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:40:15', '2025-11-19 11:40:15'),
(198, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:40:32', '2025-11-19 11:40:32'),
(199, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-19 11:40:49', '2025-11-19 11:40:50'),
(200, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:20:52', '2025-11-26 09:20:52'),
(201, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:21:08', '2025-11-26 09:21:08'),
(202, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:21:23', '2025-11-26 09:21:24'),
(203, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:21:40', '2025-11-26 09:21:41'),
(204, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:21:59', '2025-11-26 09:22:00'),
(205, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:22:17', '2025-11-26 09:22:18'),
(206, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:22:37', '2025-11-26 09:22:38'),
(207, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:22:55', '2025-11-26 09:22:56'),
(208, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:23:02', '2025-11-26 09:23:02'),
(209, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:23:04', '2025-11-26 09:23:05'),
(210, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:23:07', '2025-11-26 09:23:08'),
(211, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:23:08', '2025-11-26 09:23:09'),
(212, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:23:20', '2025-11-26 09:23:20'),
(213, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:23:29', '2025-11-26 09:23:29'),
(214, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:23:46', '2025-11-26 09:23:47'),
(215, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:24:05', '2025-11-26 09:24:06'),
(216, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:24:25', '2025-11-26 09:24:26'),
(217, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:24:50', '2025-11-26 09:24:50'),
(218, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:25:06', '2025-11-26 09:25:06'),
(219, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:26:14', '2025-11-26 09:26:15'),
(220, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:26:30', '2025-11-26 09:26:31'),
(221, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:26:47', '2025-11-26 09:26:47'),
(222, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:27:03', '2025-11-26 09:27:04'),
(223, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:53:31', '2025-11-26 09:57:00'),
(224, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:57:53', '2025-11-26 09:57:54'),
(225, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:58:56', '2025-11-26 09:59:06'),
(226, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 09:59:33', '2025-11-26 09:59:38'),
(227, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 10:00:41', '2025-11-26 10:00:51'),
(376, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 11:05:55', NULL),
(377, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:22:00', '2025-11-26 16:22:00'),
(378, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:22:04', '2025-11-26 16:22:14'),
(379, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:22:18', '2025-11-26 16:22:19'),
(380, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:22:19', '2025-11-26 16:22:29'),
(381, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:22:32', '2025-11-26 16:22:32'),
(382, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:22:33', '2025-11-26 16:22:33'),
(383, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:22:34', '2025-11-26 16:22:44'),
(384, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:23:04', '2025-11-26 16:23:14'),
(385, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:28:46', '2025-11-26 16:28:56'),
(386, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:31:59', '2025-11-26 16:31:59'),
(387, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:32:00', '2025-11-26 16:32:00'),
(388, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:32:01', '2025-11-26 16:32:11'),
(389, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:35:55', '2025-11-26 16:36:05'),
(390, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:36:12', '2025-11-26 16:36:22'),
(391, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:37:38', '2025-11-26 16:37:38'),
(392, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:37:40', '2025-11-26 16:37:40'),
(393, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:37:40', '2025-11-26 16:37:41'),
(394, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:37:41', '2025-11-26 16:37:41'),
(395, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:37:41', '2025-11-26 16:37:52'),
(396, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:44:42', '2025-11-26 16:44:52'),
(397, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:44:54', '2025-11-26 16:45:04'),
(398, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:49:33', '2025-11-26 16:49:43'),
(399, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:50:44', '2025-11-26 16:50:54'),
(400, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 16:51:14', '2025-11-26 17:01:08'),
(401, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 17:01:09', '2025-11-26 17:01:52'),
(402, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 17:01:53', '2025-11-26 17:02:12'),
(403, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 17:03:11', '2025-11-26 17:03:21'),
(404, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 17:06:58', '2025-11-26 17:31:44'),
(405, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 17:31:44', '2025-11-26 17:32:40'),
(406, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 17:32:48', '2025-11-26 17:44:06'),
(407, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 17:44:19', '2025-11-26 17:44:29'),
(408, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 17:45:02', '2025-11-26 17:45:12'),
(409, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 17:45:35', '2025-11-26 17:45:48'),
(410, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-11-26 17:45:57', NULL),
(411, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-01 16:23:48', '2025-12-01 16:25:26'),
(412, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-01 16:25:06', '2025-12-01 16:25:16'),
(413, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-01 16:25:32', '2025-12-01 16:28:10'),
(414, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-01 16:28:25', '2025-12-01 16:28:35'),
(415, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-01 16:32:19', '2025-12-01 16:35:43'),
(416, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-01 16:35:23', '2025-12-01 16:35:23'),
(417, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-01 16:35:24', '2025-12-01 16:35:24'),
(418, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-01 16:35:37', '2025-12-01 16:35:38'),
(419, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-01 16:36:05', '2025-12-01 16:36:11'),
(420, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-01 16:36:16', '2025-12-01 16:36:35'),
(421, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-01 16:37:14', '2025-12-01 16:38:21'),
(422, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-01 16:38:37', '2025-12-01 16:38:43'),
(423, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-01 16:38:45', '2025-12-01 17:07:32'),
(424, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-01 17:24:14', '2025-12-01 17:25:30'),
(425, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-17 09:26:04', '2025-12-17 09:26:56'),
(426, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-17 09:26:57', '2025-12-17 09:27:57'),
(427, 1, 'guacadmin', '10.130.84.186', NULL, 'MV', NULL, NULL, '2025-12-17 09:27:44', NULL),
(428, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-17 09:28:12', NULL),
(429, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 12:06:58', '2025-12-25 12:07:22'),
(430, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 12:07:24', '2025-12-25 12:07:48'),
(431, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 12:08:01', '2025-12-25 12:09:01'),
(432, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 12:11:07', '2025-12-25 12:11:13'),
(433, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 12:11:15', '2025-12-25 12:11:15'),
(434, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 12:11:16', '2025-12-25 12:11:16'),
(435, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 12:11:17', '2025-12-25 12:11:17'),
(436, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 12:11:17', '2025-12-25 12:11:27'),
(437, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 12:12:04', '2025-12-25 12:12:07'),
(438, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 12:12:08', '2025-12-25 12:12:13'),
(439, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 12:12:29', '2025-12-25 13:03:25'),
(440, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 12:13:32', '2025-12-25 12:13:32'),
(441, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 12:13:33', '2025-12-25 12:13:33'),
(442, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 12:13:34', '2025-12-25 12:13:44'),
(443, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 12:14:01', '2025-12-25 12:14:11'),
(444, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 12:14:40', '2025-12-25 12:14:50'),
(445, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 12:14:57', '2025-12-25 12:15:07'),
(446, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:03:29', '2025-12-25 13:03:39'),
(447, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:04:07', '2025-12-25 13:04:18'),
(448, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:08:50', '2025-12-25 13:09:00'),
(449, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:09:19', '2025-12-25 13:09:29'),
(450, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:10:03', '2025-12-25 13:10:13'),
(451, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:10:18', '2025-12-25 13:10:28'),
(452, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:11:11', '2025-12-25 13:11:13'),
(453, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:11:14', '2025-12-25 13:11:16'),
(454, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:11:44', '2025-12-25 13:11:45'),
(455, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:11:46', '2025-12-25 13:11:48'),
(456, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:14:11', '2025-12-25 13:14:21'),
(457, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:14:23', '2025-12-25 13:14:24'),
(458, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:14:25', '2025-12-25 13:14:35'),
(459, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:16:47', '2025-12-25 13:16:53'),
(460, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:16:59', '2025-12-25 13:17:09'),
(461, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:17:36', '2025-12-25 13:17:41'),
(462, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:19:21', '2025-12-25 13:19:26'),
(463, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:19:27', '2025-12-25 13:19:28'),
(464, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:25:19', '2025-12-25 13:25:21'),
(465, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:25:22', '2025-12-25 13:25:23'),
(466, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:25:24', '2025-12-25 13:25:26'),
(467, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:25:27', '2025-12-25 13:25:34'),
(468, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:27:02', '2025-12-25 13:27:04'),
(469, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:27:04', '2025-12-25 13:27:05'),
(470, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:27:06', '2025-12-25 13:27:07'),
(471, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:27:25', '2025-12-25 13:27:26'),
(472, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:27:27', '2025-12-25 13:27:30'),
(473, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:27:31', '2025-12-25 13:27:34'),
(474, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:28:39', '2025-12-25 13:28:49'),
(475, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:28:50', '2025-12-25 13:28:50'),
(476, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:28:52', '2025-12-25 13:29:02'),
(477, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:29:46', '2025-12-25 13:29:47'),
(478, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:29:48', '2025-12-25 13:29:58'),
(479, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:31:59', '2025-12-25 13:32:09'),
(480, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:32:14', '2025-12-25 13:32:25'),
(481, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:35:26', '2025-12-25 13:35:36'),
(482, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:37:16', '2025-12-25 13:37:26'),
(483, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:37:35', '2025-12-25 13:37:40'),
(484, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:37:41', '2025-12-25 13:37:43'),
(485, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:37:48', '2025-12-25 13:37:58'),
(486, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2025-12-25 13:38:49', NULL),
(487, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 09:26:18', '2026-01-21 09:26:19'),
(488, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 09:26:23', '2026-01-21 09:26:33'),
(489, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 09:27:27', '2026-01-21 09:27:37'),
(490, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 09:27:57', '2026-01-21 09:27:58'),
(491, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 09:27:59', '2026-01-21 09:28:09'),
(492, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 09:28:14', '2026-01-21 09:28:24'),
(493, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 09:29:23', '2026-01-21 09:29:34'),
(494, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 09:32:24', '2026-01-21 09:32:29'),
(495, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 09:32:50', '2026-01-21 09:32:56'),
(496, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 09:33:36', '2026-01-21 09:33:36'),
(497, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 09:36:13', '2026-01-21 09:36:23'),
(498, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 09:36:48', '2026-01-21 09:54:09'),
(499, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 09:53:43', '2026-01-21 09:53:44'),
(500, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 09:53:59', '2026-01-21 09:54:09'),
(501, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 09:54:16', '2026-01-21 09:57:04'),
(502, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:01:05', '2026-01-21 10:01:59'),
(503, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:01:59', '2026-01-21 10:02:00'),
(504, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:02:04', '2026-01-21 10:02:04'),
(505, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:02:05', '2026-01-21 10:02:06'),
(506, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:02:13', '2026-01-21 10:02:17'),
(507, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:02:49', '2026-01-21 10:17:58'),
(508, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:23:59', '2026-01-21 10:24:26'),
(509, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:27:42', '2026-01-21 10:28:35'),
(510, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:28:38', '2026-01-21 10:29:17'),
(511, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:28:45', '2026-01-21 10:28:50'),
(512, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:29:33', '2026-01-21 10:29:52'),
(513, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:29:39', '2026-01-21 10:29:42'),
(514, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:29:44', '2026-01-21 10:33:40'),
(515, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:29:51', '2026-01-21 10:29:56'),
(516, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:29:57', '2026-01-21 10:30:12'),
(517, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:33:39', '2026-01-21 10:33:40'),
(518, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:33:43', '2026-01-21 10:34:05'),
(519, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:33:54', '2026-01-21 10:35:01'),
(520, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:34:50', '2026-01-21 10:35:15'),
(521, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:34:52', '2026-01-21 10:35:08'),
(522, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:35:06', '2026-01-21 10:35:20'),
(523, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:35:19', '2026-01-21 10:35:35'),
(524, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:35:23', '2026-01-21 10:35:23'),
(525, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:36:14', '2026-01-21 10:36:39'),
(526, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:36:20', '2026-01-21 10:36:29'),
(527, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:36:28', '2026-01-21 10:36:52'),
(528, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:36:48', '2026-01-21 10:37:09'),
(529, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:37:04', '2026-01-21 10:38:42'),
(530, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:38:41', '2026-01-21 10:38:46'),
(531, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:38:45', '2026-01-21 10:38:50'),
(532, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:38:50', '2026-01-21 10:39:05'),
(533, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:38:53', '2026-01-21 10:38:54'),
(534, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:38:58', '2026-01-21 10:38:58'),
(535, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:39:02', '2026-01-21 10:39:15'),
(536, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:39:14', '2026-01-21 10:39:19'),
(537, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:39:17', '2026-01-21 10:39:21'),
(538, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:39:25', '2026-01-21 10:39:40'),
(539, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:39:39', '2026-01-21 10:39:47'),
(540, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:39:44', '2026-01-21 10:39:59'),
(541, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:39:50', '2026-01-21 10:39:59'),
(542, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:39:52', '2026-01-21 10:39:59'),
(543, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:40:02', '2026-01-21 10:40:28'),
(544, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:40:23', '2026-01-21 10:40:31'),
(545, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:40:29', '2026-01-21 10:40:44'),
(546, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:40:50', '2026-01-21 10:41:05'),
(547, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:41:33', '2026-01-21 10:42:02'),
(548, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:42:33', '2026-01-21 10:42:43'),
(549, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:42:55', '2026-01-21 10:42:59'),
(550, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:42:59', '2026-01-21 10:43:14'),
(551, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:43:02', '2026-01-21 10:43:14'),
(552, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:43:20', '2026-01-21 10:43:29'),
(553, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:43:21', '2026-01-21 10:43:29'),
(554, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:43:31', '2026-01-21 10:43:44'),
(555, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:43:33', '2026-01-21 10:43:37'),
(556, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:44:33', '2026-01-21 10:44:41'),
(557, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:44:41', '2026-01-21 10:44:44'),
(558, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:45:06', '2026-01-21 10:45:14'),
(559, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:50:50', '2026-01-21 10:51:33'),
(560, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:51:15', '2026-01-21 10:51:15'),
(561, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:51:23', '2026-01-21 10:52:21'),
(562, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:52:16', '2026-01-21 10:52:26'),
(563, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 10:52:21', '2026-01-21 10:52:26'),
(564, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 11:00:55', '2026-01-21 11:01:23'),
(565, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 11:01:14', '2026-01-21 11:01:21'),
(566, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 11:02:01', '2026-01-21 11:02:30'),
(567, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 11:02:25', '2026-01-21 11:02:44'),
(568, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 11:02:29', '2026-01-21 11:02:29'),
(569, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 11:06:12', '2026-01-21 11:06:32'),
(570, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 11:06:23', '2026-01-21 11:07:02'),
(571, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 11:06:46', '2026-01-21 11:06:47'),
(572, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 11:06:51', '2026-01-21 11:07:06'),
(573, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 11:06:55', '2026-01-21 11:07:16'),
(574, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-21 11:07:13', '2026-01-21 11:07:16'),
(575, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:18:37', '2026-01-28 10:18:41'),
(576, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:18:55', '2026-01-28 10:19:00'),
(577, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:19:13', '2026-01-28 10:19:18'),
(578, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:20:27', '2026-01-28 10:20:32'),
(579, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:20:30', '2026-01-28 10:20:35'),
(580, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:20:32', '2026-01-28 10:20:47'),
(581, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:20:36', '2026-01-28 10:21:00'),
(582, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:20:36', '2026-01-28 10:20:45'),
(583, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:20:48', '2026-01-28 10:20:49'),
(584, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:20:53', '2026-01-28 10:21:09'),
(585, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:20:54', '2026-01-28 10:21:00'),
(586, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:21:00', '2026-01-28 10:21:01'),
(587, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:21:08', '2026-01-28 10:21:09'),
(588, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:21:09', '2026-01-28 10:21:15'),
(589, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:21:11', '2026-01-28 10:21:15'),
(590, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:21:17', '2026-01-28 10:21:21'),
(591, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:21:29', '2026-01-28 10:21:45'),
(592, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:21:33', '2026-01-28 10:21:45'),
(593, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:21:50', '2026-01-28 10:21:51'),
(594, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:21:57', '2026-01-28 10:22:00'),
(595, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:22:29', '2026-01-28 10:22:30'),
(596, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:22:36', '2026-01-28 10:22:45'),
(597, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:23:13', '2026-01-28 10:23:18'),
(598, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:23:24', '2026-01-28 10:23:30'),
(599, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:23:46', '2026-01-28 10:24:00'),
(600, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:25:41', '2026-01-28 10:26:06'),
(601, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:26:18', '2026-01-28 10:26:19'),
(602, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:26:40', '2026-01-28 10:27:13'),
(603, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:26:54', '2026-01-28 10:27:09'),
(604, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:26:57', '2026-01-28 10:27:13'),
(605, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:27:14', '2026-01-28 10:27:21'),
(606, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-01-28 10:28:00', '2026-01-28 10:28:28'),
(607, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-02-11 10:17:31', '2026-02-11 10:17:52'),
(608, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-02-11 10:17:40', '2026-02-11 10:18:03'),
(609, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-02-11 10:17:49', '2026-02-11 10:18:38'),
(610, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-02-11 10:18:09', '2026-02-11 10:18:38'),
(611, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-02-11 10:18:33', NULL),
(612, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-02-11 10:20:00', '2026-02-11 10:21:05'),
(613, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-02-11 10:21:15', '2026-02-11 10:22:20'),
(614, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-02-11 10:21:49', '2026-02-11 10:22:48'),
(615, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-02-11 10:28:32', '2026-02-11 10:28:55'),
(616, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-02-11 10:28:48', '2026-02-11 10:48:50'),
(617, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-02-11 10:48:47', '2026-02-11 10:49:02'),
(618, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-02-20 20:09:39', NULL),
(619, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-02-25 09:24:28', '2026-02-25 09:24:29'),
(620, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-02-25 09:24:33', '2026-02-25 09:24:34'),
(621, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-02-25 09:24:35', '2026-02-25 09:24:36'),
(622, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-02-25 09:24:37', '2026-02-25 09:24:37'),
(623, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-02-25 09:26:13', '2026-02-25 09:26:13'),
(624, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-02-25 09:30:04', '2026-02-25 09:30:27'),
(625, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-02-25 09:30:22', '2026-02-25 09:30:38'),
(626, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-02-25 09:30:27', '2026-02-25 09:30:43'),
(627, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-03-04 09:39:32', '2026-03-04 09:39:58'),
(628, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-03-04 09:53:46', '2026-03-04 09:55:44'),
(629, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-03-04 09:55:29', '2026-03-04 09:55:50'),
(630, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-03-04 09:55:32', '2026-03-04 09:55:35'),
(631, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-03-04 09:56:13', '2026-03-04 09:56:19'),
(632, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-03-04 09:56:15', '2026-03-04 09:56:30'),
(633, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-03-04 09:56:19', '2026-03-04 09:56:19'),
(634, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-03-04 09:56:26', '2026-03-04 09:56:42'),
(635, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-03-04 09:56:30', '2026-03-04 09:56:35'),
(636, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-03-04 09:56:45', '2026-03-04 09:57:11'),
(637, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-03-04 09:57:14', '2026-03-04 09:58:12'),
(638, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-03-04 09:58:07', '2026-03-04 09:58:23'),
(639, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-03-04 09:58:12', '2026-03-04 09:58:20'),
(640, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-03-04 09:59:22', NULL),
(641, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-03-04 10:00:10', '2026-03-04 10:00:10'),
(642, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-03-04 10:09:36', '2026-03-04 10:09:52'),
(643, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-03-11 09:28:18', '2026-03-11 09:28:59'),
(644, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-03-11 09:28:43', '2026-03-11 09:28:59'),
(645, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-03-11 09:28:46', '2026-03-11 09:28:47'),
(646, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-12 14:32:49', '2026-04-12 14:33:24'),
(647, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-12 14:34:05', '2026-04-12 14:34:22'),
(648, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-12 15:17:37', '2026-04-12 15:18:53'),
(649, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-12 15:18:53', '2026-04-12 15:20:08'),
(650, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-12 15:20:10', '2026-04-12 15:21:25'),
(651, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-12 15:21:27', '2026-04-12 15:22:33'),
(652, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-12 15:22:46', '2026-04-12 15:23:51'),
(653, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-12 15:24:03', '2026-04-12 15:25:18'),
(654, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-12 15:25:19', '2026-04-12 15:26:24'),
(655, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-12 15:26:36', '2026-04-12 15:27:52'),
(656, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-12 15:27:53', '2026-04-12 15:29:09'),
(657, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-12 15:29:09', '2026-04-12 15:30:15'),
(658, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-12 15:30:26', '2026-04-12 15:31:41'),
(659, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-12 15:31:42', '2026-04-12 15:32:47'),
(660, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-12 15:32:57', '2026-04-12 15:34:12'),
(661, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-12 15:34:14', '2026-04-12 15:35:19'),
(662, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-12 15:35:29', '2026-04-12 15:36:45'),
(663, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-12 15:36:47', NULL),
(664, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 11:00:59', '2026-04-15 11:01:19'),
(665, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 11:01:29', '2026-04-15 11:02:19'),
(666, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 11:01:50', '2026-04-15 11:02:49'),
(667, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 11:02:23', '2026-04-15 11:03:26'),
(668, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 11:02:24', '2026-04-15 11:03:29'),
(669, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 11:03:36', '2026-04-15 11:03:55'),
(670, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 11:03:39', NULL),
(671, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 11:09:26', '2026-04-15 11:10:41'),
(672, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 11:10:41', NULL),
(673, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 14:19:45', '2026-04-15 14:19:53'),
(674, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 14:23:16', '2026-04-15 14:23:20'),
(675, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 14:23:18', '2026-04-15 14:23:19'),
(676, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 14:23:25', '2026-04-15 14:23:25'),
(677, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 14:23:31', '2026-04-15 14:23:31'),
(678, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 14:27:49', '2026-04-15 14:27:50'),
(679, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 14:32:33', '2026-04-15 14:32:33'),
(680, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 21:25:42', '2026-04-15 21:26:01'),
(681, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 21:26:01', '2026-04-15 21:26:06'),
(682, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 21:26:19', '2026-04-15 21:26:24'),
(683, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 21:26:31', '2026-04-15 21:26:38'),
(684, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 21:26:35', '2026-04-15 21:26:40'),
(685, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 21:26:41', '2026-04-15 21:26:45'),
(686, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 21:28:11', '2026-04-15 21:28:46'),
(687, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 21:30:53', '2026-04-15 23:05:42'),
(688, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:01:57', '2026-04-15 23:02:01'),
(689, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:05:54', '2026-04-15 23:10:35'),
(690, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:07:50', '2026-04-15 23:07:55'),
(691, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:07:57', '2026-04-15 23:08:01'),
(692, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:08:06', '2026-04-15 23:08:12'),
(693, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:08:11', '2026-04-15 23:08:16'),
(694, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:08:23', '2026-04-15 23:08:30'),
(695, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:08:28', '2026-04-15 23:08:30'),
(696, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:08:57', '2026-04-15 23:09:02'),
(697, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:08:59', '2026-04-15 23:09:05'),
(698, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:09:04', '2026-04-15 23:09:08'),
(699, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:09:07', '2026-04-15 23:09:12'),
(700, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:09:36', '2026-04-15 23:09:41'),
(701, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:10:12', '2026-04-15 23:10:17');
INSERT INTO `guacamole_connection_history` (`history_id`, `user_id`, `username`, `remote_host`, `connection_id`, `connection_name`, `sharing_profile_id`, `sharing_profile_name`, `start_date`, `end_date`) VALUES
(702, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:10:24', '2026-04-15 23:10:48'),
(703, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:10:32', '2026-04-15 23:10:37'),
(704, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:10:38', '2026-04-15 23:10:39'),
(705, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:10:59', '2026-04-15 23:11:05'),
(706, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:11:06', '2026-04-15 23:11:43'),
(707, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:11:30', '2026-04-15 23:11:36'),
(708, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:12:17', '2026-04-15 23:12:28'),
(709, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:13:22', '2026-04-15 23:13:40'),
(710, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:13:27', '2026-04-15 23:13:32'),
(711, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:14:27', '2026-04-15 23:19:18'),
(712, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:14:44', '2026-04-15 23:16:11'),
(713, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:16:27', '2026-04-15 23:16:31'),
(714, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:16:29', '2026-04-15 23:16:35'),
(715, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:16:45', '2026-04-15 23:18:12'),
(716, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:16:47', '2026-04-15 23:16:47'),
(717, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:17:15', '2026-04-15 23:17:21'),
(718, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:17:17', '2026-04-15 23:17:22'),
(719, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:17:53', '2026-04-15 23:17:54'),
(720, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:18:10', '2026-04-15 23:18:10'),
(721, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:19:32', '2026-04-15 23:19:58'),
(722, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:19:58', '2026-04-15 23:19:58'),
(723, 2, 'kiosko', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-15 23:20:11', '2026-04-15 23:20:12'),
(724, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-17 18:29:36', '2026-04-17 18:29:37'),
(725, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 16:17:24', '2026-04-20 16:17:24'),
(726, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 16:17:49', '2026-04-20 17:30:05'),
(727, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 17:30:20', '2026-04-20 17:30:26'),
(728, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 17:41:16', '2026-04-20 17:41:24'),
(729, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 17:41:24', '2026-04-20 17:41:24'),
(730, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 17:41:25', '2026-04-20 17:41:29'),
(731, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 17:41:27', '2026-04-20 17:41:29'),
(732, 1, 'guacadmin', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 17:41:28', '2026-04-20 17:41:28'),
(733, 3, 'luis', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:09:12', '2026-04-20 18:13:05'),
(734, 3, 'luis', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:13:05', '2026-04-20 18:13:07'),
(735, 3, 'luis', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:13:17', '2026-04-20 18:13:18'),
(736, 3, 'luis', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:13:23', '2026-04-20 18:13:33'),
(737, 3, 'luis', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:13:30', '2026-04-20 18:13:35'),
(738, 3, 'luis', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:13:31', '2026-04-20 18:13:32'),
(739, 3, 'luis', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:13:33', '2026-04-20 18:13:37'),
(740, 3, 'luis', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:13:35', '2026-04-20 18:13:37'),
(741, 3, 'luis', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:13:42', '2026-04-20 18:13:43'),
(742, 3, 'luis', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:13:48', '2026-04-20 18:14:24'),
(743, 3, 'luis', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:18:43', '2026-04-20 18:20:33'),
(744, 3, 'luis', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:20:31', '2026-04-20 18:20:34'),
(745, 3, 'luis', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:20:32', '2026-04-20 18:20:34'),
(746, 3, 'luis', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:20:33', '2026-04-20 18:20:34'),
(747, 4, 'carmen', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:20:40', '2026-04-20 18:20:45'),
(748, 4, 'carmen', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:20:44', '2026-04-20 18:20:59'),
(749, 4, 'carmen', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:20:45', '2026-04-20 18:24:51'),
(750, 4, 'carmen', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:24:50', '2026-04-20 18:24:54'),
(751, 4, 'carmen', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:24:51', '2026-04-20 18:24:54'),
(752, 4, 'carmen', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:24:52', '2026-04-20 18:24:54'),
(753, 4, 'carmen', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:24:53', '2026-04-20 18:24:54'),
(754, 4, 'carmen', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:25:06', '2026-04-20 18:25:14'),
(755, 4, 'carmen', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:25:14', '2026-04-20 18:25:14'),
(756, 4, 'carmen', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:25:21', '2026-04-20 18:25:21'),
(757, 4, 'carmen', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:25:26', '2026-04-20 18:25:31'),
(758, 4, 'carmen', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:25:32', '2026-04-20 18:26:35'),
(759, 4, 'carmen', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:27:58', '2026-04-20 18:28:14'),
(760, 4, 'carmen', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:55:13', '2026-04-20 18:55:37'),
(761, 4, 'carmen', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:55:42', '2026-04-20 18:55:45'),
(762, 4, 'carmen', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:55:44', '2026-04-20 18:55:45'),
(763, 5, 'adolfo', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:55:51', '2026-04-20 18:56:16'),
(764, 5, 'adolfo', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 18:56:18', '2026-04-20 18:56:44'),
(765, 5, 'adolfo', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 19:09:20', NULL),
(766, 6, 'jesus', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 19:10:01', '2026-04-20 19:10:05'),
(767, 6, 'jesus', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 19:10:04', '2026-04-20 19:10:07'),
(768, 6, 'jesus', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 19:10:05', '2026-04-20 19:10:05'),
(769, 6, 'jesus', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 19:10:06', '2026-04-20 19:10:07'),
(770, 6, 'jesus', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 19:10:14', '2026-04-20 19:10:19'),
(771, 6, 'jesus', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 19:10:18', '2026-04-20 19:10:23'),
(772, 6, 'jesus', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 19:10:22', '2026-04-20 19:10:24'),
(773, 6, 'jesus', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 19:10:27', '2026-04-20 19:10:42'),
(774, 6, 'jesus', '127.0.0.1', NULL, 'MV', NULL, NULL, '2026-04-20 19:10:34', '2026-04-20 19:10:49'),
(775, 1, 'guacadmin', '127.0.0.1', NULL, 'MV3-RETO1', NULL, NULL, '2026-04-20 19:40:30', '2026-04-20 19:40:30'),
(776, 1, 'guacadmin', '127.0.0.1', NULL, 'MV3-RETO1', NULL, NULL, '2026-04-20 19:40:33', '2026-04-20 19:40:34'),
(777, 1, 'guacadmin', '127.0.0.1', NULL, 'MV3-RETO1', NULL, NULL, '2026-04-20 19:40:34', '2026-04-20 19:40:35'),
(778, 1, 'guacadmin', '127.0.0.1', NULL, 'MV3-RETO1', NULL, NULL, '2026-04-20 19:40:35', '2026-04-20 19:40:36'),
(779, 1, 'guacadmin', '127.0.0.1', NULL, 'MV3-RETO1', NULL, NULL, '2026-04-20 19:40:36', '2026-04-20 19:40:37'),
(780, 1, 'guacadmin', '127.0.0.1', NULL, 'MV3-RETO1', NULL, NULL, '2026-04-20 19:40:38', '2026-04-20 19:40:39'),
(781, 1, 'guacadmin', '127.0.0.1', NULL, 'MV1-RETO1', NULL, NULL, '2026-04-20 19:41:01', '2026-04-20 19:41:02'),
(782, 1, 'guacadmin', '127.0.0.1', NULL, 'MV1-RETO1', NULL, NULL, '2026-04-20 19:41:31', '2026-04-20 19:41:31'),
(783, 1, 'guacadmin', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-20 19:45:02', '2026-04-20 19:45:17'),
(784, 1, 'guacadmin', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-20 19:45:32', '2026-04-20 19:48:05'),
(785, 1, 'guacadmin', '127.0.0.1', NULL, 'MV1-RETO1', NULL, NULL, '2026-04-20 19:47:58', '2026-04-20 19:47:58'),
(786, 1, 'guacadmin', '127.0.0.1', NULL, 'MV1-RETO1', NULL, NULL, '2026-04-20 19:48:19', '2026-04-20 19:48:37'),
(787, 1, 'guacadmin', '127.0.0.1', NULL, 'MV1-RETO1', NULL, NULL, '2026-04-20 19:48:35', '2026-04-20 19:48:35'),
(788, 1, 'guacadmin', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-20 19:49:21', '2026-04-20 19:50:32'),
(789, 1, 'guacadmin', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-20 19:50:51', '2026-04-20 19:55:30'),
(790, 4, 'carmen', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-20 19:53:23', '2026-04-20 19:53:31'),
(791, 4, 'carmen', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-20 19:53:33', '2026-04-20 19:53:43'),
(792, 4, 'carmen', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-20 19:53:45', '2026-04-20 19:53:45'),
(793, 4, 'carmen', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-20 19:54:12', '2026-04-20 19:54:13'),
(794, 4, 'carmen', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-20 19:54:18', '2026-04-20 19:54:18'),
(795, 4, 'carmen', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-20 19:54:19', '2026-04-20 19:54:19'),
(796, 4, 'carmen', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-20 19:55:43', '2026-04-20 19:55:43'),
(797, 4, 'carmen', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-20 19:55:45', NULL),
(798, 3, 'luis', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-20 19:56:15', '2026-04-20 20:45:20'),
(799, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 09:23:16', '2026-04-22 09:23:25'),
(800, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 09:24:23', '2026-04-22 09:25:53'),
(801, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 09:27:18', '2026-04-22 09:27:32'),
(802, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 09:28:29', '2026-04-22 09:28:34'),
(803, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 09:28:41', '2026-04-22 09:32:36'),
(804, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 09:32:52', '2026-04-22 09:33:22'),
(805, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 09:33:37', '2026-04-22 09:33:47'),
(806, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 09:34:11', '2026-04-22 09:34:37'),
(807, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 09:35:32', '2026-04-22 09:35:39'),
(808, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 09:44:29', '2026-04-22 09:44:37'),
(809, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 09:45:32', '2026-04-22 09:45:42'),
(810, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 09:45:52', '2026-04-22 09:46:03'),
(811, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 09:46:10', '2026-04-22 09:46:20'),
(812, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 09:50:49', '2026-04-22 09:50:53'),
(813, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 09:57:40', '2026-04-22 09:57:55'),
(814, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 09:58:57', '2026-04-22 09:59:08'),
(815, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:04:34', '2026-04-22 10:04:44'),
(816, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:06:21', '2026-04-22 10:09:42'),
(817, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:09:58', '2026-04-22 10:10:50'),
(818, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:10:54', '2026-04-22 10:11:04'),
(819, 9, 'bale', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:11:09', '2026-04-22 10:11:13'),
(820, 9, 'bale', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:11:28', '2026-04-22 10:11:30'),
(821, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:11:29', '2026-04-22 10:11:30'),
(822, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:12:12', '2026-04-22 10:39:19'),
(823, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:13:02', '2026-04-22 10:13:05'),
(824, 10, 'julia', '127.0.0.1', 6, 'MV3-RETO1', NULL, NULL, '2026-04-22 10:13:05', '2026-04-22 10:13:08'),
(825, 10, 'julia', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:13:08', '2026-04-22 10:13:09'),
(826, 10, 'julia', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:13:43', '2026-04-22 10:13:50'),
(827, 10, 'julia', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:13:57', '2026-04-22 10:13:58'),
(828, 10, 'julia', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:13:59', '2026-04-22 10:13:59'),
(829, 10, 'julia', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:14:00', '2026-04-22 10:14:00'),
(830, 10, 'julia', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:17:54', '2026-04-22 10:17:54'),
(831, 10, 'julia', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:17:57', '2026-04-22 10:17:57'),
(832, 10, 'julia', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:18:01', '2026-04-22 10:18:11'),
(833, 10, 'julia', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:18:30', '2026-04-22 10:18:31'),
(834, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:20:02', '2026-04-22 10:39:47'),
(835, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:39:35', '2026-04-22 10:40:02'),
(836, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:40:04', '2026-04-22 10:40:29'),
(837, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:40:17', '2026-04-22 10:40:27'),
(838, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:40:30', '2026-04-22 10:40:32'),
(839, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:40:36', '2026-04-22 10:40:38'),
(840, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:40:40', '2026-04-22 10:40:42'),
(841, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:40:58', '2026-04-22 10:40:58'),
(842, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:41:13', '2026-04-22 10:41:15'),
(843, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:41:23', '2026-04-22 10:41:24'),
(844, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:41:25', '2026-04-22 10:41:27'),
(845, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:42:03', '2026-04-22 10:42:05'),
(846, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:42:20', '2026-04-22 10:42:30'),
(847, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:43:39', '2026-04-22 10:43:40'),
(848, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:43:46', '2026-04-22 10:43:54'),
(849, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:44:05', '2026-04-22 10:44:06'),
(850, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:44:10', '2026-04-22 10:44:12'),
(851, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:44:34', '2026-04-22 10:44:44'),
(852, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:44:48', '2026-04-22 10:44:50'),
(853, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:45:05', '2026-04-22 10:45:15'),
(854, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:45:32', '2026-04-22 10:45:32'),
(855, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:45:48', '2026-04-22 10:45:52'),
(856, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:45:52', '2026-04-22 10:45:54'),
(857, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:45:56', '2026-04-22 10:45:57'),
(858, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:46:02', '2026-04-22 10:46:03'),
(859, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:46:07', '2026-04-22 10:46:09'),
(860, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:46:59', '2026-04-22 10:52:57'),
(861, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:47:13', '2026-04-22 10:47:16'),
(862, 11, 'pablo', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:51:01', '2026-04-22 10:51:04'),
(863, 11, 'pablo', '127.0.0.1', 6, 'MV3-RETO1', NULL, NULL, '2026-04-22 10:51:04', '2026-04-22 10:51:07'),
(864, 11, 'pablo', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:51:07', '2026-04-22 10:51:16'),
(865, 11, 'pablo', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:51:16', '2026-04-22 10:51:16'),
(866, 11, 'pablo', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:51:18', '2026-04-22 10:51:28'),
(867, 11, 'pablo', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:52:19', '2026-04-22 10:52:19'),
(868, 11, 'pablo', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:52:21', '2026-04-22 10:52:21'),
(869, 11, 'pablo', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:52:31', '2026-04-22 10:52:48'),
(870, 11, 'pablo', '127.0.0.1', 6, 'MV3-RETO1', NULL, NULL, '2026-04-22 10:52:48', '2026-04-22 10:52:51'),
(871, 11, 'pablo', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:52:51', '2026-04-22 10:53:06'),
(872, 11, 'pablo', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:53:26', '2026-04-22 10:54:09'),
(873, 1, 'guacadmin', '100.127.7.116', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:57:00', '2026-04-22 10:58:57'),
(874, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 10:57:39', '2026-04-22 11:06:11'),
(875, 1, 'guacadmin', '100.127.7.116', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:59:13', '2026-04-22 10:59:22'),
(876, 1, 'guacadmin', '100.127.7.116', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 10:59:47', '2026-04-22 11:03:19'),
(877, 1, 'guacadmin', '100.127.7.116', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 11:03:21', '2026-04-22 11:03:25'),
(878, 1, 'guacadmin', '100.127.7.116', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 11:06:09', '2026-04-22 11:06:10'),
(879, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 11:06:24', '2026-04-22 11:06:28'),
(880, 1, 'guacadmin', '100.127.7.116', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 11:06:42', '2026-04-22 11:08:15'),
(881, 1, 'guacadmin', '100.127.7.116', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 11:06:47', '2026-04-22 11:07:57'),
(882, 1, 'guacadmin', '100.127.7.116', 6, 'MV3-RETO1', NULL, NULL, '2026-04-22 11:06:51', '2026-04-22 11:07:15'),
(883, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 23:28:59', '2026-04-22 23:29:15'),
(884, 9, 'bale', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-22 23:29:28', NULL),
(885, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-22 23:31:58', NULL),
(886, 1, 'guacadmin', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-29 10:44:45', '2026-04-29 10:45:01'),
(887, 1, 'guacadmin', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-29 10:45:15', '2026-04-29 10:45:47'),
(888, 1, 'guacadmin', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-29 10:45:50', '2026-04-29 10:46:44'),
(889, 1, 'guacadmin', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-29 10:46:51', '2026-04-29 10:47:51'),
(890, 10, 'julia', '127.0.0.1', 5, 'MV2-RETO1', NULL, NULL, '2026-04-29 10:47:31', '2026-04-29 10:47:34'),
(891, 10, 'julia', '127.0.0.1', 6, 'MV3-RETO1', NULL, NULL, '2026-04-29 10:47:34', '2026-04-29 10:47:37'),
(892, 10, 'julia', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-29 10:47:37', '2026-04-29 10:48:37'),
(893, 1, 'guacadmin', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-29 10:48:07', '2026-04-29 10:49:07'),
(894, 10, 'julia', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-29 10:48:53', NULL),
(895, 1, 'guacadmin', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-29 10:49:23', NULL),
(896, 12, 'tiago', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-29 10:52:30', '2026-04-29 10:52:45'),
(897, 12, 'tiago', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-29 10:53:34', '2026-04-29 10:54:08'),
(898, 12, 'tiago', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-04-29 10:54:49', '2026-04-29 10:55:08'),
(899, 12, 'tiago', '100.67.140.106', 4, 'MV1-RETO1', NULL, NULL, '2026-05-06 21:04:54', '2026-05-06 21:05:09'),
(900, 12, 'tiago', '100.67.140.106', 4, 'MV1-RETO1', NULL, NULL, '2026-05-06 21:05:24', '2026-05-06 21:05:34'),
(901, 12, 'tiago', '100.67.140.106', 4, 'MV1-RETO1', NULL, NULL, '2026-05-06 21:05:53', '2026-05-06 21:42:42'),
(902, 12, 'tiago', '100.67.140.106', 4, 'MV1-RETO1', NULL, NULL, '2026-05-06 21:42:57', '2026-05-06 21:50:43'),
(903, 12, 'tiago', '100.67.140.106', 5, 'MV2-RETO1', NULL, NULL, '2026-05-06 21:50:49', '2026-05-06 21:50:59'),
(904, 12, 'tiago', '100.67.140.106', 6, 'MV3-RETO1', NULL, NULL, '2026-05-06 21:51:29', '2026-05-06 21:51:37'),
(905, 13, 'tiago.adm', '100.67.140.106', 5, 'MV2-RETO1', NULL, NULL, '2026-05-06 21:51:51', '2026-05-06 21:52:01'),
(906, 13, 'tiago.adm', '100.67.140.106', 5, 'MV2-RETO1', NULL, NULL, '2026-05-06 21:52:47', '2026-05-06 21:52:57'),
(907, 13, 'tiago.adm', '100.67.140.106', 5, 'MV2-RETO1', NULL, NULL, '2026-05-06 21:53:27', '2026-05-06 22:10:33'),
(908, 13, 'tiago.adm', '100.67.140.106', 6, 'MV3-RETO1', NULL, NULL, '2026-05-06 22:04:02', '2026-05-06 22:10:33'),
(909, 1, 'guacadmin', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-05-06 22:04:25', '2026-05-06 22:05:51'),
(910, 1, 'guacadmin', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-05-06 22:06:00', '2026-05-06 22:11:33'),
(911, 13, 'tiago.adm', '100.67.140.106', 4, 'MV1-RETO1', NULL, NULL, '2026-05-06 22:08:12', '2026-05-06 22:08:27'),
(912, 13, 'tiago.adm', '100.67.140.106', 4, 'MV1-RETO1', NULL, NULL, '2026-05-06 22:08:19', '2026-05-06 22:08:20'),
(913, 13, 'tiago.adm', '100.67.140.106', 4, 'MV1-RETO1', NULL, NULL, '2026-05-06 22:08:33', '2026-05-06 22:08:34'),
(914, 1, 'guacadmin', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-05-06 22:11:48', '2026-05-06 22:11:58'),
(915, 1, 'guacadmin', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-05-06 22:13:45', '2026-05-06 22:22:56'),
(916, 13, 'tiago.adm', '100.67.140.106', 4, 'MV1-RETO1', NULL, NULL, '2026-05-06 22:16:57', '2026-05-06 22:16:58'),
(917, 12, 'tiago', '100.67.140.106', 5, 'MV2-RETO1', NULL, NULL, '2026-05-06 22:18:06', '2026-05-06 22:18:22'),
(918, 12, 'tiago', '100.67.140.106', 5, 'MV2-RETO1', NULL, NULL, '2026-05-06 22:37:21', '2026-05-06 22:37:26'),
(919, 4, 'carmen', '100.76.130.112', 4, 'MV1-RETO1', NULL, NULL, '2026-05-06 22:39:07', '2026-05-06 22:49:56'),
(920, 12, 'tiago', '100.67.140.106', 5, 'MV2-RETO1', NULL, NULL, '2026-05-06 22:39:21', '2026-05-06 22:40:21'),
(921, 12, 'tiago', '100.67.140.106', 5, 'MV2-RETO1', NULL, NULL, '2026-05-06 22:40:38', '2026-05-06 22:41:38'),
(922, 12, 'tiago', '100.67.140.106', 5, 'MV2-RETO1', NULL, NULL, '2026-05-06 22:41:53', '2026-05-06 22:42:54'),
(923, 12, 'tiago', '100.67.140.106', 5, 'MV2-RETO1', NULL, NULL, '2026-05-06 22:43:09', '2026-05-06 22:43:19'),
(924, 13, 'tiago.adm', '100.67.140.106', 5, 'MV2-RETO1', NULL, NULL, '2026-05-06 22:45:45', '2026-05-06 22:46:00'),
(925, 13, 'tiago.adm', '100.67.140.106', 5, 'MV2-RETO1', NULL, NULL, '2026-05-06 22:48:24', '2026-05-06 22:49:56'),
(926, 13, 'tiago.adm', '100.67.140.106', 6, 'MV3-RETO1', NULL, NULL, '2026-05-06 22:48:40', '2026-05-06 22:48:41'),
(927, 13, 'tiago.adm', '100.67.140.106', 5, 'MV2-RETO1', NULL, NULL, '2026-05-06 22:50:12', '2026-05-06 22:52:25'),
(928, 4, 'carmen', '100.67.140.106', 4, 'MV1-RETO1', NULL, NULL, '2026-05-06 22:50:41', '2026-05-06 22:51:13'),
(929, 3, 'luis', '100.67.140.106', 6, 'MV3-RETO1', NULL, NULL, '2026-05-06 22:51:23', '2026-05-06 22:52:25'),
(930, 4, 'carmen', '100.67.140.106', 4, 'MV1-RETO1', NULL, NULL, '2026-05-06 22:51:34', '2026-05-06 22:52:25'),
(931, 4, 'carmen', '100.76.130.112', 4, 'MV1-RETO1', NULL, NULL, '2026-05-06 23:45:11', NULL),
(932, 4, 'carmen', '100.76.130.112', 4, 'MV1-RETO1', NULL, NULL, '2026-05-07 19:54:27', '2026-05-07 19:54:42'),
(933, 4, 'carmen', '100.76.130.112', 4, 'MV1-RETO1', NULL, NULL, '2026-05-07 19:54:45', '2026-05-07 19:54:50'),
(934, 13, 'tiago.adm', '100.67.140.106', 4, 'MV1-RETO1', NULL, NULL, '2026-05-07 21:04:30', '2026-05-07 21:11:46'),
(935, 1, 'guacadmin', '100.76.130.112', 4, 'MV1-RETO1', NULL, NULL, '2026-05-07 21:32:35', '2026-05-07 21:32:50'),
(936, 13, 'tiago.adm', '127.0.0.1', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:30:23', '2026-05-07 22:30:24'),
(937, 13, 'tiago.adm', '127.0.0.1', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:30:34', '2026-05-07 22:30:35'),
(938, 13, 'tiago.adm', '127.0.0.1', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:30:38', '2026-05-07 22:30:53'),
(939, 13, 'tiago.adm', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-05-07 22:30:52', '2026-05-07 22:30:57'),
(940, 13, 'tiago.adm', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-05-07 22:31:09', '2026-05-07 22:31:10'),
(941, 13, 'tiago.adm', '127.0.0.1', 4, 'MV1-RETO1', NULL, NULL, '2026-05-07 22:32:10', '2026-05-07 22:33:13'),
(942, 13, 'tiago.adm', '127.0.0.1', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:33:10', '2026-05-07 22:33:10'),
(943, 13, 'tiago.adm', '127.0.0.1', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:33:21', '2026-05-07 22:33:36'),
(944, 13, 'tiago.adm', '127.0.0.1', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:33:54', '2026-05-07 22:34:47'),
(945, 1, 'guacadmin', '100.76.130.112', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:34:04', '2026-05-07 22:34:04'),
(946, 1, 'guacadmin', '100.76.130.112', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:34:05', '2026-05-07 22:34:06'),
(947, 1, 'guacadmin', '100.76.130.112', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:34:07', '2026-05-07 22:34:08'),
(948, 1, 'guacadmin', '100.76.130.112', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:34:08', '2026-05-07 22:34:08'),
(949, 1, 'guacadmin', '100.76.130.112', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:34:12', '2026-05-07 22:34:12'),
(950, 1, 'guacadmin', '100.76.130.112', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:34:16', '2026-05-07 22:34:16'),
(951, 1, 'guacadmin', '100.76.130.112', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:34:19', '2026-05-07 22:34:19'),
(952, 1, 'guacadmin', '100.76.130.112', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:34:22', '2026-05-07 22:34:22'),
(953, 1, 'guacadmin', '100.76.130.112', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:34:24', '2026-05-07 22:34:24'),
(954, 1, 'guacadmin', '100.76.130.112', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:34:25', '2026-05-07 22:34:25'),
(955, 1, 'guacadmin', '100.76.130.112', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:34:25', '2026-05-07 22:34:26'),
(956, 1, 'guacadmin', '100.76.130.112', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:34:26', '2026-05-07 22:34:26'),
(957, 1, 'guacadmin', '100.76.130.112', 8, 'MV2-RETO2', NULL, NULL, '2026-05-07 22:34:35', '2026-05-07 22:34:51'),
(958, 1, 'guacadmin', '100.76.130.112', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:34:52', '2026-05-07 22:34:53'),
(959, 1, 'guacadmin', '100.76.130.112', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:34:57', '2026-05-07 22:34:58'),
(960, 1, 'guacadmin', '100.76.130.112', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:34:59', '2026-05-07 22:34:59'),
(961, 1, 'guacadmin', '100.76.130.112', 4, 'MV1-RETO1', NULL, NULL, '2026-05-07 22:35:03', '2026-05-07 22:37:41'),
(962, 1, 'guacadmin', '100.76.130.112', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:37:44', '2026-05-07 22:38:01'),
(963, 13, 'tiago.adm', '127.0.0.1', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:38:08', '2026-05-07 22:39:03'),
(964, 1, 'guacadmin', '100.76.130.112', 8, 'MV2-RETO2', NULL, NULL, '2026-05-07 22:38:57', '2026-05-07 22:39:03'),
(965, 13, 'tiago.adm', '127.0.0.1', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:39:09', '2026-05-07 22:39:14'),
(966, 13, 'tiago.adm', '127.0.0.1', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:39:29', '2026-05-07 22:39:33'),
(967, 13, 'tiago.adm', '127.0.0.1', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:39:49', '2026-05-07 22:39:54'),
(968, 13, 'tiago.adm', '127.0.0.1', 7, 'MV1-RETO2', NULL, NULL, '2026-05-07 22:40:09', '2026-05-07 22:42:29'),
(969, 12, 'tiago', '100.98.238.69', 4, 'MV1-RETO1', NULL, NULL, '2026-05-08 12:05:16', '2026-05-08 12:05:32'),
(970, 13, 'tiago.adm', '100.98.238.69', 4, 'MV1-RETO1', NULL, NULL, '2026-05-08 12:05:54', '2026-05-08 12:06:19'),
(971, 13, 'tiago.adm', '100.98.238.69', 5, 'MV2-RETO1', NULL, NULL, '2026-05-08 12:07:17', '2026-05-08 12:07:28'),
(972, 13, 'tiago.adm', '100.98.238.69', 5, 'MV2-RETO1', NULL, NULL, '2026-05-08 12:07:28', '2026-05-08 12:07:48'),
(973, 13, 'tiago.adm', '100.98.238.69', 5, 'MV2-RETO1', NULL, NULL, '2026-05-08 12:09:02', '2026-05-08 12:09:33'),
(974, 12, 'tiago', '100.98.238.69', 4, 'MV1-RETO1', NULL, NULL, '2026-05-08 13:23:06', '2026-05-08 13:23:24'),
(975, 12, 'tiago', '100.98.238.69', 5, 'MV2-RETO1', NULL, NULL, '2026-05-08 13:23:34', '2026-05-08 13:24:00'),
(976, 12, 'tiago', '100.98.238.69', 5, 'MV2-RETO1', NULL, NULL, '2026-05-08 13:24:01', '2026-05-08 13:24:52'),
(977, 1, 'guacadmin', '127.0.0.1', 7, 'MV1-RETO2', NULL, NULL, '2026-05-08 22:09:20', NULL),
(978, 4, 'carmen', '100.76.130.112', 4, 'MV1-RETO1', NULL, NULL, '2026-05-08 22:14:36', '2026-05-08 22:14:51');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guacamole_connection_parameter`
--

CREATE TABLE `guacamole_connection_parameter` (
  `connection_id` int(11) NOT NULL,
  `parameter_name` varchar(128) NOT NULL,
  `parameter_value` varchar(4096) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Volcado de datos para la tabla `guacamole_connection_parameter`
--

INSERT INTO `guacamole_connection_parameter` (`connection_id`, `parameter_name`, `parameter_value`) VALUES
(4, 'color-depth', '24'),
(4, 'hostname', '100.118.43.1'),
(4, 'password', 'admin123'),
(4, 'port', '11801'),
(4, 'username', 'guacadmin'),
(5, 'color-depth', '24'),
(5, 'hostname', '100.103.205.110'),
(5, 'password', 'admin123'),
(5, 'port', '11801'),
(5, 'username', 'guacadmin'),
(6, 'color-depth', '24'),
(6, 'hostname', '100.89.47.2'),
(6, 'password', 'admin123'),
(6, 'port', '11801'),
(6, 'username', 'guacadmin'),
(7, 'color-depth', '24'),
(7, 'hostname', '192.168.1.199'),
(7, 'password', 'admin123'),
(7, 'port', '11801'),
(7, 'username', 'guacadmin'),
(8, 'color-depth', '24'),
(8, 'hostname', '100.102.221.64'),
(8, 'password', 'admin123'),
(8, 'port', '11801'),
(8, 'username', 'guacadmin'),
(9, 'color-depth', '24'),
(9, 'hostname', '100.90.121.35'),
(9, 'password', 'admin123'),
(9, 'port', '11801'),
(9, 'username', 'guacadmin');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guacamole_connection_permission`
--

CREATE TABLE `guacamole_connection_permission` (
  `entity_id` int(11) NOT NULL,
  `connection_id` int(11) NOT NULL,
  `permission` enum('READ','UPDATE','DELETE','ADMINISTER') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Volcado de datos para la tabla `guacamole_connection_permission`
--

INSERT INTO `guacamole_connection_permission` (`entity_id`, `connection_id`, `permission`) VALUES
(1, 4, 'READ'),
(1, 4, 'UPDATE'),
(1, 4, 'DELETE'),
(1, 4, 'ADMINISTER'),
(1, 5, 'READ'),
(1, 5, 'UPDATE'),
(1, 5, 'DELETE'),
(1, 5, 'ADMINISTER'),
(1, 6, 'READ'),
(1, 6, 'UPDATE'),
(1, 6, 'DELETE'),
(1, 6, 'ADMINISTER'),
(1, 7, 'READ'),
(1, 7, 'UPDATE'),
(1, 7, 'DELETE'),
(1, 7, 'ADMINISTER'),
(1, 8, 'READ'),
(1, 8, 'UPDATE'),
(1, 8, 'DELETE'),
(1, 8, 'ADMINISTER'),
(1, 9, 'READ'),
(1, 9, 'UPDATE'),
(1, 9, 'DELETE'),
(1, 9, 'ADMINISTER'),
(7, 4, 'READ'),
(7, 5, 'READ'),
(7, 6, 'READ'),
(7, 7, 'READ'),
(7, 8, 'READ'),
(7, 9, 'READ');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guacamole_entity`
--

CREATE TABLE `guacamole_entity` (
  `entity_id` int(11) NOT NULL,
  `name` varchar(128) NOT NULL,
  `type` enum('USER','USER_GROUP') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Volcado de datos para la tabla `guacamole_entity`
--

INSERT INTO `guacamole_entity` (`entity_id`, `name`, `type`) VALUES
(5, 'adolfo', 'USER'),
(15, 'asd', 'USER'),
(10, 'bale', 'USER'),
(4, 'carmen', 'USER'),
(1, 'guacadmin', 'USER'),
(6, 'jesus', 'USER'),
(11, 'julia', 'USER'),
(9, 'kiko', 'USER'),
(2, 'kiosko', 'USER'),
(3, 'luis', 'USER'),
(8, 'nico', 'USER'),
(12, 'pablo', 'USER'),
(13, 'tiago', 'USER'),
(14, 'tiago.adm', 'USER'),
(7, 'USUARIOS', 'USER_GROUP');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guacamole_sharing_profile`
--

CREATE TABLE `guacamole_sharing_profile` (
  `sharing_profile_id` int(11) NOT NULL,
  `sharing_profile_name` varchar(128) NOT NULL,
  `primary_connection_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guacamole_sharing_profile_attribute`
--

CREATE TABLE `guacamole_sharing_profile_attribute` (
  `sharing_profile_id` int(11) NOT NULL,
  `attribute_name` varchar(128) NOT NULL,
  `attribute_value` varchar(4096) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guacamole_sharing_profile_parameter`
--

CREATE TABLE `guacamole_sharing_profile_parameter` (
  `sharing_profile_id` int(11) NOT NULL,
  `parameter_name` varchar(128) NOT NULL,
  `parameter_value` varchar(4096) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guacamole_sharing_profile_permission`
--

CREATE TABLE `guacamole_sharing_profile_permission` (
  `entity_id` int(11) NOT NULL,
  `sharing_profile_id` int(11) NOT NULL,
  `permission` enum('READ','UPDATE','DELETE','ADMINISTER') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guacamole_system_permission`
--

CREATE TABLE `guacamole_system_permission` (
  `entity_id` int(11) NOT NULL,
  `permission` enum('CREATE_CONNECTION','CREATE_CONNECTION_GROUP','CREATE_SHARING_PROFILE','CREATE_USER','CREATE_USER_GROUP','ADMINISTER') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Volcado de datos para la tabla `guacamole_system_permission`
--

INSERT INTO `guacamole_system_permission` (`entity_id`, `permission`) VALUES
(1, 'ADMINISTER'),
(2, 'CREATE_CONNECTION'),
(2, 'CREATE_CONNECTION_GROUP'),
(2, 'CREATE_SHARING_PROFILE'),
(2, 'CREATE_USER'),
(2, 'CREATE_USER_GROUP'),
(2, 'ADMINISTER'),
(14, 'CREATE_CONNECTION'),
(14, 'CREATE_CONNECTION_GROUP'),
(14, 'CREATE_SHARING_PROFILE'),
(14, 'CREATE_USER'),
(14, 'CREATE_USER_GROUP'),
(14, 'ADMINISTER');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guacamole_user`
--

CREATE TABLE `guacamole_user` (
  `user_id` int(11) NOT NULL,
  `entity_id` int(11) NOT NULL,
  `password_hash` binary(32) NOT NULL,
  `password_salt` binary(32) DEFAULT NULL,
  `password_date` datetime NOT NULL,
  `disabled` tinyint(1) NOT NULL DEFAULT 0,
  `expired` tinyint(1) NOT NULL DEFAULT 0,
  `access_window_start` time DEFAULT NULL,
  `access_window_end` time DEFAULT NULL,
  `valid_from` date DEFAULT NULL,
  `valid_until` date DEFAULT NULL,
  `timezone` varchar(64) DEFAULT NULL,
  `full_name` varchar(256) DEFAULT NULL,
  `email_address` varchar(256) DEFAULT NULL,
  `organization` varchar(256) DEFAULT NULL,
  `organizational_role` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Volcado de datos para la tabla `guacamole_user`
--

INSERT INTO `guacamole_user` (`user_id`, `entity_id`, `password_hash`, `password_salt`, `password_date`, `disabled`, `expired`, `access_window_start`, `access_window_end`, `valid_from`, `valid_until`, `timezone`, `full_name`, `email_address`, `organization`, `organizational_role`) VALUES
(1, 1, 0x3ddba4775a842decc65f5706098255742692c64702fe6d3d7f684ca1cbb6c467, 0x9e300036f92224471ebe00ae9920107a8494748438baa0c894396328af0e05b1, '2025-12-25 13:28:08', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 2, 0x886ed8d4886d2feae0e0f40fae655742392fa2f88107cc3f2d24bd7f34c16a5b, 0x694b4f8429d846c633a53e1764a0df59bb2c05c66f6e9c7299b54b6ea205d463, '2026-03-25 10:21:39', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3, 3, 0x7c6e1ec17b5d7f6616474f06aa4f77600dcbd7877c859c6ed4f61d56c025e949, 0x7db2a08c806511291e1573f6cdb21e4283550c3cb472d938e0140b727e34f383, '2026-04-20 18:08:54', 0, 0, NULL, NULL, NULL, NULL, NULL, 'luis', 'luis@gmail.com', NULL, NULL),
(4, 4, 0x7a05be2189863aaf9c30ebcfbf540e35f76eb49f6d0d8835b7f2f6f9279aa6df, 0x7695ee60916af705657db56a8a71869e6f1be0d7b5937c3b4254589d5743898f, '2026-04-20 18:18:29', 0, 0, NULL, NULL, NULL, NULL, NULL, 'carmen', 'carmen@gmail.com', NULL, NULL),
(5, 5, 0xc41887326bde4179121bbbf9fd5f38fe6072642c95820fcf6f045be6c411bc7a, 0x0f56eda48fce7a2754d2d042abeae35926d64994c66cdc186081995efb5a029a, '2026-04-20 18:55:03', 0, 0, NULL, NULL, NULL, NULL, NULL, 'adolfo', 'adolfo@gmail.com', NULL, NULL),
(6, 6, 0xd42aa057113ee9aeaad17e8c92c83e6ad55ed1fecf66665d5d4351fdfb1c4522, 0x848a6ad5ffebe035650c886ad800b4e49ed558d68c134fc02ccb7328d97b7a2e, '2026-04-20 19:09:46', 0, 0, NULL, NULL, NULL, NULL, NULL, 'jesus', 'jesus@gmail.com', NULL, NULL),
(7, 8, 0xc889806cc9a9e1dd6dcf9d6f3bd6789a73912044dce0a34dcd98581495aa309c, 0xafcf8cb07ef2caca116207727e6990c291c20ec45ad089b552b7a7b73cda33ef, '2026-04-20 20:53:00', 0, 0, NULL, NULL, NULL, NULL, NULL, 'nico', 'nico@gmail.com', NULL, NULL),
(8, 9, 0xbb6e8435bdf6f1037d4dddab7fa853c4e397d556b21d027dfc88a4cb1a799f18, 0x02ece3350349a0a32d62b990b92160bc324553221b06de3702a2d6f7570bfbe0, '2026-04-20 20:56:11', 0, 0, NULL, NULL, NULL, NULL, NULL, 'kiko', 'kiko@gmail.com', NULL, NULL),
(9, 10, 0x21c4e3623898cceda222dac0d4afba208da2f3d4a34def9faa52539cbee9d6fa, 0x424225cf41b36d27b992dbf0170aa941e193c54498b16d94deab38024a56a79d, '2026-04-22 09:23:00', 0, 0, NULL, NULL, NULL, NULL, NULL, 'bale', 'bale@gmail.com', NULL, NULL),
(10, 11, 0xb28606b16255e1fbbc54b532f2316fb7d3da0ce4f47dd4d108fe64330260da68, 0x71434cdda06a2782e0ac194b9ce074cfeeb37962291b86b04ac274ac359d40a4, '2026-04-22 10:12:45', 0, 0, NULL, NULL, NULL, NULL, NULL, 'julia', 'julia@gmail.com', NULL, NULL),
(11, 12, 0x648ad560cea9797b1ddd5fadd8aa1dde52c928c32123c2ff51eac7bc27320e41, 0xc20af5f22cff00a34d0167741e47007cbabfac450f3597eb931a20ffcfb7a577, '2026-04-22 10:50:43', 0, 0, NULL, NULL, NULL, NULL, NULL, 'pablo', 'pablo@gmail.com', NULL, NULL),
(12, 13, 0xd03ffbac9f2dc3f5fe96e0a64a544bd2e876e2657aaa27a4fcf7c94ac7fbc2c6, 0xf7eaaa6eb59807df0909dd625cc212ef1a3a22ae11e1a4afcc807eb3ecaf6b0e, '2026-04-22 11:03:36', 0, 0, NULL, NULL, NULL, NULL, NULL, 'tiago', 'tiago@tiago.es', NULL, NULL),
(13, 14, 0x4d300d1e46516af8a22713734004c968f7d4a53bdec3aa6a50d60159523ec536, 0x89de906d31630dc4f53d7ccf1b826f27426897a711b8857cc4c118569a457a8f, '2026-04-22 11:03:59', 0, 0, NULL, NULL, NULL, NULL, NULL, 'tiago.adm', 'tiago.adm@tiago.adm.es', NULL, NULL),
(14, 15, 0x79b136daa0bfb600facb246b201e60f3701594330b5db3abe3dbb18959de467a, 0xa20ada1a4691a3f1618f401ea9c7938fecc9ae7bb61b90d6657b8c047408fde6, '2026-05-09 00:07:46', 0, 0, NULL, NULL, NULL, NULL, NULL, 'asd', 'asd@asd.es', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guacamole_user_attribute`
--

CREATE TABLE `guacamole_user_attribute` (
  `user_id` int(11) NOT NULL,
  `attribute_name` varchar(128) NOT NULL,
  `attribute_value` varchar(4096) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guacamole_user_group`
--

CREATE TABLE `guacamole_user_group` (
  `user_group_id` int(11) NOT NULL,
  `entity_id` int(11) NOT NULL,
  `disabled` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Volcado de datos para la tabla `guacamole_user_group`
--

INSERT INTO `guacamole_user_group` (`user_group_id`, `entity_id`, `disabled`) VALUES
(1, 7, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guacamole_user_group_attribute`
--

CREATE TABLE `guacamole_user_group_attribute` (
  `user_group_id` int(11) NOT NULL,
  `attribute_name` varchar(128) NOT NULL,
  `attribute_value` varchar(4096) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guacamole_user_group_member`
--

CREATE TABLE `guacamole_user_group_member` (
  `user_group_id` int(11) NOT NULL,
  `member_entity_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Volcado de datos para la tabla `guacamole_user_group_member`
--

INSERT INTO `guacamole_user_group_member` (`user_group_id`, `member_entity_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 9),
(1, 10),
(1, 11),
(1, 12),
(1, 13),
(1, 14),
(1, 15);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guacamole_user_group_permission`
--

CREATE TABLE `guacamole_user_group_permission` (
  `entity_id` int(11) NOT NULL,
  `affected_user_group_id` int(11) NOT NULL,
  `permission` enum('READ','UPDATE','DELETE','ADMINISTER') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Volcado de datos para la tabla `guacamole_user_group_permission`
--

INSERT INTO `guacamole_user_group_permission` (`entity_id`, `affected_user_group_id`, `permission`) VALUES
(1, 1, 'READ'),
(1, 1, 'UPDATE'),
(1, 1, 'DELETE'),
(1, 1, 'ADMINISTER');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guacamole_user_history`
--

CREATE TABLE `guacamole_user_history` (
  `history_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `username` varchar(128) NOT NULL,
  `remote_host` varchar(256) DEFAULT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Volcado de datos para la tabla `guacamole_user_history`
--

INSERT INTO `guacamole_user_history` (`history_id`, `user_id`, `username`, `remote_host`, `start_date`, `end_date`) VALUES
(1, 1, 'guacadmin', '172.20.6.12', '2025-11-12 11:02:38', NULL),
(2, 1, 'guacadmin', '172.20.6.11', '2025-11-19 09:32:26', NULL),
(3, 1, 'guacadmin', '127.0.0.1', '2025-11-19 09:48:04', NULL),
(4, 1, 'guacadmin', '127.0.0.1', '2025-11-19 10:15:48', NULL),
(5, 1, 'guacadmin', '127.0.0.1', '2025-11-19 10:53:45', NULL),
(6, 1, 'guacadmin', '127.0.0.1', '2025-11-19 10:56:33', NULL),
(7, 1, 'guacadmin', '127.0.0.1', '2025-11-19 11:01:37', '2025-11-19 14:14:07'),
(8, 1, 'guacadmin', '127.0.0.1', '2025-11-26 09:20:48', NULL),
(9, 1, 'guacadmin', '127.0.0.1', '2025-11-26 16:21:52', NULL),
(10, 1, 'guacadmin', '127.0.0.1', '2025-11-26 16:44:42', NULL),
(11, 1, 'guacadmin', '127.0.0.1', '2025-12-01 16:23:45', NULL),
(12, 1, 'guacadmin', '127.0.0.1', '2025-12-01 16:25:06', NULL),
(13, 1, 'guacadmin', '127.0.0.1', '2025-12-01 16:37:14', NULL),
(14, 1, 'guacadmin', '127.0.0.1', '2025-12-01 16:38:37', NULL),
(15, NULL, '30572179-49d9-45b6-8a48-dcbfe1cf02f6', '127.0.0.1', '2025-12-01 17:17:30', NULL),
(16, 1, 'guacadmin', '127.0.0.1', '2025-12-01 17:23:25', NULL),
(17, 1, 'guacadmin', '127.0.0.1', '2025-12-17 09:25:58', NULL),
(18, 1, 'guacadmin', '10.130.84.186', '2025-12-17 09:27:35', NULL),
(19, 1, 'guacadmin', '127.0.0.1', '2025-12-25 12:06:54', NULL),
(20, 1, 'guacadmin', '127.0.0.1', '2025-12-25 12:11:07', NULL),
(21, 1, 'guacadmin', '127.0.0.1', '2025-12-25 13:19:19', '2025-12-25 13:19:32'),
(22, 1, 'guacadmin', '127.0.0.1', '2025-12-25 13:19:35', '2025-12-25 13:27:09'),
(23, 1, 'guacadmin', '127.0.0.1', '2025-12-25 13:27:12', NULL),
(24, 1, 'guacadmin', '127.0.0.1', '2026-01-21 09:26:13', NULL),
(25, 2, 'kiosko', '127.0.0.1', '2026-01-21 09:53:43', '2026-01-21 10:55:12'),
(26, 2, 'kiosko', '127.0.0.1', '2026-01-21 10:23:59', NULL),
(27, 2, 'kiosko', '127.0.0.1', '2026-01-21 10:27:41', '2026-01-21 10:28:37'),
(28, 2, 'kiosko', '127.0.0.1', '2026-01-21 10:28:37', '2026-01-21 10:29:17'),
(29, 2, 'kiosko', '127.0.0.1', '2026-01-21 10:29:33', '2026-01-21 10:39:59'),
(30, 2, 'kiosko', '127.0.0.1', '2026-01-21 10:40:01', '2026-01-21 10:42:23'),
(31, 2, 'kiosko', '127.0.0.1', '2026-01-21 10:42:30', NULL),
(32, 2, 'kiosko', '127.0.0.1', '2026-01-21 10:44:32', '2026-01-21 10:52:26'),
(33, 2, 'kiosko', '127.0.0.1', '2026-01-21 11:00:55', '2026-01-21 11:07:16'),
(34, 2, 'kiosko', '127.0.0.1', '2026-01-28 10:18:36', NULL),
(35, 2, 'kiosko', '127.0.0.1', '2026-01-28 10:28:00', NULL),
(36, 2, 'kiosko', '127.0.0.1', '2026-02-11 10:17:30', NULL),
(37, 1, 'guacadmin', '127.0.0.1', '2026-02-11 10:18:27', NULL),
(38, 2, 'kiosko', '127.0.0.1', '2026-02-11 10:20:00', NULL),
(39, 2, 'kiosko', '127.0.0.1', '2026-02-11 10:21:49', NULL),
(40, 1, 'guacadmin', '127.0.0.1', '2026-02-11 10:28:13', NULL),
(41, 2, 'kiosko', '127.0.0.1', '2026-02-11 10:28:32', NULL),
(42, 1, 'guacadmin', '127.0.0.1', '2026-02-20 20:06:58', NULL),
(43, 2, 'kiosko', '127.0.0.1', '2026-02-20 20:09:39', NULL),
(44, 2, 'kiosko', '127.0.0.1', '2026-02-25 09:24:28', '2026-02-25 09:24:40'),
(45, 1, 'guacadmin', '127.0.0.1', '2026-02-25 09:25:50', NULL),
(46, 1, 'guacadmin', '127.0.0.1', '2026-02-25 09:26:12', '2026-02-25 09:30:00'),
(47, 2, 'kiosko', '127.0.0.1', '2026-02-25 09:30:04', NULL),
(48, 2, 'kiosko', '127.0.0.1', '2026-03-04 09:39:32', NULL),
(49, 2, 'kiosko', '127.0.0.1', '2026-03-04 09:53:45', '2026-03-04 09:57:11'),
(50, 2, 'kiosko', '127.0.0.1', '2026-03-04 09:57:14', NULL),
(51, 2, 'kiosko', '127.0.0.1', '2026-03-04 10:00:10', NULL),
(52, 1, 'guacadmin', '127.0.0.1', '2026-03-04 10:01:26', NULL),
(53, 2, 'kiosko', '127.0.0.1', '2026-03-11 09:28:17', NULL),
(54, 1, 'guacadmin', '127.0.0.1', '2026-03-11 09:32:33', NULL),
(55, 1, 'guacadmin', '100.67.140.106', '2026-03-25 10:20:17', '2026-03-25 11:25:02'),
(56, 2, 'kiosko', '127.0.0.1', '2026-04-12 14:31:49', '2026-04-12 15:34:07'),
(57, 2, 'kiosko', '127.0.0.1', '2026-04-12 15:17:37', NULL),
(58, 1, 'guacadmin', '127.0.0.1', '2026-04-15 11:00:58', NULL),
(59, 1, 'guacadmin', '127.0.0.1', '2026-04-15 11:01:28', NULL),
(60, 2, 'kiosko', '127.0.0.1', '2026-04-15 11:09:19', NULL),
(61, 2, 'kiosko', '127.0.0.1', '2026-04-15 14:19:44', '2026-04-15 14:23:20'),
(62, 2, 'kiosko', '127.0.0.1', '2026-04-15 14:23:23', '2026-04-15 14:23:34'),
(63, 2, 'kiosko', '127.0.0.1', '2026-04-15 14:27:48', '2026-04-15 14:31:47'),
(64, 2, 'kiosko', '127.0.0.1', '2026-04-15 14:32:30', NULL),
(65, 1, 'guacadmin', '127.0.0.1', '2026-04-15 21:25:41', '2026-04-16 00:11:21'),
(66, 2, 'kiosko', '127.0.0.1', '2026-04-15 23:01:53', '2026-04-15 23:08:01'),
(67, 2, 'kiosko', '127.0.0.1', '2026-04-15 23:08:06', '2026-04-16 00:20:21'),
(68, 2, 'kiosko', '127.0.0.1', '2026-04-15 23:08:07', '2026-04-15 23:11:43'),
(69, 1, 'guacadmin', '127.0.0.1', '2026-04-15 23:11:47', '2026-04-16 00:19:21'),
(70, 1, 'guacadmin', '127.0.0.1', '2026-04-15 23:18:23', '2026-04-16 00:19:21'),
(71, 1, 'guacadmin', '127.0.0.1', '2026-04-17 18:29:36', NULL),
(72, 1, 'guacadmin', '127.0.0.1', '2026-04-20 16:17:23', '2026-04-20 17:41:29'),
(73, 1, 'guacadmin', '127.0.0.1', '2026-04-20 17:39:34', NULL),
(74, 3, 'luis', '127.0.0.1', '2026-04-20 18:09:12', '2026-04-20 18:13:07'),
(75, 3, 'luis', '127.0.0.1', '2026-04-20 18:13:17', '2026-04-20 18:13:37'),
(76, 3, 'luis', '127.0.0.1', '2026-04-20 18:13:42', '2026-04-20 18:20:34'),
(77, 4, 'carmen', '127.0.0.1', '2026-04-20 18:20:39', '2026-04-20 18:24:54'),
(78, 4, 'carmen', '127.0.0.1', '2026-04-20 18:25:06', '2026-04-20 18:25:15'),
(79, 4, 'carmen', '127.0.0.1', '2026-04-20 18:25:20', '2026-04-20 18:55:45'),
(80, 5, 'adolfo', '127.0.0.1', '2026-04-20 18:55:50', NULL),
(81, 6, 'jesus', '127.0.0.1', '2026-04-20 19:10:00', '2026-04-20 19:10:07'),
(82, 6, 'jesus', '127.0.0.1', '2026-04-20 19:10:14', NULL),
(83, 1, 'guacadmin', '127.0.0.1', '2026-04-20 19:30:45', '2026-04-20 19:50:32'),
(84, 1, 'guacadmin', '127.0.0.1', '2026-04-20 19:40:23', '2026-04-20 20:41:35'),
(85, 1, 'guacadmin', '127.0.0.1', '2026-04-20 19:41:31', '2026-04-20 20:56:35'),
(86, 4, 'carmen', '127.0.0.1', '2026-04-20 19:50:39', '2026-04-20 19:53:46'),
(87, 1, 'guacadmin', '127.0.0.1', '2026-04-20 19:50:51', '2026-04-20 21:56:35'),
(88, 4, 'carmen', '127.0.0.1', '2026-04-20 19:54:03', NULL),
(89, 3, 'luis', '127.0.0.1', '2026-04-20 19:56:15', '2026-04-20 21:45:35'),
(90, 9, 'bale', '127.0.0.1', '2026-04-22 09:23:15', NULL),
(91, 9, 'bale', '127.0.0.1', '2026-04-22 10:12:12', NULL),
(92, 10, 'julia', '127.0.0.1', '2026-04-22 10:13:02', NULL),
(93, 10, 'julia', '127.0.0.1', '2026-04-22 10:20:02', '2026-04-22 10:47:25'),
(94, 9, 'bale', '127.0.0.1', '2026-04-22 10:47:36', NULL),
(95, 11, 'pablo', '127.0.0.1', '2026-04-22 10:51:01', '2026-04-22 10:52:22'),
(96, 11, 'pablo', '127.0.0.1', '2026-04-22 10:52:28', '2026-04-22 10:54:09'),
(97, 10, 'julia', '127.0.0.1', '2026-04-22 10:54:15', '2026-04-22 11:06:33'),
(98, 1, 'guacadmin', '100.127.7.116', '2026-04-22 10:57:00', NULL),
(99, 9, 'bale', '127.0.0.1', '2026-04-22 23:28:59', NULL),
(100, 10, 'julia', '127.0.0.1', '2026-04-22 23:31:58', NULL),
(101, 1, 'guacadmin', '127.0.0.1', '2026-04-29 10:44:45', NULL),
(102, 10, 'julia', '127.0.0.1', '2026-04-29 10:47:30', NULL),
(103, 12, 'tiago', '127.0.0.1', '2026-04-29 10:52:29', NULL),
(104, 12, 'tiago', '100.67.140.106', '2026-05-06 21:04:53', '2026-05-06 21:51:39'),
(105, 13, 'tiago.adm', '100.67.140.106', '2026-05-06 21:51:47', '2026-05-06 22:17:06'),
(106, 1, 'guacadmin', '127.0.0.1', '2026-05-06 22:01:03', '2026-05-06 23:20:26'),
(107, 12, 'tiago', '127.0.0.1', '2026-05-06 22:11:05', '2026-05-06 22:11:26'),
(108, 13, 'tiago.adm', '127.0.0.1', '2026-05-06 22:11:40', '2026-05-06 22:11:47'),
(109, 1, 'guacadmin', '127.0.0.1', '2026-05-06 22:11:53', '2026-05-06 22:12:56'),
(110, 13, 'tiago.adm', '127.0.0.1', '2026-05-06 22:13:01', '2026-05-06 22:48:21'),
(111, 12, 'tiago', '100.67.140.106', '2026-05-06 22:18:05', '2026-05-06 22:45:21'),
(112, 4, 'carmen', '100.76.130.112', '2026-05-06 22:39:07', '2026-05-06 22:49:59'),
(113, 13, 'tiago.adm', '100.67.140.106', '2026-05-06 22:45:44', '2026-05-06 23:52:26'),
(114, 4, 'carmen', '100.67.140.106', '2026-05-06 22:49:26', '2026-05-06 22:49:29'),
(115, 4, 'carmen', '100.67.140.106', '2026-05-06 22:49:33', '2026-05-06 22:49:39'),
(116, 13, 'tiago.adm', '100.67.140.106', '2026-05-06 22:49:43', '2026-05-06 22:49:59'),
(117, 4, 'carmen', '100.67.140.106', '2026-05-06 22:50:40', '2026-05-06 22:51:13'),
(118, 3, 'luis', '100.67.140.106', '2026-05-06 22:51:17', '2026-05-06 23:52:26'),
(119, 4, 'carmen', '100.67.140.106', '2026-05-06 22:51:34', '2026-05-06 23:52:26'),
(120, 13, 'tiago.adm', '127.0.0.1', '2026-05-06 22:52:12', '2026-05-06 23:52:26'),
(121, 4, 'carmen', '100.76.130.112', '2026-05-06 23:45:11', NULL),
(122, 4, 'carmen', '100.76.130.112', '2026-05-07 19:54:26', '2026-05-07 20:55:56'),
(123, 13, 'tiago.adm', '100.67.140.106', '2026-05-07 21:04:29', '2026-05-07 22:11:56'),
(124, 13, 'tiago.adm', '127.0.0.1', '2026-05-07 21:12:21', '2026-05-07 22:12:56'),
(125, 1, 'guacadmin', '100.76.130.112', '2026-05-07 21:32:35', '2026-05-07 23:39:56'),
(126, 1, 'guacadmin', '100.76.130.112', '2026-05-07 21:34:42', '2026-05-07 22:35:56'),
(127, 13, 'tiago.adm', '127.0.0.1', '2026-05-07 22:30:13', '2026-05-07 22:30:58'),
(128, 13, 'tiago.adm', '127.0.0.1', '2026-05-07 22:31:03', '2026-05-07 22:32:02'),
(129, 13, 'tiago.adm', '127.0.0.1', '2026-05-07 22:32:06', '2026-05-07 22:33:13'),
(130, 13, 'tiago.adm', '127.0.0.1', '2026-05-07 22:33:19', '2026-05-07 23:40:56'),
(131, 12, 'tiago', '100.98.238.69', '2026-05-08 12:05:07', '2026-05-08 12:05:33'),
(132, 13, 'tiago.adm', '100.98.238.69', '2026-05-08 12:05:49', '2026-05-08 13:09:56'),
(133, 12, 'tiago', '100.98.238.69', '2026-05-08 13:23:05', '2026-05-08 14:25:56'),
(134, 4, 'carmen', '127.0.0.1', '2026-05-08 22:07:11', '2026-05-08 22:07:54'),
(135, 1, 'guacadmin', '127.0.0.1', '2026-05-08 22:08:02', NULL),
(136, 4, 'carmen', '100.76.130.112', '2026-05-08 22:14:35', '2026-05-08 23:14:56');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guacamole_user_password_history`
--

CREATE TABLE `guacamole_user_password_history` (
  `password_history_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `password_hash` binary(32) NOT NULL,
  `password_salt` binary(32) DEFAULT NULL,
  `password_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guacamole_user_permission`
--

CREATE TABLE `guacamole_user_permission` (
  `entity_id` int(11) NOT NULL,
  `affected_user_id` int(11) NOT NULL,
  `permission` enum('READ','UPDATE','DELETE','ADMINISTER') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Volcado de datos para la tabla `guacamole_user_permission`
--

INSERT INTO `guacamole_user_permission` (`entity_id`, `affected_user_id`, `permission`) VALUES
(1, 2, 'READ'),
(1, 2, 'UPDATE'),
(1, 2, 'DELETE'),
(1, 2, 'ADMINISTER'),
(2, 2, 'READ'),
(2, 2, 'UPDATE'),
(3, 3, 'READ'),
(4, 4, 'READ'),
(5, 5, 'READ'),
(6, 6, 'READ'),
(14, 13, 'UPDATE');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `guacamole_connection`
--
ALTER TABLE `guacamole_connection`
  ADD PRIMARY KEY (`connection_id`),
  ADD UNIQUE KEY `connection_name_parent` (`connection_name`,`parent_id`),
  ADD KEY `guacamole_connection_ibfk_1` (`parent_id`);

--
-- Indices de la tabla `guacamole_connection_attribute`
--
ALTER TABLE `guacamole_connection_attribute`
  ADD PRIMARY KEY (`connection_id`,`attribute_name`),
  ADD KEY `connection_id` (`connection_id`);

--
-- Indices de la tabla `guacamole_connection_group`
--
ALTER TABLE `guacamole_connection_group`
  ADD PRIMARY KEY (`connection_group_id`),
  ADD UNIQUE KEY `connection_group_name_parent` (`connection_group_name`,`parent_id`),
  ADD KEY `guacamole_connection_group_ibfk_1` (`parent_id`);

--
-- Indices de la tabla `guacamole_connection_group_attribute`
--
ALTER TABLE `guacamole_connection_group_attribute`
  ADD PRIMARY KEY (`connection_group_id`,`attribute_name`),
  ADD KEY `connection_group_id` (`connection_group_id`);

--
-- Indices de la tabla `guacamole_connection_group_permission`
--
ALTER TABLE `guacamole_connection_group_permission`
  ADD PRIMARY KEY (`entity_id`,`connection_group_id`,`permission`),
  ADD KEY `guacamole_connection_group_permission_ibfk_1` (`connection_group_id`);

--
-- Indices de la tabla `guacamole_connection_history`
--
ALTER TABLE `guacamole_connection_history`
  ADD PRIMARY KEY (`history_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `connection_id` (`connection_id`),
  ADD KEY `sharing_profile_id` (`sharing_profile_id`),
  ADD KEY `start_date` (`start_date`),
  ADD KEY `end_date` (`end_date`),
  ADD KEY `connection_start_date` (`connection_id`,`start_date`);

--
-- Indices de la tabla `guacamole_connection_parameter`
--
ALTER TABLE `guacamole_connection_parameter`
  ADD PRIMARY KEY (`connection_id`,`parameter_name`);

--
-- Indices de la tabla `guacamole_connection_permission`
--
ALTER TABLE `guacamole_connection_permission`
  ADD PRIMARY KEY (`entity_id`,`connection_id`,`permission`),
  ADD KEY `guacamole_connection_permission_ibfk_1` (`connection_id`);

--
-- Indices de la tabla `guacamole_entity`
--
ALTER TABLE `guacamole_entity`
  ADD PRIMARY KEY (`entity_id`),
  ADD UNIQUE KEY `guacamole_entity_name_scope` (`type`,`name`);

--
-- Indices de la tabla `guacamole_sharing_profile`
--
ALTER TABLE `guacamole_sharing_profile`
  ADD PRIMARY KEY (`sharing_profile_id`),
  ADD UNIQUE KEY `sharing_profile_name_primary` (`sharing_profile_name`,`primary_connection_id`),
  ADD KEY `guacamole_sharing_profile_ibfk_1` (`primary_connection_id`);

--
-- Indices de la tabla `guacamole_sharing_profile_attribute`
--
ALTER TABLE `guacamole_sharing_profile_attribute`
  ADD PRIMARY KEY (`sharing_profile_id`,`attribute_name`),
  ADD KEY `sharing_profile_id` (`sharing_profile_id`);

--
-- Indices de la tabla `guacamole_sharing_profile_parameter`
--
ALTER TABLE `guacamole_sharing_profile_parameter`
  ADD PRIMARY KEY (`sharing_profile_id`,`parameter_name`);

--
-- Indices de la tabla `guacamole_sharing_profile_permission`
--
ALTER TABLE `guacamole_sharing_profile_permission`
  ADD PRIMARY KEY (`entity_id`,`sharing_profile_id`,`permission`),
  ADD KEY `guacamole_sharing_profile_permission_ibfk_1` (`sharing_profile_id`);

--
-- Indices de la tabla `guacamole_system_permission`
--
ALTER TABLE `guacamole_system_permission`
  ADD PRIMARY KEY (`entity_id`,`permission`);

--
-- Indices de la tabla `guacamole_user`
--
ALTER TABLE `guacamole_user`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `guacamole_user_single_entity` (`entity_id`);

--
-- Indices de la tabla `guacamole_user_attribute`
--
ALTER TABLE `guacamole_user_attribute`
  ADD PRIMARY KEY (`user_id`,`attribute_name`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `guacamole_user_group`
--
ALTER TABLE `guacamole_user_group`
  ADD PRIMARY KEY (`user_group_id`),
  ADD UNIQUE KEY `guacamole_user_group_single_entity` (`entity_id`);

--
-- Indices de la tabla `guacamole_user_group_attribute`
--
ALTER TABLE `guacamole_user_group_attribute`
  ADD PRIMARY KEY (`user_group_id`,`attribute_name`),
  ADD KEY `user_group_id` (`user_group_id`);

--
-- Indices de la tabla `guacamole_user_group_member`
--
ALTER TABLE `guacamole_user_group_member`
  ADD PRIMARY KEY (`user_group_id`,`member_entity_id`),
  ADD KEY `guacamole_user_group_member_entity_id` (`member_entity_id`);

--
-- Indices de la tabla `guacamole_user_group_permission`
--
ALTER TABLE `guacamole_user_group_permission`
  ADD PRIMARY KEY (`entity_id`,`affected_user_group_id`,`permission`),
  ADD KEY `guacamole_user_group_permission_affected_user_group` (`affected_user_group_id`);

--
-- Indices de la tabla `guacamole_user_history`
--
ALTER TABLE `guacamole_user_history`
  ADD PRIMARY KEY (`history_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `start_date` (`start_date`),
  ADD KEY `end_date` (`end_date`),
  ADD KEY `user_start_date` (`user_id`,`start_date`);

--
-- Indices de la tabla `guacamole_user_password_history`
--
ALTER TABLE `guacamole_user_password_history`
  ADD PRIMARY KEY (`password_history_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `guacamole_user_permission`
--
ALTER TABLE `guacamole_user_permission`
  ADD PRIMARY KEY (`entity_id`,`affected_user_id`,`permission`),
  ADD KEY `guacamole_user_permission_ibfk_1` (`affected_user_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `guacamole_connection`
--
ALTER TABLE `guacamole_connection`
  MODIFY `connection_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `guacamole_connection_group`
--
ALTER TABLE `guacamole_connection_group`
  MODIFY `connection_group_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `guacamole_connection_history`
--
ALTER TABLE `guacamole_connection_history`
  MODIFY `history_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=979;

--
-- AUTO_INCREMENT de la tabla `guacamole_entity`
--
ALTER TABLE `guacamole_entity`
  MODIFY `entity_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `guacamole_sharing_profile`
--
ALTER TABLE `guacamole_sharing_profile`
  MODIFY `sharing_profile_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `guacamole_user`
--
ALTER TABLE `guacamole_user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `guacamole_user_group`
--
ALTER TABLE `guacamole_user_group`
  MODIFY `user_group_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `guacamole_user_history`
--
ALTER TABLE `guacamole_user_history`
  MODIFY `history_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=137;

--
-- AUTO_INCREMENT de la tabla `guacamole_user_password_history`
--
ALTER TABLE `guacamole_user_password_history`
  MODIFY `password_history_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `guacamole_connection`
--
ALTER TABLE `guacamole_connection`
  ADD CONSTRAINT `guacamole_connection_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `guacamole_connection_group` (`connection_group_id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `guacamole_connection_attribute`
--
ALTER TABLE `guacamole_connection_attribute`
  ADD CONSTRAINT `guacamole_connection_attribute_ibfk_1` FOREIGN KEY (`connection_id`) REFERENCES `guacamole_connection` (`connection_id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `guacamole_connection_group`
--
ALTER TABLE `guacamole_connection_group`
  ADD CONSTRAINT `guacamole_connection_group_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `guacamole_connection_group` (`connection_group_id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `guacamole_connection_group_attribute`
--
ALTER TABLE `guacamole_connection_group_attribute`
  ADD CONSTRAINT `guacamole_connection_group_attribute_ibfk_1` FOREIGN KEY (`connection_group_id`) REFERENCES `guacamole_connection_group` (`connection_group_id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `guacamole_connection_group_permission`
--
ALTER TABLE `guacamole_connection_group_permission`
  ADD CONSTRAINT `guacamole_connection_group_permission_entity` FOREIGN KEY (`entity_id`) REFERENCES `guacamole_entity` (`entity_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `guacamole_connection_group_permission_ibfk_1` FOREIGN KEY (`connection_group_id`) REFERENCES `guacamole_connection_group` (`connection_group_id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `guacamole_connection_history`
--
ALTER TABLE `guacamole_connection_history`
  ADD CONSTRAINT `guacamole_connection_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `guacamole_user` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `guacamole_connection_history_ibfk_2` FOREIGN KEY (`connection_id`) REFERENCES `guacamole_connection` (`connection_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `guacamole_connection_history_ibfk_3` FOREIGN KEY (`sharing_profile_id`) REFERENCES `guacamole_sharing_profile` (`sharing_profile_id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `guacamole_connection_parameter`
--
ALTER TABLE `guacamole_connection_parameter`
  ADD CONSTRAINT `guacamole_connection_parameter_ibfk_1` FOREIGN KEY (`connection_id`) REFERENCES `guacamole_connection` (`connection_id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `guacamole_connection_permission`
--
ALTER TABLE `guacamole_connection_permission`
  ADD CONSTRAINT `guacamole_connection_permission_entity` FOREIGN KEY (`entity_id`) REFERENCES `guacamole_entity` (`entity_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `guacamole_connection_permission_ibfk_1` FOREIGN KEY (`connection_id`) REFERENCES `guacamole_connection` (`connection_id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `guacamole_sharing_profile`
--
ALTER TABLE `guacamole_sharing_profile`
  ADD CONSTRAINT `guacamole_sharing_profile_ibfk_1` FOREIGN KEY (`primary_connection_id`) REFERENCES `guacamole_connection` (`connection_id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `guacamole_sharing_profile_attribute`
--
ALTER TABLE `guacamole_sharing_profile_attribute`
  ADD CONSTRAINT `guacamole_sharing_profile_attribute_ibfk_1` FOREIGN KEY (`sharing_profile_id`) REFERENCES `guacamole_sharing_profile` (`sharing_profile_id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `guacamole_sharing_profile_parameter`
--
ALTER TABLE `guacamole_sharing_profile_parameter`
  ADD CONSTRAINT `guacamole_sharing_profile_parameter_ibfk_1` FOREIGN KEY (`sharing_profile_id`) REFERENCES `guacamole_sharing_profile` (`sharing_profile_id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `guacamole_sharing_profile_permission`
--
ALTER TABLE `guacamole_sharing_profile_permission`
  ADD CONSTRAINT `guacamole_sharing_profile_permission_entity` FOREIGN KEY (`entity_id`) REFERENCES `guacamole_entity` (`entity_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `guacamole_sharing_profile_permission_ibfk_1` FOREIGN KEY (`sharing_profile_id`) REFERENCES `guacamole_sharing_profile` (`sharing_profile_id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `guacamole_system_permission`
--
ALTER TABLE `guacamole_system_permission`
  ADD CONSTRAINT `guacamole_system_permission_entity` FOREIGN KEY (`entity_id`) REFERENCES `guacamole_entity` (`entity_id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `guacamole_user`
--
ALTER TABLE `guacamole_user`
  ADD CONSTRAINT `guacamole_user_entity` FOREIGN KEY (`entity_id`) REFERENCES `guacamole_entity` (`entity_id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `guacamole_user_attribute`
--
ALTER TABLE `guacamole_user_attribute`
  ADD CONSTRAINT `guacamole_user_attribute_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `guacamole_user` (`user_id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `guacamole_user_group`
--
ALTER TABLE `guacamole_user_group`
  ADD CONSTRAINT `guacamole_user_group_entity` FOREIGN KEY (`entity_id`) REFERENCES `guacamole_entity` (`entity_id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `guacamole_user_group_attribute`
--
ALTER TABLE `guacamole_user_group_attribute`
  ADD CONSTRAINT `guacamole_user_group_attribute_ibfk_1` FOREIGN KEY (`user_group_id`) REFERENCES `guacamole_user_group` (`user_group_id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `guacamole_user_group_member`
--
ALTER TABLE `guacamole_user_group_member`
  ADD CONSTRAINT `guacamole_user_group_member_entity_id` FOREIGN KEY (`member_entity_id`) REFERENCES `guacamole_entity` (`entity_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `guacamole_user_group_member_parent_id` FOREIGN KEY (`user_group_id`) REFERENCES `guacamole_user_group` (`user_group_id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `guacamole_user_group_permission`
--
ALTER TABLE `guacamole_user_group_permission`
  ADD CONSTRAINT `guacamole_user_group_permission_affected_user_group` FOREIGN KEY (`affected_user_group_id`) REFERENCES `guacamole_user_group` (`user_group_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `guacamole_user_group_permission_entity` FOREIGN KEY (`entity_id`) REFERENCES `guacamole_entity` (`entity_id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `guacamole_user_history`
--
ALTER TABLE `guacamole_user_history`
  ADD CONSTRAINT `guacamole_user_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `guacamole_user` (`user_id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `guacamole_user_password_history`
--
ALTER TABLE `guacamole_user_password_history`
  ADD CONSTRAINT `guacamole_user_password_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `guacamole_user` (`user_id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `guacamole_user_permission`
--
ALTER TABLE `guacamole_user_permission`
  ADD CONSTRAINT `guacamole_user_permission_entity` FOREIGN KEY (`entity_id`) REFERENCES `guacamole_entity` (`entity_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `guacamole_user_permission_ibfk_1` FOREIGN KEY (`affected_user_id`) REFERENCES `guacamole_user` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
