DELIMITER //

CREATE FUNCTION pos_to_num(pos VARCHAR(3) CHARACTER SET ascii)
  RETURNS INT
  DETERMINISTIC
BEGIN
  RETURN CASE
           WHEN pos RLIKE '^[1-9][0-9]*$'
             THEN CAST(pos AS UNSIGNED)
           WHEN pos = 'NC'  THEN 92
           WHEN pos = 'DNF' THEN 93
           WHEN pos = 'DSQ' THEN 94
           WHEN pos = 'DNS' THEN 95
           WHEN pos = 'DNQ' THEN 96
           WHEN pos = 'DNP' THEN 97
           WHEN pos = 'RES' THEN 98
           WHEN pos = 'DNA' THEN 99
         END;
END //

DELIMITER ;

