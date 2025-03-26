WITH sellers as (
    SELECT
        t1.seller_id,
        sum(t1.price)+sum(t1.freight_value) as valor_total,
        t2.product_category_name
    FROM tb_order_items as t1
    
    left join tb_products as t2
    on t1.product_id = t2.product_id
    
    group by 1,3
),

tratamento as (
    SELECT
        seller_id,
        CASE WHEN product_category_name like '%alimentos%' then sum(valor_total) end as alimentos,
        CASE WHEN product_category_name like '%construcao%' then sum(valor_total) end as construcao,
        CASE WHEN product_category_name like '%eletrodomesticos%' then sum(valor_total) end as eletrodomesticos,
        CASE WHEN product_category_name like '%fashion%' then sum(valor_total) end as fashion,
        CASE WHEN product_category_name like '%livros%' then sum(valor_total) end as livros,
        CASE WHEN product_category_name like '%moveis%' then sum(valor_total) end as moveis,
        CASE WHEN product_category_name like '%telefonia%' then sum(valor_total) end as telefonia,
        CASE WHEN product_category_name not like '%alimentos%'
            AND product_category_name not like '%telefonia%'
            AND product_category_name not like '%fashion%'
            AND product_category_name not like '%livros%'
            AND product_category_name not like '%moveis%'
            AND product_category_name not like '%construcao%'
            AND product_category_name not like '%eletrodomesticos%'
        then sum(valor_total)
        END as outros    
    from sellers

    group by seller_id, product_category_name
),

valor_completo as (
    SELECT
        seller_id,
        sum (valor_total) as valor_total
    from sellers

    group by 1
)

SELECT
    t1.seller_id,
    coalesce(round(sum(t1.alimentos)/t2.valor_total*100,1),0) as  alimentos,
    coalesce(round(sum(t1.construcao)/t2.valor_total*100,1),0) as  construcao,
    coalesce(round(sum(t1.eletrodomesticos)/t2.valor_total*100,1),0) as  eletrodomesticos,
    coalesce(round(sum(t1.fashion)/t2.valor_total*100,1),0) as  fashion,
    coalesce(round(sum(t1.livros)/t2.valor_total*100,1),0) as  livros,
    coalesce(round(sum(t1.moveis)/t2.valor_total*100,1),0) as  moveis,
    coalesce(round(sum(t1.telefonia)/t2.valor_total*100,1),0) as  telefonia,
    coalesce(round(sum(t1.outros)/t2.valor_total*100,1),0) as outros 
from tratamento as t1

left join valor_completo as t2
on t1.seller_id = t2.seller_id

group by 1




