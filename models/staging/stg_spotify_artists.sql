WITH RAW_ARTISTS AS (
    SELECT * FROM {{ ref('spotify_wrapped_2025_top50_artists') }}
),

-- Renaming columns
RENAMED AS (
    SELECT
        wrapped_2025_rank AS ranking_position,
        artist_name,
        monthly_listeners_millions_mar2026 AS monthly_listeners_millions, 
        primary_genre,
        country AS artist_country,
        followers_millions,
        grammy_wins,
        debut_year,
        gender
    FROM RAW_ARTISTS
),

-- Casting numerical columns
CASTED AS (
    SELECT
        CAST(ranking_position AS INT) AS ranking_position,
        artist_name,
        primary_genre,
        artist_country,
        gender,
        CAST(monthly_listeners_millions AS INT) AS monthly_listeners_millions,
        CAST(followers_millions AS INT) AS followers_millions,
        CAST(grammy_wins AS INT) AS grammy_wins,
        CAST(debut_year AS INT) AS debut_year
    FROM RENAMED
),

-- Trimming textual columns
TRIMMED AS (
    SELECT
        CAST(ranking_position AS INT) AS ranking_position,
        CAST(TRIM(artist_name) AS VARCHAR) AS artist_name,
        CAST(TRIM(primary_genre) AS VARCHAR) AS primary_genre,
        CAST(TRIM(artist_country) AS VARCHAR) AS artist_country,
        CAST(TRIM(gender) AS VARCHAR) AS gender,
        CAST(monthly_listeners_millions AS INT) AS monthly_listeners_millions,
        CAST(followers_millions AS INT) AS followers_millions,
        CAST(grammy_wins AS INT) AS grammy_wins,
        CAST(debut_year AS INT) AS debut_year
    FROM CASTED
)

SELECT * FROM TRIMMED
