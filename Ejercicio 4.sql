
SELECT 
  c.ivr_id,
  CASE WHEN STARTS_WITH(c.vdn_label, 'ATC') THEN 'FRONT'
       WHEN STARTS_WITH(c.vdn_label, 'TECH') THEN 'TECH'
       WHEN STARTS_WITH(c.vdn_label, 'ABSORPTION') THEN 'ABSORPTION'
       ELSE 'RESTO' 
  END AS vdn_aggregation
  FROM `keepcoding.ivr_calls` AS c 