CREATE TABLE IF NOT EXISTS drivers (
  id        INT             NOT NULL AUTO_INCREMENT,
  title     VARCHAR(16)     NULL COMMENT 'Royal, military or academic title',
  fname     VARCHAR(32)     NULL,
  lname     VARCHAR(32)     NOT NULL,
  nickname  VARCHAR(32)     NULL,
  nm_suffix VARCHAR(4)      NULL COMMENT 'Name suffix (e.g. Jr., Sr., III)',
  full_name VARCHAR(64)     GENERATED ALWAYS AS (
                              /* TODO: Call drv_full_name here when possible */
                              CONCAT(CASE WHEN title NOT LIKE 'Baron %' AND
                                               title NOT LIKE 'Earl %'  AND
                                               title NOT LIKE 'Lord %'
                                          THEN CONCAT(title, ' ') ELSE ''  END, /* title in front */
                                     CASE WHEN fname     IS NULL THEN ''
                                          ELSE CONCAT(fname, ' ')          END, /* first name if known */
                                     CASE WHEN nickname  IS NULL THEN ''
                                          ELSE CONCAT('"', nickname, '" ') END, /* nickname if any */
                                     lname,                                     /* last name */
                                     CASE WHEN title LIKE 'Baron %' OR
                                               title LIKE 'Earl %'  OR
                                               title LIKE 'Lord %'
                                          THEN CONCAT(', ', title) ELSE '' END, /* title after name */
                                     CASE WHEN nm_suffix IS NULL THEN ''
                                          ELSE CONCAT(' ', nm_suffix)      END  /* name suffix if any */
                                    )
                            )
                            VIRTUAL
                            COMMENT 'Driver full name including title, names, nickname and suffix',
  sex       ENUM('M', 'F')  NULL,
  born      DATE            NULL,
  country   CHAR(4)         NOT NULL,

  PRIMARY KEY (id),

  UNIQUE INDEX idx_driver_unq (lname ASC, sex ASC, country ASC, fname ASC, nickname ASC, title ASC, nm_suffix ASC),
  INDEX idx_driver_sex (sex ASC),
  FULLTEXT INDEX idx_driver_full (title, fname, lname, nickname, nm_suffix)
)
ENGINE = InnoDB
COMMENT = 'Drivers register';

