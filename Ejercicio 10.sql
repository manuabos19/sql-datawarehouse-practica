WITH step as (SELECT ivr_id
  FROM `keepcoding.ivr_steps`
  WHERE step_name = "CUSTOMERINFOBYDNI.TX" AND step_result = "OK")


SELECT c.ivr_id,
  IF(step.ivr_id IS NULL, 0,1) as info_by_dni_lg
  FROM `keepcoding.ivr_calls` c
  LEFT JOIN step
  ON step.ivr_id = c.ivr_id