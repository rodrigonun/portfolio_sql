SELECT
    bike_number,
    max(end_time) as ultima_vez
FROM dc_bikeshare_q1_2012

group by 1

order by ultima_vez desc