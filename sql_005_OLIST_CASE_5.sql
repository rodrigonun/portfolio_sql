-- SQL_005_OLIST_CASE_5

WITH MESES AS (
    SELECT
        DISTINCT(STRFTIME('%Y-%m-01',order_approved_at)) AS MES_REFERENCIA,
        1 AS KEY
    FROM TB_ORDERS

    WHERE MES_REFERENCIA IS NOT NULL

    ORDER BY 1 DESC
),

SELLERS AS (
    SELECT
        T1.SELLER_ID,
        MIN(STRFTIME('%Y-%m-01',T2.order_approved_at)) AS MES_PRIMEIRA_VENDA,
        1 AS KEY
    FROM TB_ORDER_ITEMS AS T1

    LEFT JOIN TB_ORDERS AS T2
    ON T1.order_id=T2.order_id

    GROUP BY 1
),

CRUZAMENTO AS (
    SELECT
        T1.MES_REFERENCIA,
        T2.seller_id,
        T2.MES_PRIMEIRA_VENDA
    FROM MESES AS T1

    LEFT JOIN SELLERS AS T2
    ON T1.KEY=T2.KEY
    ORDER BY seller_id, MES_REFERENCIA ASC
),

VENDAS AS (
    SELECT
        T1.seller_id,
        STRFTIME('%Y-%m-01',T2.order_approved_at) AS MES_VENDA,
        SUM(T1.price) + SUM(T1.freight_value) AS VALOR_VENDA
    FROM TB_ORDER_ITEMS AS T1

    LEFT JOIN TB_ORDERS AS T2
    ON T1.order_id = T2.order_id
    
    GROUP BY 1,2
)

SELECT
    T1.MES_REFERENCIA,
    T1.seller_id,
    T1.MES_PRIMEIRA_VENDA,
    COALESCE(SUM(T2.VALOR_VENDA),0) AS VALOR_VENDA
FROM CRUZAMENTO AS T1

LEFT JOIN VENDAS AS T2
ON T1.seller_id = T2.seller_id AND T1.MES_REFERENCIA=T2.MES_VENDA

GROUP BY 1,2,3

ORDER BY T1.seller_id, T1.MES_REFERENCIA
