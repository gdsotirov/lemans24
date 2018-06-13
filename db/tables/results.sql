CREATE TABLE IF NOT EXISTS results (
  id        INT NOT NULL AUTO_INCREMENT,
  race_id   INT NOT NULL,
  driver_id INT NOT NULL,
  place     INT NOT NULL,

  PRIMARY KEY (id),

  UNIQUE INDEX id_UNIQUE (id ASC),
  INDEX fk_result_race_idx    (race_id ASC),
  INDEX fk_results_driver_idx (driver_id ASC),

  CONSTRAINT fk_results_race
    FOREIGN KEY (race_id)
    REFERENCES races (id)
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
