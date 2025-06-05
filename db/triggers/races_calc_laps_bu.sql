DELIMITER //

CREATE TRIGGER races_calc_laps_bu BEFORE UPDATE ON races FOR EACH ROW
BEGIN
  DECLARE cir_length_km DECIMAL(5,3);

  IF NEW.distance_km <> OLD.distance_km AND NEW.laps IS NULL THEN
    SELECT length_km
      INTO cir_length_km
      FROM circuits
     WHERE id = NEW.circuit_id;

    SET NEW.laps = ROUND(NEW.distance_km / cir_length_km, 0);
  END IF;
END //

DELIMITER ;
