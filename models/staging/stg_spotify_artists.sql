WITH RAW_ARTISTS AS (
    SELECT * FROM {{ ref('spotify_wrapped_2025_top50_artists') }}
),

RENAMED AS (
    SELECT
        wrapped_2025_rank AS rank_position,
        artist_name,
        monthly_listeners_millions_mar2026 AS monthly_listeners_millions, 
        primary_genre,
        country AS artist_country,
        followers_millions,
        grammy_wins,
        debut_year,
        gender
    FROM RAW_ARTISTS
)

SELECT * FROM RENAMED
