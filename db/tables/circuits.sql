CREATE TABLE IF NOT EXISTS circuits (
  id          INT           NOT NULL AUTO_INCREMENT,
  name        VARCHAR(45)   NOT NULL,
  since       DATE          NOT NULL,
  length_km   DECIMAL(5,3)  NULL,
  length_mi   DECIMAL(5,3)  GENERATED ALWAYS AS (ROUND(length_km * 0.621371192, 3)) VIRTUAL,
  layout      LONGBLOB      NULL,
  changes     VARCHAR(128)  NULL,

  PRIMARY KEY (id)
)
ENGINE = InnoDB
COMMENT = 'Circutis register';
