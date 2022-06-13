DELIMITER //

CREATE PROCEDURE cleanup()
BEGIN
  DELETE FROM driver_results WHERE driver_id > 0;
  ALTER TABLE driver_results AUTO_INCREMENT = 1;

  DELETE FROM team_results WHERE team_id > 0;
  ALTER TABLE team_results AUTO_INCREMENT = 1;

  DELETE FROM results WHERE id > 0;
  ALTER TABLE results AUTO_INCREMENT = 1;

  DELETE FROM car_tyres WHERE car_id > 0;
  ALTER TABLE car_tyres AUTO_INCREMENT = 1;

  DELETE FROM car_numbers WHERE id > 0;
  ALTER TABLE car_numbers AUTO_INCREMENT = 1;

  DELETE FROM cars WHERE id > 0;
  ALTER TABLE cars AUTO_INCREMENT = 1;

  DELETE FROM drivers WHERE id > 0;
  ALTER TABLE drivers AUTO_INCREMENT = 1;

  DELETE FROM teams WHERE id > 0;
  ALTER TABLE teams AUTO_INCREMENT = 1;

  UPDATE results_in
     SET processed = FALSE
   WHERE processed = TRUE;
END //

DELIMITER ;
