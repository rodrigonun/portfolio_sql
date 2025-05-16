SELECT
    artist,
    COUNT(id) as n_ocurrences
FROM classificação_diária_de_músicas_do_spotify_mundial

GROUP BY 1

ORDER BY 2 DESC