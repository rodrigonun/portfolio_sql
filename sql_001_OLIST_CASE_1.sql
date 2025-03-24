
with sellers as (
    SELECT
        t1.seller_id as vendedor,
        t1.product_id as produto,
        t2.product_category_name as categoria_do_produto,
        count(distinct(t1.order_id)) as qntd,
        sum(t1.price) as valor_venda
    FROM tb_order_items as t1

    left join tb_products as t2
    on t1.product_id=t2.product_id

    group by 1,2,3
),

ranking as (
    SELECT
        *,
        row_number() over (partition by vendedor order by qntd desc, valor_venda desc) as rank
    from sellers
)

SELECT
    *
from ranking

where rank =1