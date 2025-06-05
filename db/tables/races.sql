CREATE TABLE IF NOT EXISTS races (
  id                  INT           NOT NULL,
  circuit_id          INT           NOT NULL,
  event_date          DATE          NOT NULL,
  start_time          TIME          NOT NULL,
  cancelled           TINYINT       NOT NULL DEFAULT 0,
  cancellation_reason VARCHAR(128)  NULL,
  distance_km         DECIMAL(10,3) NULL COMMENT 'Total distance covered in kilometers',
  laps                DECIMAL(3,0)  NULL COMMENT 'Number of laps completed',
  distance_mi         DECIMAL(10,3) GENERATED ALWAYS AS (ROUND(distance_km   * 0.621371192, 3)) VIRTUAL,
  avg_speed_kmh       DECIMAL(6,3)  GENERATED ALWAYS AS (ROUND(distance_km   / 24         , 3)) VIRTUAL,
  avg_speed_mph       DECIMAL(6,3)  GENERATED ALWAYS AS (ROUND(avg_speed_kmh * 0.621371192, 3)) VIRTUAL,

  PRIMARY KEY (id),

  INDEX fk_race_circuit_idx (circuit_id ASC),

  CONSTRAINT fk_race_circuit
    FOREIGN KEY (circuit_id)
    REFERENCES circuits (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE = InnoDB
COMMENT = 'Races register';
