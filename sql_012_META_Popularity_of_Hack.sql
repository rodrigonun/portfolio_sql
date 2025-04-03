SELECT
    t1.location,
    avg(t2.popularity) as media_pop
FROM facebook_employees as t1

LEFT JOIN facebook_hack_survey as t2
on t1.id = t2.employee_id

group by 1
