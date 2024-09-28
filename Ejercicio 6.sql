
SELECT 
    detail.ivr_id, 
    MAX(COALESCE(detail.phone_number,detail.customer_phone, '999999999')) AS customer_phone
  FROM `keepcoding.ivr_detail` detail
  GROUP BY 
    ivr_id

