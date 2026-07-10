# QBCore Police Job Script

A complete and customizable police job script for QBCore framework with full duty system, arrests, salary, and uniforms.

## Features

✅ **Duty System**
- Join/Leave duty at police station
- Automatic uniform change on duty
- Automatic uniform removal on leaving duty
- Duty timer tracking

✅ **Arrest System**
- Tackle and arrest players
- Configurable charges and fines
- Automatic jail time based on charge
- Fine deduction from player bank account
- Arrest logging in database

✅ **Salary System**
- Base salary: $30,000 - $35,000
- Duty bonus: $10,000
- Auto-pay every 30 minutes
- Salary logging

✅ **Uniforms**
- Male and female uniform variations
- Body armor included
- Automatic weapon loadout on duty
- Customizable appearance

## Installation

1. Extract folder to `resources/[jobs]/police-job`
2. Add to server.cfg:
```
ensure police-job
```
3. Create database tables:
```sql
CREATE TABLE IF NOT EXISTS `police_arrests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `arrested_player` varchar(50) NOT NULL,
  `charged_by` varchar(50) NOT NULL,
  `charge` varchar(50) NOT NULL,
  `fine` int(11) NOT NULL,
  `jail_time` int(11) NOT NULL,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `police_salary` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` varchar(50) NOT NULL,
  `base_salary` int(11) NOT NULL,
  `bonus` int(11) NOT NULL,
  `total` int(11) NOT NULL,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

## Commands

- `/duty` - Toggle police duty on/off
- `/arrest [id] [charge]` - Arrest a player
- `/policemenu` - Open police menu
- `/policewardrobe` - Change into police uniform
- `/paysalary` - Admin command to pay all on-duty officers

## Configuration

Edit `config.lua` to customize:
- Duty location
- Jail location
- Salary amounts
- Uniform appearance
- Charges and fines
- Jail times
- Weapons on duty

## Customization

### Change Uniform
Edit `Config.Uniforms.duty` in config.lua with your desired clothing IDs.

### Change Charges
Edit `Config.ArrestFines` and `Config.JailTime` for new charges.

### Change Salary
Edit `Config.Salary` for different salary amounts.

## Dependencies
- qb-core
- mysql-async

## License
MIT License
