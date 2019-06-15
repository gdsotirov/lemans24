CREATE TABLE IF NOT EXISTS cars (
  id          INT         NOT NULL AUTO_INCREMENT,
  car_class   VARCHAR(12) NULL,
  car_chassis VARCHAR(64) NOT NULL,
  car_engine  VARCHAR(64) NULL,

  PRIMARY KEY (id)

  UNIQUE INDEX idx_car_unq (car_class ASC, car_chassis ASC, car_engine ASC)
)
ENGINE = InnoDB
COMMENT = 'Cars register';
