CREATE OR REPLACE FUNCTION keepcoding.fnc_clean_integers(p_integer INTEGER) 
RETURNS INT64 
AS
(
    COALESCE(p_integer, -9999999)
);