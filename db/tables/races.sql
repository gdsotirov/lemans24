CREATE TABLE IF NOT EXISTS races (
  id                  INT           NOT NULL,
  circuit_id          INT           NOT NULL,
  event_date          DATE          NOT NULL,
  start_time          TIME          NOT NULL,
  cancelled           TINYINT       NOT NULL,
  cancellation_reason VARCHAR(128)  NULL,
  distance_km         DECIMAL(10,3) NULL,
  distance_mi         DECIMAL(10,3) GENERATED ALWAYS AS (distance_km*0.621371192) VIRTUAL,
  laps                DECIMAL(7,3)  NOT NULL COMMENT 'Number of laps',
  avg_speed_kmh       DECIMAL(5,2)  GENERATED ALWAYS AS (distance_km/24),
  avg_speed_mph       DECIMAL(5,2)  GENERATED ALWAYS AS (avg_speed_kmh*0.621371192) VIRTUAL,

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
