-- ========================================
-- Police Job Database Tables
-- ========================================

-- QBCore Player Jobs Table (if missing)
CREATE TABLE IF NOT EXISTS `player_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jobname` varchar(50) NOT NULL,
  `employees` longtext DEFAULT '[]',
  PRIMARY KEY (`id`),
  UNIQUE KEY `jobname` (`jobname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Police Arrests Table
CREATE TABLE IF NOT EXISTS `police_arrests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `arrested_player` varchar(50) NOT NULL,
  `charged_by` varchar(50) NOT NULL,
  `charge` varchar(50) NOT NULL,
  `fine` int(11) NOT NULL,
  `jail_time` int(11) NOT NULL,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `arrested_player` (`arrested_player`),
  KEY `charged_by` (`charged_by`),
  KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Police Salary Table
CREATE TABLE IF NOT EXISTS `police_salary` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` varchar(50) NOT NULL,
  `base_salary` int(11) NOT NULL,
  `bonus` int(11) NOT NULL,
  `total` int(11) NOT NULL,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `player_id` (`player_id`),
  KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================================
-- Instructions:
-- ========================================
-- 1. Open PhpMyAdmin or MySQL Workbench
-- 2. Select your QBCore database
-- 3. Open SQL tab and paste all queries above
-- 4. Click Execute
-- 5. Restart your FiveM server
-- ========================================
