CREATE TABLE IF NOT EXISTS cars (
  id        INT         NOT NULL AUTO_INCREMENT,
  car_class VARCHAR(12) NOT NULL,
  chasis    VARCHAR(64) NOT NULL,
  engine    VARCHAR(64) NOT NULL,

  PRIMARY KEY (id)
)
ENGINE = InnoDB;
