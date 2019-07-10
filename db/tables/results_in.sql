CREATE TABLE results_in (
  id            INT           NOT NULL  AUTO_INCREMENT, 
  race_yr       INT           NOT NULL  COMMENT 'Race year',
  pos           VARCHAR(3)    NOT NULL  COMMENT 'Position - either number or NC (not classified), DNF (do not finish) or DSQ (disqualified)',
  car_class     VARCHAR(12)   NOT NULL  COMMENT 'Car class (litres or named)',
  car_nbr       INT           NOT NULL  COMMENT 'Car number',
  team_cntry    VARCHAR(16)   NOT NULL  COMMENT 'Team country (ISO 3166 3 characters code)',
  team_name     VARCHAR(128)  NOT NULL  COMMENT 'Team name',
  drivers_cntry VARCHAR(32)   NOT NULL  COMMENT 'Drivers countries (ISO 3166 3 characters code) separated',
  drivers_name  VARCHAR(256)  NOT NULL  COMMENT 'Drivers names',
  car_chassis   VARCHAR(64)   NOT NULL  COMMENT 'Chassis name',
  car_engine    VARCHAR(64)   NOT NULL  COMMENT 'Engine name',
  car_tyres     VARCHAR(16)   NULL      COMMENT 'Tyres manufacturer',
  laps          INT           NULL      COMMENT 'Laps completed',
  distance      DECIMAL(8,3)  NULL      COMMENT 'Distance covered',
  racing_time   TIME(3)       NULL      COMMENT 'Racing time',
  reason        VARCHAR(128)  NULL      COMMENT 'Reason for NC, DNF, DSQ',
  processed     TINYINT       NOT NULL  DEFAULT 0 COMMENT 'Record processed or not',

    PRIMARY KEY (id)
)
ENGINE = InnoDB
COMMENT = 'Table for results input';
