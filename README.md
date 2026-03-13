# Nasflix

A self-hosted movie tracker and watch-party platform built with Ruby on Rails.

## Tech Stack & Versions
- **Ruby:** 4.0.1
- **Ruby on Rails:** 8.1.2
- **Database:** MySQL

## Features

- **Models & Associations:** 6 models (`User`, `Movie`, `Review`, `WatchlistEntry`, `MovieNight`, `Invitation`) with meaningful associations.
- **Data Fields:** `WatchlistEntry` tracks `start_date` and `end_date` for each movie.
- **Validations:** Models include validations for required fields and custom validation ensuring `end_date` is after or equal to `start_date`.
- **CRUD:** Complete interface (index, show, new/create, edit/update, destroy) for movies, watchlist entries, and movie nights.
- **Styling:** Custom CSS without external UI frameworks.
- **Seed Data:** `db/seeds.rb` for demo data (loaded via "Load Demo Data" button in admin).

---

## Docker Production Setup

The easiest way to get Nasflix running is via Docker Compose.

### Prerequisites
- Docker
- Docker Compose

### 1. Setup Environment Variables

Run the setup script to generate secure credentials:

```bash
./setup.sh
```

This will create a `.env` file with secure random passwords.

Or manually copy and edit:
```bash
cp .env.example .env
# Edit .env with your values
```

### 2. Start the Services

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

The first time you load the app, you will be redirected to an onboarding screen to create your Admin account. From there, you can configure your library and load demo data instantly.

### Resetting the Database

To start fresh with a new database:

```bash
docker compose down -v    # -v removes all data
docker compose up -d --build
```

### Persistent Storage

Uploaded videos are saved in the local `storage/` directory, which is mapped as a Docker volume to persist across container restarts.

---

## Manual Development Setup

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
