WITH RAW_SONGS AS (
    SELECT * FROM {{ ref('spotify_wrapped_2025_top50_songs') }}
),

-- Renaming columns
RENAMED AS (
    SELECT
        wrapped_2025_rank AS ranking_position,
        song_title,
        artist,
        streams_2025_billions AS streams_in_billions,
        primary_genre,
        bpm,
        duration_seconds AS duration_in_seconds,
        release_year,
        artist_country,
        explicit AS is_explicit,
        danceability,
        energy,
        valence,
        acousticness,
        peak_global_chart_position AS highest_ranking
    FROM RAW_SONGS
),

-- Casting numerical columns
CASTED AS (
    SELECT
        CAST(ranking_position AS INT) AS ranking_position,
        song_title,
        artist,
        primary_genre,
        artist_country,
        CAST(streams_in_billions AS REAL) AS streams_in_billions,
        CAST(bpm AS INT) AS bpm,
        CAST(duration_in_seconds AS INT) AS duration_in_seconds,
        CAST(release_year AS INT) AS release_year,
        CAST(is_explicit AS BOOLEAN) AS is_explicit,
        CAST(danceability AS REAL) AS danceability,
        CAST(energy AS REAL) AS energy,
        CAST(valence AS REAL) AS valence,
        CAST(acousticness AS REAL) AS acousticness,
        CAST(highest_ranking AS INT) AS highest_ranking
    FROM RENAMED
),

-- Trimming textual columns
TRIMMED AS (
    SELECT
        ranking_position,
        CAST(TRIM(song_title) AS VARCHAR) AS song_title,
        CAST(TRIM(artist) AS VARCHAR) AS artist,
        CAST(TRIM(primary_genre) AS VARCHAR) AS primary_genre,
        CAST(TRIM(artist_country) AS VARCHAR) AS artist_country,
        streams_in_billions,
        bpm,
        duration_in_seconds,
        release_year,
        is_explicit,
        danceability,
        energy,
        valence,
        acousticness,
        highest_ranking
    FROM CASTED
)

SELECT * FROM TRIMMED
