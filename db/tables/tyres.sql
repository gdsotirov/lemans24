CREATE TABLE IF NOT EXISTS tyres (
  id    CHAR(2)     NOT NULL,
  brand VARCHAR(16) NOT NULL,

  PRIMARY KEY (id)
)
ENGINE = InnoDB
COMMENT = 'Tyre brands register';
