DELIMITER //

CREATE TRIGGER results_in_checks_bi
BEFORE INSERT ON results_in
FOR EACH ROW
BEGIN
  IF NEW.race_yr < 1923 THEN
    SET @errmsg = 'Race year should be 1923 or later!';
    SIGNAL SQLSTATE '10101' SET MESSAGE_TEXT = @errmsg;
  END IF;

  IF NOT check_position(NEW.pos) THEN
    SET @errmsg = 'Position sould be number, NC, DNF or DSQ!';
    SIGNAL SQLSTATE '10102' SET MESSAGE_TEXT = @errmsg;
  END IF;

  /* no tyre data -> NULL */
  IF NEW.tyre = '' THEN
    SET NEW.tyre = NULL;
  END IF;

  /* no laps data -> NULL */
  IF NEW.laps = 0 THEN
    SET NEW.laps = NULL;
  END IF;

  /* no distance data -> NULL */
  IF NEW.distance = 0.0 THEN
    SET NEW.distance = NULL;
  END IF;

  /* no racing time data -> NULL */
  IF NEW.racing_time = '00:00:00' THEN
    SET NEW.racing_time = NULL;
  END IF;

  /* no reason for NC, DNF, DSQ -> NULL */
  IF NEW.reason = '' THEN
    SET NEW.reason = NULL;
  END IF;
END //

DELIMITER ;
