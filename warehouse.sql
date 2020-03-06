-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.3.15-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             10.2.0.5599
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for warehouse
DROP DATABASE IF EXISTS `warehouse`;
CREATE DATABASE IF NOT EXISTS `warehouse` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `warehouse`;

-- Dumping structure for table warehouse.department
DROP TABLE IF EXISTS `department`;
CREATE TABLE IF NOT EXISTS `department` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `department` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table warehouse.department: ~14 rows (approximately)
DELETE FROM `department`;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` (`id`, `department`, `created_at`, `updated_at`) VALUES
	(2, 'Engineering Maintenance', '2019-07-19 13:26:48', '2019-07-22 08:17:57'),
	(3, 'Information Technology', '2019-07-19 13:27:54', '2019-07-19 13:27:54'),
	(4, 'Logistic', '2019-07-19 13:31:57', '2019-07-19 13:31:57'),
	(5, 'HRPA', '2019-07-19 13:32:07', '2019-07-19 13:32:07'),
	(6, 'Finance & Accounting', '2019-07-19 13:32:31', '2019-07-19 13:32:31'),
	(7, 'General Affairs', '2019-07-19 13:32:46', '2019-07-19 13:32:46'),
	(8, 'Marketing', '2019-07-19 13:32:56', '2019-07-19 13:32:56'),
	(9, 'Purchasing', '2019-07-19 13:33:02', '2019-07-19 13:33:02'),
	(10, 'Distribution', '2019-07-19 13:33:09', '2019-07-19 13:33:09'),
	(11, 'Shipping & Receiving', '2019-07-19 13:33:19', '2019-07-19 13:33:19'),
	(12, 'Production', '2019-07-19 13:33:28', '2019-07-19 13:33:28'),
	(13, 'Technical', '2019-07-19 13:33:38', '2019-07-19 13:33:38'),
	(14, 'Safety & Environment', '2019-07-19 13:33:52', '2019-07-19 13:33:52'),
	(15, 'Quality Assurance', '2019-07-19 13:34:07', '2019-07-19 13:34:07');
/*!40000 ALTER TABLE `department` ENABLE KEYS */;

-- Dumping structure for table warehouse.detail_purchase_requisition
DROP TABLE IF EXISTS `detail_purchase_requisition`;
CREATE TABLE IF NOT EXISTS `detail_purchase_requisition` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_pr` int(11) DEFAULT NULL,
  `id_material` int(11) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `price` double(8,2) DEFAULT NULL,
  `remark` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_by` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table warehouse.detail_purchase_requisition: ~0 rows (approximately)
DELETE FROM `detail_purchase_requisition`;
/*!40000 ALTER TABLE `detail_purchase_requisition` DISABLE KEYS */;
/*!40000 ALTER TABLE `detail_purchase_requisition` ENABLE KEYS */;

-- Dumping structure for function warehouse.doc_get_first_approval
DROP FUNCTION IF EXISTS `doc_get_first_approval`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `doc_get_first_approval`(
        `in_email` VARCHAR(250),
        `in_step_number` INTEGER
    ) RETURNS varchar(250) CHARSET latin1
BEGIN
Declare approval varchar(255);
select `wfd`.author from work_flow_detail wfd
left join work_flow wf
on wfd.`id_work_flow` = wf.id
left join department d
on wf.name = d.`id`
left join users u
on d.id = u.`id_department`
where u.email = in_email
and wfd.step_number = in_step_number into approval;
  RETURN(approval) ;
END//
DELIMITER ;

-- Dumping structure for procedure warehouse.doc_update_document_approval
DROP PROCEDURE IF EXISTS `doc_update_document_approval`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `doc_update_document_approval`(
        IN `in_id_document` INTEGER,
        IN `in_id_user` INTEGER,
        IN `in_status` VARCHAR(255),
        IN `in_date_action` DATETIME
    )
BEGIN
declare checking INT(11);

select count(*) from 
`document_approval` 
where id_document = in_id_document
and id_user = in_id_user into checking;

if checking < 1 THEN
insert into document_approval(id_document,id_user,status,date_action)
values(in_id_document,in_id_user,in_status,in_date_action);
else
update document_approval set date_action = in_date_action 
where id_document = in_id_document 
and id_user = in_id_user;
end if;
END//
DELIMITER ;

-- Dumping structure for procedure warehouse.doc_update_next_approval
DROP PROCEDURE IF EXISTS `doc_update_next_approval`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `doc_update_next_approval`(
        IN `in_department` VARCHAR(255),
        IN `in_step_number` INTEGER,
        IN `in_doc_number` VARCHAR(255)
    )
BEGIN
declare author varchar(255);
declare status varchar(255);
declare total_approval int(11);
declare id_approval  int(11);

select wfd.author from work_flow_detail wfd
left join `work_flow` wf
on wf.`id` = wfd.`id_work_flow`
left join `department` d
on `wf`.name = d.id
where d.department = in_department
and wfd.`step_number` = in_step_number + 1 into author;

select wfd.`status` from work_flow_detail wfd
left join `work_flow` wf
on wf.`id` = wfd.`id_work_flow`
left join `department` d
on `wf`.name = d.id
where d.department = in_department
and wfd.`step_number` = in_step_number + 1 into status;

select count(*) from work_flow_detail wfd
left join work_flow wf
on wfd.`id_work_flow`= wf.id
left join department d
on wf.name = d.`id`
where d.department = in_department into total_approval;

IF in_step_number >= total_approval THEN
set status = 'Completed' ;
End if;

select id from users where 
email = author into id_approval;
UPDATE documents
set doc_current_author = id_approval, 
doc_status_number = doc_status_number + 1,
doc_status = status,
updated_at = now()
where doc_number = in_doc_number;
END//
DELIMITER ;

-- Dumping structure for function warehouse.generate_doc
DROP FUNCTION IF EXISTS `generate_doc`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `generate_doc`() RETURNS varchar(255) CHARSET latin1
BEGIN
declare run_number int;
declare code_apps varchar(20);
declare code_years varchar(20);
declare doc_number varchar(255);
select count(*) from `documents` into run_number;
set code_apps = 'DGS';
select YEAR(now()) into code_years;
set doc_number =  concat(run_number,'-',code_apps,'-',code_years);
  RETURN (doc_number) ;
END//
DELIMITER ;

-- Dumping structure for table warehouse.material
DROP TABLE IF EXISTS `material`;
CREATE TABLE IF NOT EXISTS `material` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `item_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `spec` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unit` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remark` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_by` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table warehouse.material: ~1 rows (approximately)
DELETE FROM `material`;
/*!40000 ALTER TABLE `material` DISABLE KEYS */;
INSERT INTO `material` (`id`, `item_code`, `name`, `spec`, `unit`, `remark`, `created_by`, `updated_by`, `created_at`, `updated_at`, `deleted_at`) VALUES
	(1, 'JKDKDK', 'TESTING', 'KDJLDGjl 944i4i', 'UNIT', 'testing', 'galih', 'galih', '2019-12-27 00:00:00', '2019-12-27 14:07:00', NULL);
/*!40000 ALTER TABLE `material` ENABLE KEYS */;

-- Dumping structure for table warehouse.migrations
DROP TABLE IF EXISTS `migrations`;
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table warehouse.migrations: ~25 rows (approximately)
DELETE FROM `migrations`;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
	(1, '2014_10_12_000000_create_users_table', 1),
	(2, '2014_10_12_100000_create_password_resets_table', 1),
	(3, '2019_06_21_035627_create_permission_tables', 2),
	(4, '2016_06_01_000001_create_oauth_auth_codes_table', 3),
	(5, '2016_06_01_000002_create_oauth_access_tokens_table', 3),
	(6, '2016_06_01_000003_create_oauth_refresh_tokens_table', 3),
	(7, '2016_06_01_000004_create_oauth_clients_table', 3),
	(8, '2016_06_01_000005_create_oauth_personal_access_clients_table', 3),
	(9, '2019_06_24_055317_create_products_table', 4),
	(10, '2019_07_16_142936_create_sessions_table', 5),
	(11, '2019_07_19_090249_create_department_table', 6),
	(12, '2019_07_19_090346_create_section_table', 6),
	(13, '2019_07_22_082125_create_section_table', 7),
	(14, '2019_07_23_142811_create_province_table', 8),
	(15, '2019_07_25_091532_create_documents_table', 9),
	(16, '2019_07_25_111345_create_flow_document_table', 10),
	(17, '2019_07_25_111418_create_button_type_table', 10),
	(18, '2019_07_30_104406_create_work_flow_table', 11),
	(19, '2019_07_30_105038_create_work_flow_detail_table', 12),
	(20, '2019_08_09_101041_create_history_document', 13),
	(21, '2019_08_22_094706_create_document_approval_table', 14),
	(22, '2019_12_24_093841_create_purchase_requisition_table', 15),
	(23, '2019_12_24_100726_create_detail_purchase_requisition_table', 16),
	(24, '2019_12_24_145037_create_material_table', 17),
	(25, '2020_03_03_142647_create_unit_table', 18);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;

-- Dumping structure for table warehouse.model_has_permissions
DROP TABLE IF EXISTS `model_has_permissions`;
CREATE TABLE IF NOT EXISTS `model_has_permissions` (
  `permission_id` int(10) unsigned NOT NULL,
  `model_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`model_id`,`model_type`) USING BTREE,
  KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`) USING BTREE,
  CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table warehouse.model_has_permissions: ~0 rows (approximately)
DELETE FROM `model_has_permissions`;
/*!40000 ALTER TABLE `model_has_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `model_has_permissions` ENABLE KEYS */;

-- Dumping structure for table warehouse.model_has_roles
DROP TABLE IF EXISTS `model_has_roles`;
CREATE TABLE IF NOT EXISTS `model_has_roles` (
  `role_id` int(10) unsigned NOT NULL,
  `model_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`model_id`,`model_type`) USING BTREE,
  KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`) USING BTREE,
  CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table warehouse.model_has_roles: ~5 rows (approximately)
DELETE FROM `model_has_roles`;
/*!40000 ALTER TABLE `model_has_roles` DISABLE KEYS */;
INSERT INTO `model_has_roles` (`role_id`, `model_type`, `model_id`) VALUES
	(4, 'App\\User', 40),
	(5, 'App\\User', 29),
	(5, 'App\\User', 37),
	(9, 'App\\User', 38),
	(9, 'App\\User', 39);
/*!40000 ALTER TABLE `model_has_roles` ENABLE KEYS */;

-- Dumping structure for table warehouse.oauth_access_tokens
DROP TABLE IF EXISTS `oauth_access_tokens`;
CREATE TABLE IF NOT EXISTS `oauth_access_tokens` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `client_id` int(10) unsigned NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scopes` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `oauth_access_tokens_user_id_index` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table warehouse.oauth_access_tokens: ~0 rows (approximately)
DELETE FROM `oauth_access_tokens`;
/*!40000 ALTER TABLE `oauth_access_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauth_access_tokens` ENABLE KEYS */;

-- Dumping structure for table warehouse.oauth_auth_codes
DROP TABLE IF EXISTS `oauth_auth_codes`;
CREATE TABLE IF NOT EXISTS `oauth_auth_codes` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(11) NOT NULL,
  `client_id` int(10) unsigned NOT NULL,
  `scopes` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table warehouse.oauth_auth_codes: ~0 rows (approximately)
DELETE FROM `oauth_auth_codes`;
/*!40000 ALTER TABLE `oauth_auth_codes` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauth_auth_codes` ENABLE KEYS */;

-- Dumping structure for table warehouse.oauth_clients
DROP TABLE IF EXISTS `oauth_clients`;
CREATE TABLE IF NOT EXISTS `oauth_clients` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `secret` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `redirect` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `personal_access_client` tinyint(1) NOT NULL,
  `password_client` tinyint(1) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `oauth_clients_user_id_index` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table warehouse.oauth_clients: ~2 rows (approximately)
DELETE FROM `oauth_clients`;
/*!40000 ALTER TABLE `oauth_clients` DISABLE KEYS */;
INSERT INTO `oauth_clients` (`id`, `user_id`, `name`, `secret`, `redirect`, `personal_access_client`, `password_client`, `revoked`, `created_at`, `updated_at`) VALUES
	(1, NULL, 'Laravel Personal Access Client', 'ev8BexYTS0ZxIq1GYLKmYsc8ctvHUgmKS0pU02En', 'http://localhost', 1, 0, 0, '2019-06-21 04:09:07', '2019-06-21 04:09:07'),
	(2, NULL, 'Laravel Password Grant Client', 'li6jrBQ5Jw7NZth78YmYLCAbWmWfV07ZQAjY1EAG', 'http://localhost', 0, 1, 0, '2019-06-21 04:09:07', '2019-06-21 04:09:07');
/*!40000 ALTER TABLE `oauth_clients` ENABLE KEYS */;

-- Dumping structure for table warehouse.oauth_personal_access_clients
DROP TABLE IF EXISTS `oauth_personal_access_clients`;
CREATE TABLE IF NOT EXISTS `oauth_personal_access_clients` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `oauth_personal_access_clients_client_id_index` (`client_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table warehouse.oauth_personal_access_clients: ~1 rows (approximately)
DELETE FROM `oauth_personal_access_clients`;
/*!40000 ALTER TABLE `oauth_personal_access_clients` DISABLE KEYS */;
INSERT INTO `oauth_personal_access_clients` (`id`, `client_id`, `created_at`, `updated_at`) VALUES
	(1, 1, '2019-06-21 04:09:07', '2019-06-21 04:09:07');
/*!40000 ALTER TABLE `oauth_personal_access_clients` ENABLE KEYS */;

-- Dumping structure for table warehouse.oauth_refresh_tokens
DROP TABLE IF EXISTS `oauth_refresh_tokens`;
CREATE TABLE IF NOT EXISTS `oauth_refresh_tokens` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `access_token_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `oauth_refresh_tokens_access_token_id_index` (`access_token_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table warehouse.oauth_refresh_tokens: ~0 rows (approximately)
DELETE FROM `oauth_refresh_tokens`;
/*!40000 ALTER TABLE `oauth_refresh_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauth_refresh_tokens` ENABLE KEYS */;

-- Dumping structure for table warehouse.password_resets
DROP TABLE IF EXISTS `password_resets`;
CREATE TABLE IF NOT EXISTS `password_resets` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table warehouse.password_resets: ~2 rows (approximately)
DELETE FROM `password_resets`;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
INSERT INTO `password_resets` (`email`, `token`, `created_at`) VALUES
	('galihprasetio89@gmail.com', '$2y$10$btV1y04yeZ7KwtOJHGgNGOAcfYe5OfH1nPups..lOoxJSBr6EJwtq', '2019-07-02 08:39:04'),
	('approvalsupervisor@gmail.com', '$2y$10$Veu1ErS7bS0A3ipx1hFmAesv8/qj4NiW5xqYz4XhaOP.cx2tEQF.K', '2019-08-15 08:44:30');
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;

-- Dumping structure for table warehouse.permissions
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE IF NOT EXISTS `permissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table warehouse.permissions: ~20 rows (approximately)
DELETE FROM `permissions`;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
	(1, 'role-list', 'web', '2019-06-21 04:00:29', '2019-06-21 04:00:29'),
	(2, 'role-create', 'web', '2019-06-21 04:00:29', '2019-06-21 04:00:29'),
	(3, 'role-edit', 'web', '2019-06-21 04:00:29', '2019-06-21 04:00:29'),
	(4, 'role-delete', 'web', '2019-06-21 04:00:29', '2019-06-21 04:00:29'),
	(69, 'department-list', 'web', '2019-07-19 09:18:40', '2019-07-19 09:18:40'),
	(70, 'department-create', 'web', '2019-07-19 09:18:40', '2019-07-19 09:18:40'),
	(71, 'department-edit', 'web', '2019-07-19 09:18:40', '2019-07-19 09:18:40'),
	(72, 'document-list', 'web', '2019-08-29 08:29:18', '2019-08-29 08:29:18'),
	(73, 'document-create', 'web', '2019-08-29 08:29:18', '2019-08-29 08:29:18'),
	(74, 'document-edit', 'web', '2019-08-29 08:29:18', '2019-08-29 08:29:18'),
	(75, 'user-list', 'web', '2019-08-29 08:29:18', '2019-08-29 08:29:18'),
	(76, 'user-create', 'web', '2019-08-29 08:29:18', '2019-08-29 08:29:18'),
	(77, 'user-edit', 'web', '2019-08-29 08:29:18', '2019-08-29 08:29:18'),
	(78, 'section-list', 'web', '2019-08-29 08:29:18', '2019-08-29 08:29:18'),
	(79, 'section-edit', 'web', '2019-08-29 08:29:18', '2019-08-29 08:29:18'),
	(80, 'section-create', 'web', '2019-08-29 08:31:07', '2019-08-29 08:31:07'),
	(81, 'workflow-list', 'web', '2019-08-29 08:31:07', '2019-08-29 08:31:07'),
	(82, 'workflow-edit', 'web', '2019-08-29 08:31:07', '2019-08-29 08:31:07'),
	(83, 'workflow-create', 'web', '2019-08-29 08:31:07', '2019-08-29 08:31:07'),
	(84, 'user-profile', 'web', '2019-08-29 09:07:01', '2019-08-29 09:07:01');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;

-- Dumping structure for table warehouse.province
DROP TABLE IF EXISTS `province`;
CREATE TABLE IF NOT EXISTS `province` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `province` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table warehouse.province: ~34 rows (approximately)
DELETE FROM `province`;
/*!40000 ALTER TABLE `province` DISABLE KEYS */;
INSERT INTO `province` (`id`, `province`, `created_at`, `updated_at`) VALUES
	(64, 'Aceh\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(65, 'Bali\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(66, 'Banten\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(67, 'Bengkulu\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(68, 'Gorontalo\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(69, 'Jakarta\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(70, 'Jambi\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(71, 'Jawa Barat\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(72, 'Jawa Tengah\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(73, 'Jawa Timur\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(74, 'Kalimantan Barat\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(75, 'Kalimantan Selatan\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(76, 'Kalimantan Tengah\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(77, 'Kalimantan Timur\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(78, 'Kalimantan Utara\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(79, 'Kepulauan Bangka Belitung\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(80, 'Kepulauan Riau\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(81, 'Lampung\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(82, 'Maluku\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(83, 'Maluku Utara\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(84, 'Nusa Tenggara Barat\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(85, 'Nusa Tenggara Timur\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(86, 'Papua\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(87, 'Papua Barat\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(88, 'Riau\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(89, 'Sulawesi Barat\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(90, 'Sulawesi Selatan\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(91, 'Sulawesi Tengah\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(92, 'Sulawesi Tenggara\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(93, 'Sulawesi Utara\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(94, 'Sumatera Barat\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(95, 'Sumatera Selatan\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(96, 'Sumatera Utara\r', '2019-07-23 14:44:32', '2019-07-23 14:44:32'),
	(97, 'Yogyakarta', '2019-07-23 14:44:32', '2019-07-23 14:44:32');
/*!40000 ALTER TABLE `province` ENABLE KEYS */;

-- Dumping structure for table warehouse.purchase_requisition
DROP TABLE IF EXISTS `purchase_requisition`;
CREATE TABLE IF NOT EXISTS `purchase_requisition` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `pr_number` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `request_date` datetime DEFAULT NULL,
  `requestor` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `department` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tittle` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currency` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_ammount` double(8,2) DEFAULT NULL,
  `purpose` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_by` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table warehouse.purchase_requisition: ~0 rows (approximately)
DELETE FROM `purchase_requisition`;
/*!40000 ALTER TABLE `purchase_requisition` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_requisition` ENABLE KEYS */;

-- Dumping structure for table warehouse.roles
DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table warehouse.roles: ~3 rows (approximately)
DELETE FROM `roles`;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
	(4, 'Operator', 'web', '2019-07-12 10:52:01', '2019-07-22 07:20:02'),
	(5, 'administrator', 'web', '2019-07-19 08:05:44', '2019-07-19 08:05:44'),
	(9, 'user', 'web', '2019-08-29 08:31:54', '2019-08-29 08:31:54');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;

-- Dumping structure for table warehouse.role_has_permissions
DROP TABLE IF EXISTS `role_has_permissions`;
CREATE TABLE IF NOT EXISTS `role_has_permissions` (
  `permission_id` int(10) unsigned NOT NULL,
  `role_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`role_id`) USING BTREE,
  KEY `role_has_permissions_role_id_foreign` (`role_id`) USING BTREE,
  CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table warehouse.role_has_permissions: ~25 rows (approximately)
DELETE FROM `role_has_permissions`;
/*!40000 ALTER TABLE `role_has_permissions` DISABLE KEYS */;
INSERT INTO `role_has_permissions` (`permission_id`, `role_id`) VALUES
	(1, 5),
	(2, 5),
	(3, 5),
	(4, 5),
	(69, 5),
	(70, 5),
	(71, 5),
	(72, 5),
	(72, 9),
	(73, 5),
	(73, 9),
	(74, 5),
	(74, 9),
	(75, 5),
	(75, 9),
	(76, 5),
	(77, 5),
	(78, 5),
	(79, 5),
	(80, 5),
	(81, 5),
	(82, 5),
	(83, 5),
	(84, 5),
	(84, 9);
/*!40000 ALTER TABLE `role_has_permissions` ENABLE KEYS */;

-- Dumping structure for table warehouse.section
DROP TABLE IF EXISTS `section`;
CREATE TABLE IF NOT EXISTS `section` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_department` int(11) DEFAULT NULL,
  `section` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table warehouse.section: ~5 rows (approximately)
DELETE FROM `section`;
/*!40000 ALTER TABLE `section` DISABLE KEYS */;
INSERT INTO `section` (`id`, `id_department`, `section`, `created_at`, `updated_at`) VALUES
	(9, 3, 'Staff IT Infrasturcture', '2019-07-22 19:51:29', '2019-07-22 19:51:29'),
	(10, 3, 'Software Development', '2019-07-22 19:51:46', '2019-08-22 14:32:24'),
	(11, 2, 'Staff Engineering Mechanical', '2019-07-22 19:52:08', '2019-07-22 19:52:08'),
	(12, 2, 'Staff Engineering Electrical', '2019-07-22 19:52:26', '2019-07-23 13:00:31'),
	(13, 3, 'Head Department Information Technology', '2019-08-19 15:46:53', '2019-08-19 15:46:53');
/*!40000 ALTER TABLE `section` ENABLE KEYS */;

-- Dumping structure for table warehouse.sessions
DROP TABLE IF EXISTS `sessions`;
CREATE TABLE IF NOT EXISTS `sessions` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payload` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int(11) NOT NULL,
  UNIQUE KEY `sessions_id_unique` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table warehouse.sessions: ~0 rows (approximately)
DELETE FROM `sessions`;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;

-- Dumping structure for table warehouse.unit
DROP TABLE IF EXISTS `unit`;
CREATE TABLE IF NOT EXISTS `unit` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `unit` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table warehouse.unit: ~0 rows (approximately)
DELETE FROM `unit`;
/*!40000 ALTER TABLE `unit` DISABLE KEYS */;
/*!40000 ALTER TABLE `unit` ENABLE KEYS */;

-- Dumping structure for table warehouse.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_department` int(11) DEFAULT NULL,
  `id_section` int(11) DEFAULT NULL,
  `tittle` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `position` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dateofbirth` date DEFAULT NULL,
  `office_phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cell_phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `job_description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sign` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `users_email_unique` (`email`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table warehouse.users: ~4 rows (approximately)
DELETE FROM `users`;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `id_department`, `id_section`, `tittle`, `position`, `dateofbirth`, `office_phone`, `cell_phone`, `region`, `job_description`, `image`, `sign`, `remember_token`, `created_at`, `updated_at`, `deleted_at`) VALUES
	(37, 'Galih Prasetio', 'galihprasetio89@gmail.com', NULL, '$2y$10$e1t5SSIOYtGsE8lFbQvveuZ/ZP1yTmOjYLvYNH/QpTbjYrKC5U6P.', 3, 10, 'Senior IT', 'IT Development', '2019-08-14', '085722427525', '85722427525', 'Jawa Barat', 'sdgsdgsdg', '1577087756.PNG', 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAASwAAACWCAYAAABkW7XSAAARVUlEQVR4Xu1dS+hvNxGeer3V+qC0UETxLaLgogsVdOFSVyroSnDhUqog7lQEQVRc24ri3p2IIHbjVkRQkLvwsVBRrLqyvoq1vmUuZ2T+ITmZ5CQ5yZzvt+m/9+QkM99MvjMzycm5h/ADAkAACCyCwD2LyAkxgQAQAAIEwoITAAEgsAwCIKxlTAVBgQAQAGHBB4AAEFgGARDWMqaCoEAACICw4ANAAAgsgwAIaxlTQVAgAARAWPABIAAElkEAhLWMqSAoEAACICz4ABAAAssgAMJaxlQQFAgAARAWfAAIAIFlEABhLWMqCAoEgAAICz4ABIDAMgiAsJYxFQQFAkAAhAUfAAJAYBkEQFjLmAqCAgEgAMKCDwABILAMAiCsZUwFQYEAEABhwQeAABBYBgEQ1jKmgqCTIfAwEd0hov8S0bMmk82tOCAst6aFYh0R+BcR3VL9Yx51BFt3DaAHAY1h3CDwH6K7H2/hyErmD+bRIPMC6EFAYxgXCGiy4jSQSYt/I+YRj82/S6efI4B24alQ4vIICDlxOnh7Q2MkYY0ca1pjg7CmNQ0EmwiBf2+RzT+J6F4l10gSGTnWRNDfFAWENa1pINhECDBZxFYDR5LIyLEmgh6ENa0xINiUCEjdKvZwH0kiI8ea0hCjioXTKg/BgEAGgb9vKSCTlt7GILeNJJGRY03rGEgJx5pGntaWUWEbC0p92+RIIne9pXQjx2opd9O+MCmawhntTAq2+qnMxdvc7zm5BrjeFQF5uPyeiB5KjJSqbfUQDIQ1aP9ID+Ot0GcYTTFxPXsFwSHjXQRyZPSPbXvDiIf+x4no85tdRow3rQtcWvkOVolFU5fe6NcB4xFd7hXaZXxLm1ay6offpefspZVv5U1EhGiqIZgndyXvCeYi4lwE1lINEBbCy8P+hGjqMIRTdmAlIm6XI7VWCkr9ivu7dJBxaeUrvelpIrpP3TvKaSvFxW0FCFjTPHlYjZg/un4FwiowJpreTP1GOCswH4fAF4joI8bzrazE1kL6sNxwab+7tPKF3hS+qV94O5pPjkDJtgFum9pM2lpNnQ4iwmqNrsP+9GFt+k19h6peVqVHiOhLRhIamQ6yQaSmhrO3rl7AM0xPRFUGkBw0KUnxSiKxo9DovV4jxz0qd7f7kRKmoRUHib2l380g6PgUBKwrgxLxjEoHNZGCsBBhRSeH3q7wFyK6/5QphEFHIVASXZ2VDo4+3XQU9sXjIMK6CRlSwGIXWv6G0uhqZOFb7/VChIUI68ZkE4cYFe4vP9MdKFAaMY1cHQxlA2GBsO5OuSeJ6MFt8iHidMBCBSqURFel5FYgRrRpSFAgLBAW8TEvcoICyOroFFvrfrE9H9L3XIPoowkjJNPR4xsgGd/kypNUnphYBRzvdzOMWEIAUtvkbQYjzimLHV1TIu8M+HaR4aqEheJ6F3daptOSjaKylWHkgy22cgnCumhKCLJahle6CVqyleEMoojV1kpk7gbc2R1fLcISo2Ml8GzPO3d8a7F9dCooqMSOrgFhXSzCkicljoM5lyzOHr1k4luJraVOqdXIErlbyjNVX1eJsISsngnOsprKGBBmCAJWEjojFZR6Gf83nJsgrItEWGLoXxPRK4ZMCQwyKwLWvVRnpYJCWLGSBQjrAoQlRsaxMLNSyFi5SqKrkauCgsIeoVrJdiyig0fznBKiwD7YmSYfzrpR9KxUcC8d5GsgLMcRlvdNoTNuzXiKiJ63+ZR+EP6GiF7WmMyEVBp3e0p3Gqu9dxXlIEnPQUbWAB6VlyfpGSF9FvCDDfSrRNLV2TYMvx6kVUzZwJqaxeCSJf9bCSyl7z8Q0Q9Vm3dsp3c+nrjvndu/fyu4zrvOcz9+vSf88QLP+4noXnXhs9vf/CET/v2ViB7d/s5FUGL7s+2dw6LrdW/Kf5uI3m78kEBXYDt0rj9GwHY7M3Vh9XhCymsqMQKK+VYYGZX6n9zPE/75RPQ7hfOLItFdaAaRkxdgXqUu9sAy/HgED7enb04GwbsUsw6ueF6X3pTPGf08pOtH1lGVXj06U9fYZBQNU1GVXnmTqKPE/0Rf66bfTxDRZ4hIvrydG0v3Ly/E11jt+0T05u1GwcJiq710kLv7HhG9xXEZx4R1zoimTiZp5HHZN4yqNNSWSdDaNDGikhTtdmYwHYWVyM6nvr4wIIBSvWK+8Sd1mizLk5oLJUSm8fk5Eb1Wyb0XYeXSQf0w+AYRvbcUAC/tPRHWkbrIbPbUjp+KKEom/RH9fktELw4mdEl98GEiurMJIP5mlT2sj9X6a8w39mR4jIg+lEkx5f4/E9EDKkWPYZPTN3ddE9alNz/XOsCRCdDj3h8Q0ZuISGobPcYY0acmqj1SkBWjnvvLwmhKRyFWv9GfSPsJEb3BGHFwM70SyuMdsa1EgZLqWQkitPkviejlBiLj/pn0PmrUN5cOasLqafMRPn5oDKvjHRpkwM2rp4NWotKOWxLlWE2QWvGTlbKS2tPe1oscYch1lodXA611q5ie4epabmwrViGpyn17c4pXBV8QDGBNB/m2kHhLZHXRFoR1rhlLiUpPkla24yc2F6Zj/QlRhNspcmPn9ontkYa+1iLN1w+zVmSlI8fUy/SvJKJfGKIxwTKHqRDWEfI+19sbjG4BqcEw3bto5YjdBd0GqCGqVtEVTzC2e2h7lklW1HT0Vrs8v5e6pOwVkhXrfNRHhfRKiGHPD3JkHLtX68XkL3vIUls/uP3XiOh9QWfW1HGUHw8f56gzDBc4MeAqhHWEqGqiq7+pvVKhrWUi8+SJnW0f206Rwzl3XZNuSEb63k8T0acOpoLhWK3IT+yQ2riaIyx9XXT+VaY2FhK5PFhmmX/D5ABhjYH6KFGxlLIMv5cSpKInSSf4erj9IPYaU2o7hTWVy6Eapnphv61qklyov28T5oiv8072kvpdqH8stZU+Uynlq4noZ4aUkvv+KhF9IAe6h+tHjDiT/lJTGPWRAIvuPFn4ayx6Kf/IkzGc1NJ/LHLQ0VNJepPapLoXGQkZlkQwungcI8GWtasSuWJY6YWI2vkSS+Ws0WgYkcl9e3pJGyb+1221NIvPTt+m1gAzKlbjAD30CAvULYqkQsipyEMIILd5U+srfYl8e5tUQ8KKfdXF6kt61S5msxbRVbglwipb6A819apUSsh6S5SWi65Sfpki8s8R0ceMu/oFcyHREp/pMV+K+qw1ZNEggxrLpLZ+Z661WOGWgFZHMce2GrCz1UZrmlAZM65zyU5yC7nqJ7w1kosRpfxbqrZWo59eveO/ed9VLVatyErISetZ+3CtiTy/Q0RvNZDZElywhJAFzKKfHjUOXzDU/5uGhNIiLY2RlIVMcvKHUVSLdCc3Zipq4X8PsSrZk2SJhnTqWSKnTqlKiut7KaXMtdroSlLvWgJO6f9FIvrwdnF6PphewBIv29q2KHBbhg3H4QIp1wtqf7HtA7LVoIWThpOwVQRRqu/eQ6UmgpCJLP+VB1XNcSy6SK9TuFIdYxGlrmXy9Zq51yJdTukSq7Md0bvLvTWgdRGkQ6chAbBB2AmPfLmXn46c87copPOrKq+PvKPHcssrJK0cVD/VGQfpv1XaWmK+VDpkPRFUj6UjRH5J+n51sRQ7Sw2vRE9pq+U4El1xf70O8ePDF3kH/hn+UISpZ8ISIGJL/aURS5ii1aZn/GoGL7OH9YzYdgPLNgarscMidO0T3jpert2P1XuFsYmdu5+v5yLEEsLK9WWRxxK51NaudN/cR8v3CXsR9RHMkvdegbBC5WOplwVccRR9gqTlPq7TcEQTkhQ73V5fLZxb5NOF8lqyteh6pI01HXyCiF66DbSniwW/sEjfesVM1+Qs8ljws+Jk6Su2Ydhy32ltrkhYAnbsWNuUIUrTyNj7eexovCLHJ2XmfkKqfySiB3ONjddZ31I9jF0fbvZNInqX4USGkkWCHEH0jKrCqFH+v8V8a0VYS0VWLQE87K0OOvgyEX0wUkhl5/ouEb2tQEdxpFkjoQJVzE0t6VspwewR1qjVZB3ZtiArBtSC1R7wfLDgawwRqtl4Ixu2AnGkzLOMtfcSce1SuKQopTW2WTCplSM3CWu2GcQIa69IXyv73n25KK9mzCOF95IItUa27veAsOwQx2pRfDc7JV/j13CO/lqF+0flGH1/akld11g4nebPiFl/IVmURmjWcc5oV1N4d6E/CCvtbvwBg08m0jy99aCVw/Z4GreSrWc/qc2iRyeYTvvEz72k2SUPNp0CTr9tIedoIKybCPVI83I24Ou5lMjSx6ptYrofJSuJfAUTbym2lbCWTwFDp746YY1I83JEIpOz1c7q3HizXdeFaS3b8tFAR6AtD7gWpN9Rhbqur0ZYvJLHK3qxF257pHk5q8gT0EuqktM3dT3cYjLr9ota/Vrft1d4zx0R1FqWof1dgbDOSvNyhpTXNLylKzm9cb0NArHC+5J7q0rg8EhYM6R5FhtctchuwQZt8gjoOpbrqEpD4YWwfrqdlBC+/nJGmpdzNf06iBf8czrjensEYqug7v1pdQXDl5JnT690IZRfbm712k376YAeV0CgZkPtCnolZVyRsMITD9hosdMOZjKMJtarF9hnsgtkWQyBlQhrtWiKXUGOiOG/Z4/+FnNdiHtFBGYnrNiBebljWWaxo16xeUZ9bmoW+SAHEFgOgVkJKzyzaqXoRBfVV5J7OeeFwNdDYCbCkk946+OHOcKSD2GuYB2Xu4tXAB4yXgOBGQgrjKZWLEqjqH6N+QItT0bgLMLSaZMUpJ8koodOxqN0eBTVSxFDeyBwAIHRhOUhmhK4UVQ/4Hi4FQjUIDCCsFbcjrCHpSYqFNVrvA73AIFKBHoSVhhNrX5cCIiq0slwGxBohUBrwoqt9I36ZHwrTMJ+QFS9kEW/QKAQgVaE1epDo4Xid20OouoKLzoHAuUIHCGsrxPRe4LPtvOO7pIPBZRL3P8OEFV/jDECEKhCoIawYlsSVk/7GDwQVZUL4SYgMA6BEsLyVkQXlEFU4/wNIwGBQwjkCOvp7Xt7+nWZrxDRI4dGPf/m8FPy2J5wvk0gARDIIpAiLI9F9JCkGBwQVdZF0AAIzINAjLD00auzH4yXQxIklUMI14HAQgikCGvFF5AFdpDUQg4IUYFACQIhYVk+0FjS/6i2IKlRSGMcIHAiArEPiq5S1wFJneg4GBoInIGAJiwptOdWDs+Qk8cMj0sWOVYh2LNww7hAwA0C4Xf8Zpr8ewTFct5yYwUoAgSAgAkBISz+dBa/UsNp1m3Tne0bgaDaY4oegYArBISwzii2g6BcuRKUAQL9EdA72Humg09tERyPlyr0I8Xrb2+MAASWRoDJo3V0tUdODBYTI2pQS7sNhAcC5yDAhCUEUnriwhNE9JItYkqtLIKczrErRgUCLhEQwuKvvzyQ0NBCTDpyepyI3u0SLSgFBIDAqQgIYZUIIVHTHSJ6Y8mNaAsEgAAQOIIAExav1u39fgRiOgIx7gUCQKAVArPuam+lH/oBAkDAEQIgLEfGhCpAwDsCICzvFoZ+QMARAiAsR8aEKkDAOwIgLO8Whn5AwBECICxHxoQqQMA7AiAs7xaGfkDAEQIgLEfGhCpAwDsCICzvFoZ+QMARAiAsR8aEKkDAOwIgLO8Whn5AwBECICxHxoQqQMA7AiAs7xaGfkDAEQIgLEfGhCpAwDsCICzvFoZ+QMARAiAsR8aEKkDAOwIgLO8Whn5AwBECICxHxoQqQMA7AiAs7xaGfkDAEQIgLEfGhCpAwDsCICzvFoZ+QMARAiAsR8aEKkDAOwIgLO8Whn5AwBECICxHxoQqQMA7AiAs7xaGfkDAEQIgLEfGhCpAwDsCICzvFoZ+QMARAiAsR8aEKkDAOwIgLO8Whn5AwBECICxHxoQqQMA7AiAs7xaGfkDAEQL/AygfpsRQ9ZFTAAAAAElFTkSuQmCC', 'wHu9Op7huiEZI6SQymdBdPHySrBTzq1KoDIlnfFxGszQkBO0RG8TTgNJ9pZj', '2019-08-12 10:16:28', '2019-12-23 15:12:05', NULL),
	(38, 'Supervisor', 'approvalsupervisor@gmail.com', NULL, '$2y$10$NDluwDEjNN8USVcWRuMk3ehDPPiwm6c0pVgbMnwJGx.AvNFdG4IZK', 3, 9, 'Supervisor Information Technology', 'Supervisor Information Technology', '2019-08-14', '085722427525', '85722427525', 'placeholder', 'Testing', '1577088991.PNG', 'data:image/png;base64,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', NULL, '2019-08-13 08:46:25', '2019-12-23 15:16:31', NULL),
	(39, 'Head Department', 'approvalheaddepartment@gmail.com', NULL, '$2y$10$OHQmt1XbzTiEFLazJoTvEO3Uy314ImIhHFKWrrsawSmORD7PTAQu6', 3, 9, 'Head Department Information Technology', 'Head Department Information Technology', '2019-08-13', '085722427525', '85722427525', 'Jawa Barat', 'dsgsdgsdgsd', '1577088971.png', 'data:image/png;base64,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', NULL, '2019-08-13 08:47:42', '2019-12-23 15:16:11', NULL),
	(40, 'sgsdgsdg', 'galihprasetio@gmail.com', NULL, '$2y$10$ZICuALzVKSjIizaYS3Qvtud4k0HfzOpx6y1RnSHTfZ8/tWUXcKVaK', 3, NULL, 'sdgsdg', 'sdgsdg', '2019-12-27', '085722427525', '085722427525', 'Kalimantan Barat', 'sdgdsgdg', '1577430271.jpg', 'data:image/png;base64,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', NULL, '2019-12-27 14:04:31', '2019-12-27 14:04:31', NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
