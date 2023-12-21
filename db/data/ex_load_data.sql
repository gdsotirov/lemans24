/* Sample script loading data */

START TRANSACTION;

DELETE FROM results_in WHERE 1=1;

LOAD DATA INFILE '/var/mysql/files/results_in.csv'
  INTO TABLE results_in
  FIELDS TERMINATED BY ';'
    OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (race_yr, pos, car_class, car_nbr,
   team_cntry, team_name,
   drivers_cntry, drivers_name,
   car_chassis, car_engine, @car_tyres,
   laps, distance,
   @racing_time, @reason)
  SET
    car_tyres   = CASE @car_tyres   WHEN '' THEN NULL ELSE @car_tyres   END,
    racing_time = CASE @racing_time WHEN '' THEN NULL ELSE @racing_time END,
    reason      = CASE @reason      WHEN '' THEN NULL ELSE @reason      END;

CALL lemans24.cleanup();
CALL lemans24.process_results();

COMMIT;
