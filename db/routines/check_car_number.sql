DELIMITER //

CREATE FUNCTION check_car_number(car_nbr VARCHAR(3))
RETURNS BOOL NO SQL
BEGIN
  /* Car numbers should be non-zero padded integers */
  IF    car_nbr RLIKE '^[1-9][0-9]{0,2}$'
    /* or 007, 008 and 009 like between 2006 and 2011 */
    OR  car_nbr RLIKE '^00[7-9]$'
    /* or just zero */
    OR  car_nbr RLIKE '^0$'
  THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END //

DELIMITER ;
