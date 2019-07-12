CREATE TABLE IF NOT EXISTS drivers (
  id        INT             NOT NULL AUTO_INCREMENT,
  title     VARCHAR(16)     NULL COMMENT 'Royal, military or academic title',
  fname     VARCHAR(32)     NULL,
  lname     VARCHAR(32)     NOT NULL,
  nickname  VARCHAR(32)     NULL,
  nm_suffix VARCHAR(4)      NULL COMMENT 'Name suffix (e.g. Jr., Sr., III)',
  sex       ENUM('M', 'F')  NULL,
  born      DATE            NULL,
  country   CHAR(4)         NOT NULL,

  PRIMARY KEY (id),

  UNIQUE INDEX idx_driver_unq (fname ASC, lname ASC, country ASC, nm_suffix ASC)
  INDEX idx_driver_sex (sex ASC)
)
ENGINE = InnoDB
COMMENT = 'Drivers register';
