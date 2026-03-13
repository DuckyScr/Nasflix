# Nasflix 🎬

**Nasflix** is a self-hosted movie tracker and watch-party platform built with Ruby on Rails. 
*Téma aplikace:* Aplikace pro sledování filmů (Movie Tracker), správa vlastních seznamů filmů a plánování společného sledování ("Watch Party") s přáteli a rodinou.

## Tech Stack & Versions
- **Ruby:** 4.0.1
- **Ruby on Rails:** 8.1.2
- **Database:** MySQL

## Features (Assignment Checklist)

- **Modely & Asociace:** Obsahuje 6 modelů (`User`, `Movie`, `Review`, `WatchlistEntry`, `MovieNight`, `Invitation`) propojených smysluplnými asociacemi (např. `User has_many :watchlist_entries`, `MovieNight belongs_to :movie`).
- **Data (start_date, end_date):** Model `WatchlistEntry` eviduje `start_date` a `end_date` sledování daného filmu.
- **Validace:** Modely obsahují validace na povinná pole (např. jméno, email, název filmu) a vlastní validaci v `WatchlistEntry`, která hlídá, že `end_date` musí být po (nebo rovno) `start_date`.
- **Základní CRUD:** Kompletní rozhraní (index, show, new/create, edit/update, destroy) implementované pro filmy, watchlist záznamy i plánování společného sledování (movie nights).
- **Styling:** Design je vyřešen pomocí vlastního odděleného CSS souboru (`app/assets/stylesheets/application.css`). Bez použití externího UI frameworku, využity standardní `.html.erb` views.
- **Seed data:** Aplikace obsahuje připravený soubor `db/seeds.rb` pro prvotní naplnění databáze.

---

## 🐳 Docker Production Setup

The easiest way to get Nasflix running is via Docker Compose.

### Prerequisites
- Docker
- Docker Compose

### 1. Setup Environment Variables

Copy the example environment file and fill in your values:

```bash
cp .env.example .env
```

Generate a secure secret key for Rails:
```bash
rails secret
# Copy the output to SECRET_KEY_BASE in .env
```

### 2. Start the services

```bash
docker compose up -d --build
```

This will start two containers:
1. `db`: A MySQL 8.0 instance holding your data.
2. `web`: The Nasflix application running on port `8080`.

The database will be automatically migrated on startup.

### 3. Access the App

Open your browser and navigate to:
[http://localhost:8080](http://localhost:8080)

*The first time you load the app, you will be redirected to an onboarding screen to create your Admin account. From there, you can configure your library and load demo data instantly.*

### Resetting the Database

To start fresh with a new database:

```bash
docker compose down -v    # -v removes all data
docker compose up -d --build
```

### Persistent Storage

Uploaded videos are saved in the local `storage/` directory, which is mapped as a Docker volume to persist across container restarts.

---

## 🛠 Manual Development Setup

If you prefer to run things natively for development:

1. **Install Ruby:** Make sure you have Ruby 4.0.1 installed (or check `.ruby-version`).
2. **Install Dependencies:**
   ```bash
   bundle install
   ```
3. **Database Setup:** Ensure MySQL is running locally, then prepare the DB:
   ```bash
   bin/rails db:prepare
   ```
4. **Run the server:**
   ```bash
   bin/dev
   ```

## Running Tests

Nasflix includes a full suite of end-to-end system tests and unit tests.

```bash
bin/rails test          # Run model, controller, and background job tests
bin/rails test:system   # Run UI-driven end-to-end Capybara tests
```

---
**License:** MIT
