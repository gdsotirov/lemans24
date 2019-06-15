CREATE TABLE IF NOT EXISTS driver_results (
  driver_id INT NOT NULL,
  result_id INT NOT NULL,

  PRIMARY KEY (driver_id, result_id),

  INDEX fk_driver_results_result_idx (result_id ASC),

  CONSTRAINT fk_drv_res_driver
    FOREIGN KEY (driver_id)
    REFERENCES drivers (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_drv_res_result
    FOREIGN KEY (result_id)
    REFERENCES results (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE = InnoDB
COMMENT = 'Connect drivers to results';
