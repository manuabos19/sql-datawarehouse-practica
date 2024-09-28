SELECT  ivr_id
  ,document_type
  ,document_identification 
    FROM `keepcoding.ivr_steps` 
    QUALIFY ROW_NUMBER() OVER (PARTITION BY CAST(ivr_id AS string) ORDER BY document_type ,document_identification)  = 1