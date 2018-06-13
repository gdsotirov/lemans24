CREATE TABLE IF NOT EXISTS races (
  id            INT           NOT NULL,
  circuit_id    INT           NOT NULL,
  event_date    DATE          NOT NULL,
  distance_mi   DECIMAL(10,3) NULL,
  distance_km   DECIMAL(10,3) NULL,
  avg_speed_mph DECIMAL(5,2)  NULL,
  avg_speed_kmh DECIMAL(5,2)  NULL,

  PRIMARY KEY (id),

  UNIQUE INDEX id_UNIQUE (id ASC),
  INDEX fk_race_circuit_idx (circuit_id ASC),

  CONSTRAINT fk_race_circuit
    FOREIGN KEY (circuit_id)
    REFERENCES circuits (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE = InnoDB
COMMENT = 'Races register';
