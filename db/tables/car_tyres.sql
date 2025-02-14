CREATE TABLE IF NOT EXISTS car_tyres (
  car_id  INT     NOT NULL,
  tyre_id CHAR(2) NOT NULL,

  PRIMARY KEY (car_id, tyre_id),

  INDEX fk_car_tyres_tyre_idx (tyre_id ASC),

  CONSTRAINT fk_car_tyres_car
    FOREIGN KEY (car_id)
    REFERENCES car_numbers (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_car_tyres_tyre
    FOREIGN KEY (tyre_id)
    REFERENCES tyres (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE = InnoDB
COMMENT = 'Defines the tyres of each car';
