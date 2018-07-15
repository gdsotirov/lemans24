LOAD DATA INFILE '/var/mysql/files/results_in.csv'
  INTO TABLE results_in
  FIELDS TERMINATED BY ';'
  OPTIONALLY ENCLOSED BY '"'
  IGNORE 1 LINES
  (race_yr, pos, car_class, car_nbr,
   team_cntry, team_name,
   drivers_cntry, drivers_name,
   chassis, `engine`, tyre,
   laps, distance,
   racing_time, reason);

