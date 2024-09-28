CREATE OR REPLACE TABLE keepcoding.ivr_summary AS
WITH vdn
  AS (SELECT 
  ivr_id,
  CASE WHEN STARTS_WITH(vdn_label, 'ATC') THEN 'FRONT'
       WHEN STARTS_WITH(vdn_label, 'TECH') THEN 'TECH'
       WHEN STARTS_WITH(vdn_label, 'ABSORPTION') THEN 'ABSORPTION'
       ELSE 'RESTO' 
  END AS vdn_aggregation
  FROM `keepcoding.ivr_calls` AS c )
  , document AS
    (SELECT  ivr_id
      ,document_type
      ,document_identification 
    FROM `keepcoding.ivr_steps` 
    QUALIFY ROW_NUMBER() OVER (PARTITION BY CAST(ivr_id AS string) ORDER BY document_type ,document_identification)  = 1)
  , custome_phone AS
    (SELECT 
      detail.ivr_id, 
      MAX(COALESCE(detail.phone_number,detail.customer_phone, '999999999')) AS customer_phone
    FROM `keepcoding.ivr_detail` detail
    GROUP BY 
      ivr_id
    )
  , billing AS
    (SELECT ivr_id, billing_account_id
    FROM `keepcoding.ivr_steps`
      QUALIFY ROW_NUMBER() OVER (PARTITION BY CAST(ivr_id AS string) ORDER BY billing_account_id) = 1)
  , masiva AS 
    (WITH averia_masiva as (SELECT ivr_id, module_name FROM `keepcoding.ivr_modules` WHERE module_name = "AVERIA_MASIVA")
      SELECT c.ivr_id,
        IF(averia_masiva.ivr_id IS NULL, 0,1) as masiva_lg
      FROM `keepcoding.ivr_calls` c
      LEFT JOIN averia_masiva
      ON averia_masiva.ivr_id = c.ivr_id)
  , phone_lg AS
    (WITH step as (SELECT ivr_id FROM `keepcoding.ivr_steps` WHERE step_name = "CUSTOMERINFOBYPHONE.TX" AND step_result = "OK")
      SELECT c.ivr_id,
        IF(step.ivr_id IS NULL, 0,1) as info_by_phone_lg
      FROM `keepcoding.ivr_calls` c
      LEFT JOIN step
      ON step.ivr_id = c.ivr_id)
  , dni_lg AS
    (WITH step as (SELECT ivr_id FROM `keepcoding.ivr_steps` WHERE step_name = "CUSTOMERINFOBYDNI.TX" AND step_result = "OK")
      SELECT c.ivr_id,
        IF(step.ivr_id IS NULL, 0,1) as info_by_dni_lg
      FROM `keepcoding.ivr_calls` c
      LEFT JOIN step
      ON step.ivr_id = c.ivr_id)
  , calls_repeat AS
    (SELECT 
      ivr_id
      ,phone_number
      ,IF(DATETIME_DIFF(LAG(start_date) OVER(PARTITION BY phone_number ORDER BY phone_number, start_date), start_date, HOUR) > -24 , 1,0) AS repeated_phone_24H 
      ,IF(DATETIME_DIFF(LEAD(start_date) OVER(PARTITION BY phone_number ORDER BY phone_number, start_date), start_date, HOUR) < 24 , 1,0) AS cause_recall_phone_24H 
      FROM `keepcoding.ivr_calls`)

  SELECT 
    detail.ivr_id,
    detail.phone_number,
    detail.ivr_result,
    vdn.vdn_aggregation,
    detail.start_date,
    detail.end_date,
    detail.total_duration,
    detail.customer_segment,
    detail.ivr_language,
    detail.steps_module,
    detail.module_aggregation,
    document.document_type,
    document.document_identification,
    custome_phone.customer_phone,
    billing.billing_account_id,
    masiva.masiva_lg,
    phone_lg.info_by_phone_lg,
    dni_lg.info_by_dni_lg,
    calls_repeat.repeated_phone_24H,
    calls_repeat.cause_recall_phone_24H
  FROM `keepcoding.ivr_detail` detail
  LEFT 
  JOIN vdn ON vdn.ivr_id = detail.ivr_id
  LEFT
  JOIN document ON document.ivr_id = detail.ivr_id
  LEFT 
  JOIN custome_phone ON custome_phone.ivr_id = detail.ivr_id
  LEFT 
  JOIN billing ON billing.ivr_id = detail.ivr_id
  LEFT
  JOIN masiva ON masiva.ivr_id = detail.ivr_id
  LEFT
  JOIN phone_lg ON phone_lg.ivr_id = detail.ivr_id
  LEFT
  JOIN dni_lg ON dni_lg.ivr_id = detail.ivr_id
  LEFT
  JOIN calls_repeat ON calls_repeat.ivr_id = detail.ivr_id
  GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20