SELECT
    id,
    first_name,
    last_name,
    department_id,
    max(salary)
FROM ms_employee_salary

group by 1,2,3,4

order by 1 asc