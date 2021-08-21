LOAD DATA INFILE '/var/mysql/files/results_in.csv'
INTO TABLE results_in
FIELDS TERMINATED BY ';'
IGNORE 1 LINES
(race_yr, pos, car_class, car_nbr,
team_cntry, team_name,
drivers_cntry, drivers_name,
car_chassis, car_engine, car_tyres,
laps, distance, racing_time, reason);

