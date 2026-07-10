-- Car Wash Payments Table
CREATE TABLE IF NOT EXISTS `carwash_payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` varchar(50) NOT NULL,
  `amount` int(11) NOT NULL,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `player_id` (`player_id`),
  KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Car Wash Stats Table
CREATE TABLE IF NOT EXISTS `carwash_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` varchar(50) NOT NULL,
  `cars_washed` int(11) DEFAULT 0,
  `total_earned` int(11) DEFAULT 0,
  `last_wash` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
