DELIMITER //

CREATE FUNCTION check_position(pos VARCHAR(3))
RETURNS BOOL NO SQL
BEGIN
  /* Either a number */
  IF pos RLIKE '^[1-9][0-9]*$' THEN
    RETURN TRUE;
  /* Ore one of these values
   * NC  - Not classified
   * DNF - Did Not Finish
   * DNS - Did Not Start
   * DSQ - Disqualified
   */
  ELSEIF pos IN ('NC', 'DNF', 'DNS', 'DSQ') THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END //

DELIMITER ;
