DELIMITER //

CREATE TRIGGER races_calc_laps_bi BEFORE INSERT ON races FOR EACH ROW
BEGIN
  DECLARE cir_length_km DECIMAL(5,3);

  SELECT length_km
    INTO cir_length_km
    FROM circuits
   WHERE id = NEW.circuit_id;

  IF NEW.laps IS NULL AND NEW.distance_km IS NOT NULL THEN
    SET NEW.laps = ROUND(NEW.distance_km / cir_length_km, 0);
  END IF;
END //

DELIMITER ;
