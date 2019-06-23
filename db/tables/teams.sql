CREATE TABLE IF NOT EXISTS teams (
  id              INT         NOT NULL AUTO_INCREMENT,
  title           VARCHAR(64) NOT NULL,
  country         CHAR(4)     NULL,
  private_entrant TINYINT     NULL,

  PRIMARY KEY (id),

  UNIQUE INDEX idx_team_unq (title ASC, country ASC)
)
ENGINE = InnoDB
COMMENT = 'Teams register';
