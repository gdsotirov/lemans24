CREATE TABLE IF NOT EXISTS drivers (
  id      INT         NOT NULL AUTO_INCREMENT,
  fname   VARCHAR(32) NOT NULL,
  lname   VARCHAR(32) NOT NULL,
  born    DATE        NULL,
  country CHAR(4)     NOT NULL,

  PRIMARY KEY (id),

  UNIQUE INDEX idx_driver_unq (fname ASC, lname ASC, country ASC)
)
ENGINE = InnoDB
COMMENT = 'Drivers register';
