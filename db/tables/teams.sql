CREATE TABLE IF NOT EXISTS teams (
  id      INT         NOT NULL AUTO_INCREMENT,
  name    VARCHAR(32) NOT NULL,
  country CHAR(3)     NOT NULL,

  PRIMARY KEY (id)
)
ENGINE = InnoDB;
