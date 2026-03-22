# DataBeats Records Analytics - dbt Core Project

An Analytics Engineering project built with `dbt Core` to transform public Spotify data into actionable insights for A&R (Artists and Repertoire) decisions at the fictional label DataBeats Records.

## 1. Context (Business Problem)

### 🎧 The Business Problem: Welcome to DataBeats Records

DataBeats Records is one of the biggest independent labels in the market, but we have a problem: our eccentric CEO (and music industry legend), Mr. HitMaker, is tired of investing millions in artists based only on producer "gut feeling" or random TikTok dances. He wants measurable results.

For Summer 2026, the board approved a USD 50 million budget to sign new talent and produce the next global hit. The CEO's ultimatum was clear:

> "No more guesswork. Where do the data say we should invest our money?"

As the label's new Analytics Engineer, the mission of this project is to build a robust data pipeline with `dbt Core` to analyze Spotify giants. By combining data from the Top 100 All-Time Songs and the top songs/artists from Spotify Wrapped 2025, we aim to answer the board's strategic questions.

### 🎯 Questions the Board Needs Answered

1. Hit Formula: should our next bet be high-energy music (high BPM), or does the current trend point to calmer and more acoustic songs?
2. Genre Battle: does Pop still hold the global crown, or is it time to invest heavily in Country, Reggaeton, or K-Pop scouting?
3. Talent Scouting Map: where should we send our scouts? Which countries are exporting artists who convert the highest monthly listener numbers?
4. Fame vs. Engagement: does it make more sense to sign artists with huge follower bases, or do awards (for example, Grammys) attract more loyal listeners?

In this project, raw data is transformed into analytical assets that support much more confident investment decisions.

## 2. Solution

### Architecture Overview

Implemented pipeline:

1. `extract.py` downloads CSVs directly from Kaggle.
2. Files are moved into the `seeds/` folder.
3. `dbt seed` loads CSVs into Postgres.
4. `dbt run` transforms data across `staging` and `marts` layers.
5. `dbt test` validates basic data quality rules.

Local infrastructure:

1. Postgres 15 containerized with Docker Compose.
2. Local persistence through the `postgres_data` Docker volume.

Note: the visual architecture diagram will be created later in Excalidraw.

## 3. Implementation

### 3.1 Main Components

#### `extract.py`

Responsibilities:

1. Download dataset `emanfatima2/spotify-global-hits-and-artist-analytics` with `kagglehub`.
2. Move downloaded files to `./seeds`.

Libraries used:

1. `kagglehub`
2. `shutil`
3. `os`

#### `docker-compose.yml`

Configures the local analytical database:

1. Image: `postgres:15`
2. Container: `dbt-database`
3. Exposed port: `5432:5432`
4. Credentials:
   - user: `postgres`
   - password: `postgres`
   - database: `bank`
5. Persistent volume: `postgres_data`

#### `dbt_project.yml`

Key configurations:

1. Project: `dbt_first_class`
2. Profile: `dbt_first_class`
3. Paths:
   - `models/`
   - `seeds/`
   - `analyses/`
   - `tests/`
   - `macros/`
   - `snapshots/`

### 3.2 Data Layers

#### Seeds (`seeds/`)

Files loaded as raw tables:

1. `spotify_alltime_top100_songs.csv` (100 rows)
2. `spotify_wrapped_2025_top50_artists.csv` (50 rows)
3. `spotify_wrapped_2025_top50_songs.csv` (50 rows)

These files contain popularity metrics, audio attributes (BPM, energy, acousticness, danceability), and artist information (country, followers, Grammys, monthly listeners).

#### Staging (`models/staging/`)

Implemented model:

1. `stg_spotify_artists.sql`

Applied transformations:

1. Column renaming for semantic standardization.
2. Selection of strategic fields for scouting and performance analyses.

Main mappings:

1. `wrapped_2025_rank` -> `rank_position`
2. `monthly_listeners_millions_mar2026` -> `monthly_listeners_millions`
3. `country` -> `artist_country`

#### Marts (`models/marts/`)

Implemented model:

1. `dim_artists_by_country.sql`

Model purpose:

1. Consolidate country-level artist indicators for scouting decisions.

Calculated metrics:

1. `total_top_artists`
2. `total_monthly_listeners_millions`
3. `total_grammys`

### 3.3 Data Quality

Tests in `models/staging/schema.yml`:

1. `not_null` on `rank_position`
2. `not_null` on `artist_name`
3. `not_null` on `monthly_listeners_millions`

### 3.4 dbt Inventory

Current project status (via `dbt ls`):

1. 3 seeds
2. 2 models
3. 3 data tests

### 3.5 Folder Structure

```text
.
├── analyses/
├── macros/
├── models/
│   ├── marts/
│   │   └── dim_artists_by_country.sql
│   └── staging/
│       ├── schema.yml
│       └── stg_spotify_artists.sql
├── seeds/
│   ├── spotify_alltime_top100_songs.csv
│   ├── spotify_wrapped_2025_top50_artists.csv
│   └── spotify_wrapped_2025_top50_songs.csv
├── snapshots/
├── tests/
├── docker-compose.yml
├── dbt_project.yml
├── extract.py
└── requirements.txt
```

## Prerequisites

1. Python 3.10+
2. Docker and Docker Compose
3. Kaggle account configured locally (required by `kagglehub`)

## Environment Setup

1. Create and activate a virtual environment:

```bash
python -m venv venv
source venv/bin/activate
```

2. Install dependencies:

```bash
pip install -r requirements.txt
```

3. Start Postgres with Docker:

```bash
docker compose up -d
```

4. Configure dbt profile (`~/.dbt/profiles.yml`), example:

```yaml
dbt_first_class:
  target: dev
  outputs:
    dev:
      type: postgres
      host: localhost
      user: postgres
      password: postgres
      port: 5432
      dbname: spotify
      schema: analysis
      threads: 4
```

## End-to-End Execution

With the `venv` activated:

```bash
python extract.py
dbt seed
dbt run
dbt test
```

Logical pipeline order:

1. CSV ingestion (`extract.py`)
2. Database loading (`dbt seed`)
3. Transformations (`dbt run`)
4. Data validation (`dbt test`)

## How This Project Answers the Business Questions

1. Hit Formula:
   - Song datasets include `bpm`, `energy`, `acousticness`, `valence`, and `danceability`, enabling profiling of high-performing tracks.
2. Genre Battle:
   - `primary_genre` fields in artists and songs support concentration analyses of success by genre.
3. Talent Scouting Map:
   - The `dim_artists_by_country` mart aggregates artists, monthly listeners, and Grammys by country.
4. Fame vs. Engagement:
   - Artist data includes `followers_millions`, `monthly_listeners_millions`, and `grammy_wins` for correlation analyses between reach and recognition.

## Suggested Next Steps

1. Add new song-focused models (`stg_spotify_songs` and marts for genre/BPM performance).
2. Add uniqueness and accepted values tests.
3. Publish project docs with `dbt docs generate` and `dbt docs serve`.
4. Implement snapshots to track metric changes over time.
5. Integrate with a BI layer (for example, Power BI, Looker Studio, Metabase).

## Quick Troubleshooting

1. `dbt: command not found`
   - Activate the virtual environment before running dbt.
   - `source venv/bin/activate`
2. Kaggle download failure
   - Check local Kaggle authentication and configuration.
3. Postgres connection error
   - Confirm container is running: `docker compose ps`
   - Confirm host/port/credentials in `profiles.yml`.

