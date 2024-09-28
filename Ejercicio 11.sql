SELECT 
  ivr_id
  ,phone_number
  ,IF(DATETIME_DIFF(LAG(start_date) OVER(PARTITION BY phone_number ORDER BY phone_number, start_date), start_date, HOUR) > -24 , 1,0) AS repeated_phone_24H 
  ,IF(DATETIME_DIFF(LEAD(start_date) OVER(PARTITION BY phone_number ORDER BY phone_number, start_date), start_date, HOUR) < 24 , 1,0) AS cause_recall_phone_24H 
  FROM `keepcoding.ivr_calls`