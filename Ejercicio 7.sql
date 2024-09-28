
SELECT ivr_id, billing_account_id
  FROM `keepcoding.ivr_steps`
  QUALIFY ROW_NUMBER() OVER (PARTITION BY CAST(ivr_id AS string) ORDER BY billing_account_id) = 1
