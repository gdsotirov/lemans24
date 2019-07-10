CREATE TABLE IF NOT EXISTS results (
  id          INT           NOT NULL AUTO_INCREMENT,
  race_id     INT           NOT NULL,
  car_id      INT           NOT NULL,
  pos         VARCHAR(3)    NOT NULL,
  laps        INT           NULL,
  distance    DECIMAL(8,3)  NULL,
  racing_time TIME(3)       NULL,
  reason      VARCHAR(128)  NULL,

  PRIMARY KEY (id),

  INDEX fk_result_race_idx    (race_id ASC),
  INDEX fk_results_car_idx    (car_id  ASC),
  INDEX idx_results_pos       (pos     ASC),

  CONSTRAINT fk_results_race
    FOREIGN KEY (race_id)
    REFERENCES races (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_results_car
    FOREIGN KEY (car_id)
    REFERENCES car_numbers (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE = InnoDB
COMMENT = 'Driver results per race';
