# Nasflix 🎬

Jednoduchá CRUD aplikace pro sledování filmů, psaní recenzí a správu watchlistu, vytvořená v Ruby on Rails.

## Téma

**Nasflix** je filmová aplikace, která umožňuje:
- Spravovat databázi filmů (přidávat, upravovat, mazat)
- Nahrávat skutečné videosoubory k filmům (MP4, AVI, MKV)
- Autentizaci uživatelů s rolemi: `admin`, `parent`, `child`
- Plánovat "Movie Nights" a posílat pozvánky ostatním uživatelům
- Psát recenze a spravovat osobní watchlist

## Modely (Phase 2)

| Model | Popis | Asociace |
|-------|-------|----------|
| **User** | Uživatel s emailem, heslem (bcrypt) a rolí | `has_many :movie_nights, :invitations` |
| **Movie** | Film s názvem, popisem, žánrem, rokem a režisérem | `has_one_attached :video` |
| **MovieNight** | Událost k promítání filmu na konkrétní datum | `belongs_to :host, :movie` |
| **Invitation** | Pozvánka na Movie Night s možností přijmout/odmítnout | `belongs_to :user, :movie_night` |

## Verze

- **Ruby**: 4.0.1
- **Rails**: 8.1.2
- **MySQL**: 9.6.0

## Spuštění

```bash
# Instalace závislostí
bundle install

# Vytvoření a migrace databáze
rails db:create
rails db:migrate

# Naplnění vzorových dat
rails db:seed

# Spuštění serveru
rails server
```

Aplikace běží na [http://localhost:3000](http://localhost:3000).
