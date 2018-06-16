DELIMITER //

CREATE TRIGGER results_in_checks_bu
BEFORE UPDATE ON results_in
FOR EACH ROW
BEGIN
  IF NEW.race_yr <> OLD.race_yr THEN
    IF NEW.race_yr < 1923 THEN
      SET @errmsg = 'Race year should be 1923 or later!';
      SIGNAL SQLSTATE '10101' SET MESSAGE_TEXT = @errmsg;
    END IF;
  END IF;

  IF NEW.pos <> OLD.pos THEN
    IF NOT check_position(NEW.pos) THEN
      SET @errmsg = 'Position sould be number, NC, DNF or DSQ!';
      SIGNAL SQLSTATE '10102' SET MESSAGE_TEXT = @errmsg;
    END IF;
  END IF;

  IF NEW.tyre <> OLD.tyre THEN
    /* no tyre data -> NULL */
    IF NEW.tyre = '' THEN
      SET NEW.tyre = NULL;
    END IF;
  END IF;

  IF NEW.laps <> OLD.laps THEN
    /* no laps data -> NULL */
    IF NEW.laps = 0 THEN
      SET NEW.laps = NULL;
    END IF;
  END IF;

  IF NEW.distance <> OLD.distance THEN
    /* no distance data -> NULL */
    IF NEW.distance = 0.0 THEN
      SET NEW.distance = NULL;
    END IF;
  END IF;

  IF NEW.racing_time <> OLD.racing_time THEN
    /* no racing time data -> NULL */
    IF NEW.racing_time = '00:00:00' THEN
      SET NEW.racing_time = NULL;
    END IF;
  END IF;

  IF NEW.reason <> OLD.reason THEN
    /* no reason for NC, DNF, DSQ -> NULL */
    IF NEW.reason = '' THEN
      SET NEW.reason = NULL;
    END IF;
  END IF;
END //

DELIMITER ;
