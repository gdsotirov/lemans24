CREATE TABLE IF NOT EXISTS teams (
  id      INT         NOT NULL AUTO_INCREMENT,
  title   VARCHAR(64) NOT NULL,
  country CHAR(3)     NULL,

  PRIMARY KEY (id)
)
ENGINE = InnoDB
COMMENT = 'Teams register';
