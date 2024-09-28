WITH averia_masiva as (SELECT ivr_id, module_name FROM `keepcoding.ivr_modules` WHERE module_name = "AVERIA_MASIVA")

SELECT c.ivr_id,
  IF(averia_masiva.ivr_id IS NULL, 0,1) as masiva_lg
  FROM `keepcoding.ivr_calls` c
  LEFT JOIN averia_masiva
  ON averia_masiva.ivr_id = c.ivr_id