DELIMITER //

CREATE TRIGGER results_checks_bi
BEFORE INSERT ON results
FOR EACH ROW
BEGIN
  IF NOT check_position(NEW.pos) THEN
    SET @errmsg = 'Position sould be number or special value (e.g. NC, DNF, DSQ, etc.)!';
    SIGNAL SQLSTATE '10102' SET MESSAGE_TEXT = @errmsg;
  END IF;
END //

DELIMITER ;
