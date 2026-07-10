# Complete Car Wash System

A fully functional car wash system with NPC workers, realistic car cleaning, payment system, and effects.

## Features

✅ **Car Wash Locations**
- Multiple car wash locations (Downtown, Airport, Pillbox)
- Location markers and blips
- Interactive E key prompt

✅ **NPC Workers**
- NPC worker at each location
- Greeting system
- Professional appearance

✅ **Car Cleaning**
- Full vehicle cleaning animation
- Window cleaning
- Deformation fixing
- Dirt removal
- 30-second wash duration

✅ **Payment System**
- $50 per wash
- Money removed from player cash
- Payment logging in database
- Balance check before wash

✅ **Sound Effects**
- Motor sound during wash
- Realistic audio feedback
- Notification system

✅ **Water Effects**
- Water spray particle effects
- Visual water animation
- Shine effect after wash
- Realistic cleaning visuals

## Installation

1. Extract to `resources/[standalone]/carwash`
2. Add to server.cfg:
```
ensure carwash
```
3. Run SQL queries from `sql/carwash.sql`
4. Restart server

## Locations

- **Downtown Car Wash** - 25.45, -1391.69, 29.5
- **Airport Car Wash** - -1200.5, -1564.2, 4.6
- **Pillbox Car Wash** - 158.42, -1754.33, 26.7

## Commands

- Drive to car wash location
- Press **E** to start wash
- Wait 30 seconds for cleaning
- Pay $50
- Car is clean!

## Configuration

Edit `config.lua` to customize:
- Car wash locations
- Wash price
- Wash duration
- NPC models
- Animations
- Effects

## Dependencies

- qb-core
- mysql-async

## Database Tables

- `carwash_payments` - Payment history
- `carwash_stats` - Player wash statistics

## License

MIT License
