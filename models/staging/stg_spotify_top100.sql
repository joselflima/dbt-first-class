WITH RAW_TOP100 AS (
    SELECT * FROM {{ ref('spotify_alltime_top100_songs') }}
),

-- Renaming columns
RENAMED AS (
    SELECT
        alltime_rank AS ranking_position,
        song_title,
        artist,
        total_streams_billions AS streams_in_billions,
        primary_genre,
        bpm,
        release_year,
        artist_country,
        explicit AS is_explicit,
        danceability,
        energy,
        valence,
        acousticness
    FROM RAW_TOP100
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
        CAST(release_year AS INT) AS release_year,
        CAST((CASE WHEN is_explicit = 'True' THEN 1 ELSE 0 END) AS BOOLEAN) AS is_explicit,
        CAST(danceability AS REAL) AS danceability,
        CAST(energy AS REAL) AS energy,
        CAST(valence AS REAL) AS valence,
        CAST(acousticness AS REAL) AS acousticness
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
        release_year,
        is_explicit,
        danceability,
        energy,
        valence,
        acousticness
    FROM CASTED
)

SELECT * FROM TRIMMED