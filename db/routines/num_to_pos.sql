CREATE FUNCTION num_to_pos(num INT)
  RETURNS VARCHAR(3)
  DETERMINISTIC
BEGIN
  RETURN CASE 
           WHEN num BETWEEN 1 AND 90
             THEN CAST(num AS CHAR)
           WHEN num = 92 THEN 'NC'
           WHEN num = 93 THEN 'DNF'
           WHEN num = 94 THEN 'DSQ'
           WHEN num = 95 THEN 'DNS'
           WHEN num = 96 THEN 'DNQ'
           WHEN num = 97 THEN 'DNP'
           WHEN num = 98 THEN 'RES'
           WHEN num = 99 THEN 'DNA'
         END;
END
