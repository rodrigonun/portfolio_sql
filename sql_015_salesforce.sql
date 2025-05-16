SELECT
    department,
    first_name,
    salary,
    avg(salary) over (PARTITION BY department) as average_salary
FROM funcionario

GROUP BY 1,2,3

ORDER BY 1