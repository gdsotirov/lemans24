CREATE TABLE IF NOT EXISTS drivers (
  id      INT         NOT NULL AUTO_INCREMENT,
  fname   VARCHAR(32) NOT NULL,
  lname   VARCHAR(32) NOT NULL,
  born    DATE        NULL,
  country CHAR(3)     NULL,

  PRIMARY KEY (id),

  UNIQUE INDEX id_UNIQUE (id ASC)
)
ENGINE = InnoDB
COMMENT = 'Drivers register';
