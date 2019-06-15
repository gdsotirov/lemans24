CREATE TABLE IF NOT EXISTS team_results (
  team_id   INT NOT NULL,
  result_id INT NOT NULL,

  PRIMARY KEY (team_id, result_id),

  INDEX fk_tm_res_res_idx (result_id ASC),

  CONSTRAINT fk_tm_res_team
    FOREIGN KEY (team_id)
    REFERENCES teams (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_tm_res_res
    FOREIGN KEY (result_id)
    REFERENCES results (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE = InnoDB
COMMENT = 'Connect teams to results';
