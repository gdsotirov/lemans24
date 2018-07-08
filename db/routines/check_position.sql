DELIMITER //

CREATE FUNCTION check_position(pos VARCHAR(3))
RETURNS BOOL NO SQL
BEGIN
  /* Either a number */
  IF pos RLIKE '^[1-9][0-9]*$' THEN
    RETURN TRUE;
  /* Ore one of these values
   * DNA - Did Not Attend
   * DNF - Did Not Finish
   * DNP - Did Not Practice
   * DNQ - Did Not Qualify
   * DNS - Did Not Start
   * DSQ - Disqualified
   * NC  - Not classified
   * RES - Reserve
   */
  ELSEIF pos IN ('DNA', 'DNF', 'DNP', 'DNQ', 'DNS', 'DSQ', 'NC', 'RES') THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END //

DELIMITER ;
