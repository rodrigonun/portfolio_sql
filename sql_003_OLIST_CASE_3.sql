with sellers as (
    SELECT
        seller_id,
        order_id,
        sum(price) + sum(freight_value) as valor_total
    from tb_order_items

    group by 1,2
),

tipo_pagamento as (
    SELECT
        order_id,
        payment_type,
        sum(payment_value) as valor_pago
    FROM tb_order_payments

    group by 1,2
),

cruzamento as (
    SELECT
        t1.seller_id,
        t1.valor_total,
        t2.payment_type
    FROM sellers as t1

    left join tipo_pagamento as t2
    on t1.order_id=t2.order_id
),

tratamento as (
    SELECT
        seller_id,
        sum(valor_total) as valor_total,
        CASE WHEN payment_type='credit_card' THEN sum(valor_total) END AS cartao_credito,
        CASE WHEN payment_type='boleto' THEN sum(valor_total) END AS boleto,
        CASE WHEN payment_type='voucher' THEN sum(valor_total) END AS voucher,
        CASE WHEN payment_type='debit_card' THEN sum(valor_total) END AS cartao_debito    
    FROM cruzamento

    group by 1, payment_type
)

SELECT
    seller_id as vendedor,
    sum(valor_total) as valor_total,
    coalesce(round(sum(cartao_credito)/sum(valor_total),2),0)*100 as cartao_credito,
    coalesce(round(sum(boleto)/sum(valor_total),2),0)*100 as boleto,
    coalesce(round(sum(voucher)/sum(valor_total),2),0)*100 as voucher,
    coalesce(round(sum(cartao_debito)/sum(valor_total),2),0)*100 as cartao_debito
FROM tratamento

group by 1