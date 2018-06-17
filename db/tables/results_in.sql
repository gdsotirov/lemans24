CREATE TABLE results_in (
  race_yr       INT           NOT NULL  COMMENT 'Race year',
  pos           VARCHAR(3)    NOT NULL  COMMENT 'Position - either number or NC (not classified), DNF (do not finish) or DSQ (disqualified)',
  car_class     DECIMAL(3,2)  NOT NULL  COMMENT 'Car class (litres or named)',
  car_nbr       INT           NOT NULL  COMMENT 'Car number',
  team_cntry    VARCHAR(16)   NOT NULL  COMMENT 'Team country (ISO 3166 3 characters code)',
  team_name     VARCHAR(128)  NOT NULL  COMMENT 'Team name',
  drivers_cntry VARCHAR(16)   NOT NULL  COMMENT 'Drivers countries (ISO 3166 3 characters code) separated',
  drivers_name  VARCHAR(256)  NOT NULL  COMMENT 'Drivers names',
  chassis       VARCHAR(64)   NOT NULL  COMMENT 'Chassis name',
  engine        VARCHAR(64)   NOT NULL  COMMENT 'Engine name',
  tyre          VARCHAR(16)   NULL      COMMENT 'Tyres manufacturer',
  laps          INT           NULL      COMMENT 'Laps driven',
  distance      DECIMAL(8,3)  NULL      COMMENT 'Distance passed',
  racing_time   TIME          NULL      COMMENT 'Time',
  reason        VARCHAR(45)   NULL      COMMENT 'Reason for NC, DNF, DSQ',
  processed     TINYINT       NOT NULL  DEFAULT 0 COMMENT 'Record processed or not'
)
ENGINE = InnoDB
COMMENT = 'Table for results input';
