CREATE TABLE IF NOT EXISTS car_numbers (
  id      INT NOT NULL AUTO_INCREMENT,
  race_id INT NOT NULL,
  car_id  INT NOT NULL,
  nbr     INT NULL,

  PRIMARY KEY (id),

  INDEX fk_car_nums_race_idx  (race_id  ASC),
  INDEX fk_car_nums_car_idx   (car_id   ASC),

  CONSTRAINT fk_car_nums_race
    FOREIGN KEY (race_id)
    REFERENCES races (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_car_nums_car
    FOREIGN KEY (car_id)
    REFERENCES cars (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE = InnoDB;
