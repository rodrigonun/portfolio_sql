select
    department,
    count(worker_id) as num_workers
from Trabalhadores_por_departamento_desde_abril

where joining_date >= '2014-04-01'

GROUP BY 1

ORDER BY num_workers DESC