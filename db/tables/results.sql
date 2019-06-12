CREATE TABLE IF NOT EXISTS results (
  id          INT NOT NULL AUTO_INCREMENT,
  race_id     INT NOT NULL,
  team_id     INT NOT NULL,
  car_id      INT NOT NULL,
  driver_id   INT NOT NULL,
  position    INT NOT NULL,
  laps        INT NULL,
  distance    DECIMAL(8,3) NULL,
  racing_time TIME NULL,
  reason      VARCHAR(128) NULL,

  PRIMARY KEY (id),

  UNIQUE INDEX id_UNIQUE      (id         ASC),
  INDEX fk_result_race_idx    (race_id    ASC),
  INDEX fk_results_team_idx   (team_id    ASC),
  INDEX fk_results_car_idx    (car_id     ASC),
  INDEX fk_results_driver_idx (driver_id  ASC),

  CONSTRAINT fk_results_race
    FOREIGN KEY (race_id)
    REFERENCES races (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_results_team
    FOREIGN KEY (team_id)
    REFERENCES teams (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_results_car
    FOREIGN KEY (car_id)
    REFERENCES car_numbers (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_results_driver
    FOREIGN KEY (driver_id)
    REFERENCES drivers (id)
    ON DELETE CASCADE
    ON UPDATE RESTRICT
)
ENGINE = InnoDB
COMMENT = 'Driver results per race';
