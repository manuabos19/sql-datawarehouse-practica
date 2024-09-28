CREATE OR REPLACE TABLE `keepcoding.ivr_detail` AS
SELECT 
  calls.ivr_id, 
  calls.phone_number,
  calls.ivr_result,
  calls.vdn_label,
  calls.start_date,
  FORMAT_DATE('%Y%m%d', calls.start_date) as calls_start_date_id,
  calls.end_date,
  FORMAT_DATE('%Y%m%d', calls.end_date) as calls_end_date_id,
  calls.total_duration,
  calls.customer_segment,
  calls.ivr_language,
  calls.steps_module,
  calls.module_aggregation,
  module.module_sequece,
  module.module_name,
  module.module_duration,
  module.module_result,
  step.step_sequence,
  step.step_name,
  step.step_result,
  step.step_description_error,
  step.document_type,
  step.document_identification,
  step.customer_phone,
  step.billing_account_id
    FROM `keepcoding.ivr_calls` as calls
    LEFT
    JOIN `keepcoding.ivr_modules` as module
    ON calls.ivr_id = module.ivr_id
    LEFT
    JOIN `keepcoding.ivr_steps` as step
    ON module.ivr_id = step.ivr_id
    AND 
    module.module_sequece = step.module_sequece
  
