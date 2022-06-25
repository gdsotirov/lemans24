DELIMITER //

CREATE PROCEDURE process_results()
BEGIN
  /* Input results - table results_in */
  DECLARE res_id            INT;
  DECLARE res_race_yr       INT;
  DECLARE res_pos           VARCHAR(3);
  DECLARE res_car_class     VARCHAR(12);
  DECLARE res_car_nbr       VARCHAR(3);
  DECLARE res_team_cntry    VARCHAR(16);
  DECLARE res_team_name     VARCHAR(128);
  DECLARE res_drivers_cntry VARCHAR(32);
  DECLARE res_drivers_name  VARCHAR(256);
  DECLARE res_car_chassis   VARCHAR(64);
  DECLARE res_car_engine    VARCHAR(64);
  DECLARE res_car_tyres     VARCHAR(16);
  DECLARE res_laps          INT;
  DECLARE res_distance      DECIMAL(8,3);
  DECLARE res_racing_time   TIME(3);
  DECLARE res_reason        VARCHAR(128);

  /* Car data */
  DECLARE new_car_id   INT;
  DECLARE new_carnb_id INT;

  /* Result */
  DECLARE new_res_id INT;

  /* Team data */
  DECLARE new_team_id    INT;
  DECLARE new_team_name  VARCHAR(64);
  DECLARE new_team_cntry CHAR(4);
  DECLARE new_team_priv  TINYINT;
  DECLARE new_team_ord   INT;

  /* Driver data */
  DECLARE new_driver_id  INT;
  DECLARE new_drv_name   VARCHAR(64);
  DECLARE new_drv_title  VARCHAR(16);
  DECLARE new_drv_fname  VARCHAR(32);
  DECLARE new_drv_lname  VARCHAR(32);
  DECLARE new_drv_nick   VARCHAR(32);
  DECLARE new_drv_nm_sfx VARCHAR(4);
  DECLARE new_drv_sex    CHAR(1);
  DECLARE new_drv_cntry  CHAR(4);
  DECLARE new_drv_ord    INT;

  /* Cursor and handling */
  DECLARE done INT DEFAULT FALSE;
  DECLARE cur_results CURSOR FOR
    SELECT id,
           race_yr,
           pos,
           car_class,
           car_nbr,
           team_cntry,
           team_name,
           drivers_cntry,
           drivers_name,
           car_chassis,
           car_engine,
           car_tyres,
           laps,
           distance,
           racing_time,
           reason
      FROM results_in
     WHERE processed IS FALSE;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur_results;

  res_loop: LOOP
    SET new_car_id    = NULL;
    SET new_carnb_id  = NULL;
    SET new_team_id   = NULL;
    SET new_driver_id = NULL;

    FETCH cur_results
     INTO res_id,
          res_race_yr,
          res_pos,
          res_car_class,
          res_car_nbr,
          res_team_cntry,
          res_team_name,
          res_drivers_cntry,
          res_drivers_name,
          res_car_chassis,
          res_car_engine,
          res_car_tyres,
          res_laps,
          res_distance,
          res_racing_time,
          res_reason;

    IF done THEN
      LEAVE res_loop;
    END IF;

    /* Create car */
    IF res_car_class != '' OR res_car_chassis != '' OR res_car_engine != '' THEN
      BEGIN
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET new_car_id = NULL;

        SET res_car_class  = NULLIF(res_car_class, '');
        SET res_car_engine = NULLIF(res_car_engine, '');

        /* Check if car exists */
        SELECT id
          INTO new_car_id
          FROM cars
         WHERE (   (car_class IS NULL AND res_car_class IS NULL)
                OR car_class = res_car_class
               )
           AND car_chassis = res_car_chassis
           AND (   (car_engine IS NULL AND res_car_engine IS NULL)
                OR car_engine  = res_car_engine
               );

        /* else create it */
        IF new_car_id IS NULL THEN
          INSERT INTO cars (car_class, car_chassis, car_engine)
          VALUES (res_car_class, res_car_chassis, res_car_engine);

          SET new_car_id = LAST_INSERT_ID();
        END IF;
      END;
    ELSE /* car not defined */
      SET new_car_id = NULL;
    END IF;

    INSERT INTO car_numbers (race_id, car_id, nbr)
    VALUES (res_race_yr, new_car_id, res_car_nbr);

    SET new_carnb_id = LAST_INSERT_ID();

    /* Car tyres */
    IF res_car_tyres IS NOT NULL THEN
      INSERT INTO car_tyres (car_id, tyre_id)
      SELECT new_carnb_id, id
        FROM tyres
       WHERE brand = res_car_tyres;
    END IF;

    /* Create result */
    INSERT INTO results (race_id, car_id, pos, laps, distance, racing_time, reason)
    VALUES (res_race_yr, new_carnb_id, res_pos, res_laps, res_distance, res_racing_time, res_reason);

    SET new_res_id = LAST_INSERT_ID();

    /* Strip double quotes */
    IF res_team_name LIKE '%"' THEN
      SET res_team_name = REPLACE(SUBSTR(res_team_name, 1, CHAR_LENGTH(res_team_name) - 1), '""', '"');
    END IF;

    /* Process team(s) */
    SET new_team_ord = 0;
    WHILE res_team_name IS NOT NULL DO
      SET new_team_name  = SUBSTRING_INDEX(res_team_name, '|', 1);
      SET new_team_cntry = SUBSTRING_INDEX(res_team_cntry, '|', 1);
      SET new_team_priv = FALSE;
      SET new_team_ord   = new_team_ord + 1;

      /* Detect private entrants */
      IF new_team_name LIKE '% (private entrant)' THEN
        SET new_team_priv = TRUE;
        SET new_team_name = REPLACE(new_team_name, ' (private entrant)', '');
      END IF;

      IF new_team_name != '' THEN
        BEGIN
          DECLARE CONTINUE HANDLER FOR NOT FOUND SET new_team_id = NULL;

          SET new_team_cntry = NULLIF(new_team_cntry, '');

          SELECT id
            INTO new_team_id
            FROM teams
           WHERE title   = new_team_name
             AND (   (country IS NULL AND new_team_cntry IS NULL)
                  OR country = new_team_cntry
                 )
             AND private_entrant = new_team_priv;

          IF new_team_id IS NULL THEN
            INSERT INTO teams (title, country, private_entrant)
            VALUES (new_team_name, new_team_cntry, new_team_priv);

            SET new_team_id = LAST_INSERT_ID();
          END IF;
        END;

        INSERT INTO team_results (team_id, result_id, ord_num)
        VALUES (new_team_id, new_res_id, new_team_ord);
      END IF;

      IF NOT INSTR(res_team_name, '|') THEN
        SET res_team_name  = NULL;
        SET res_team_cntry = NULL;
      ELSE
        SET res_team_name  = SUBSTR(res_team_name , INSTR(res_team_name , '|') + 1);
        SET res_team_cntry = SUBSTR(res_team_cntry, INSTR(res_team_cntry, '|') + 1);
      END IF;
    END WHILE; /* teams */

    /* Strip double quotes */
    IF res_drivers_name LIKE '%"' THEN
      SET res_drivers_name = REPLACE(SUBSTR(res_drivers_name, 1, CHAR_LENGTH(res_drivers_name) - 1), '""', '"');
    END IF;

    /* Process driver(s) */
    SET new_drv_ord = 0;
    WHILE res_drivers_name IS NOT NULL DO
      SET new_drv_title = NULL;
      SET new_drv_name  = SUBSTRING_INDEX(res_drivers_name, '|', 1);
      SET new_drv_nick  = NULL;
      SET new_drv_nm_sfx = NULL;
      SET new_drv_cntry = SUBSTRING_INDEX(res_drivers_cntry, '|', 1);
      SET new_drv_sex   = 'M';
      SET new_drv_ord   = new_drv_ord + 1;

      /* Detect females */
      IF new_drv_name LIKE 'Mme%'  OR
         new_drv_name LIKE 'Miss%' OR
         new_drv_name LIKE 'Mrs.%'
      THEN
        SET new_drv_sex  = 'F';
        SET new_drv_name = SUBSTR(new_drv_name, INSTR(new_drv_name, ' ') + 1);
      END IF;

      /* Detect titles in front of name */
      IF new_drv_name LIKE 'Baron %'   OR /* Royal titles */
         new_drv_name LIKE 'Comte %'   OR /* Comte = Count */
         new_drv_name LIKE 'Count %'   OR
        (new_drv_name LIKE 'Earl %'
         AND new_drv_name <> 'Earl Bamber') OR /* except Earl Bamber */
         new_drv_name LIKE 'Graf %'    OR
         new_drv_name LIKE 'Lord %'    OR
         new_drv_name LIKE 'Marquis %' OR
         new_drv_name LIKE 'Prince %'  OR
         new_drv_name LIKE 'Sir %'     OR
         new_drv_name LIKE 'Capt.%'    OR /* Military titles, Captain */
         new_drv_name LIKE 'Colonel %' OR
         new_drv_name LIKE 'Lt. %'     OR /* Lieutenant */
         new_drv_name LIKE 'Maj %'     OR /* Major */
         new_drv_name LIKE 'Dr.%'         /* Academic titles, Doctor */
      THEN
        IF new_drv_name LIKE 'Lt. Cdr.%' THEN /* Lieutenant commander */
          SET new_drv_title = SUBSTR(new_drv_name, 1, 8);
          SET new_drv_name = SUBSTR(new_drv_name, 10);
        ELSE
          SET new_drv_title = SUBSTR(new_drv_name, 1, INSTR(new_drv_name, ' ') - 1);
          SET new_drv_name = SUBSTR(new_drv_name, INSTR(new_drv_name, ' ') + 1);
	    END IF;
      END IF;

      /* Detect titles after name */
      IF new_drv_name LIKE '%, Baron%' OR
         new_drv_name LIKE '%, Lord%'  OR
         new_drv_name LIKE '%, Earl%'
      THEN
        SET new_drv_title = SUBSTR(new_drv_name, INSTR(new_drv_name, ',') + 2);
        SET new_drv_name = SUBSTR(new_drv_name, 1, INSTR(new_drv_name, ',') - 1);
      END IF;

      /* Detect name suffixes */
      IF new_drv_name LIKE '% Jr.' OR
         new_drv_name LIKE '% Sr.' OR
         new_drv_name LIKE '% III' /* third */
      THEN
        SET new_drv_nm_sfx = SUBSTRING_INDEX(new_drv_name, ' ', -1);
        SET new_drv_name = SUBSTR(new_drv_name, 1, LENGTH(new_drv_name) - 4);
      END IF;

      IF new_drv_name != '' AND new_drv_cntry != '' THEN
      BEGIN
        DECLARE tmp_drv_name   VARCHAR(64) DEFAULT new_drv_name;

        /* Extract nickname */
        IF new_drv_name LIKE '%"%"%' THEN   /* name with two double quotes */
          BEGIN
            DECLARE fst_qt_idx INTEGER DEFAULT INSTR(new_drv_name, '"');
            DECLARE snd_qt_idx INTEGER DEFAULT LOCATE('"', new_drv_name, fst_qt_idx + 1);

            SET tmp_drv_name = SUBSTRING(new_drv_name, 1, fst_qt_idx - 1);
            SET tmp_drv_name = CONCAT(tmp_drv_name, TRIM(SUBSTRING(new_drv_name, snd_qt_idx + 1)));
            SET new_drv_nick = SUBSTRING(new_drv_name, fst_qt_idx + 1, snd_qt_idx - fst_qt_idx - 1);
          END;
        END IF;

        IF new_drv_name LIKE '%''%''%' THEN /* name with two single quotes */
          BEGIN
            DECLARE fst_qt_idx INTEGER DEFAULT INSTR(new_drv_name, '''');
            DECLARE snd_qt_idx INTEGER DEFAULT LOCATE('''', new_drv_name, fst_qt_idx + 1);

            SET tmp_drv_name = SUBSTRING(new_drv_name, 1, fst_qt_idx - 1);
            SET tmp_drv_name = CONCAT(tmp_drv_name, TRIM(SUBSTRING(new_drv_name, snd_qt_idx + 1)));
            SET new_drv_nick = SUBSTRING(new_drv_name, fst_qt_idx + 1, snd_qt_idx - fst_qt_idx - 1);
          END;
        END IF;

        /* clean braces in name and trim */
        SET new_drv_name = REPLACE(tmp_drv_name, '(', '');
        SET new_drv_name = REPLACE(new_drv_name, ')', '');
        SET new_drv_name = TRIM(new_drv_name);

        /* Split driver name - first name to the first space */
        SET new_drv_fname = SUBSTRING_INDEX(new_drv_name, ' ', 1);
        /* last name everything else */
        SET new_drv_lname = SUBSTR(new_drv_name, INSTR(new_drv_name, ' ') + 1);

        IF new_drv_fname = new_drv_lname THEN
          SET new_drv_fname = NULL;
        END IF;

        IF new_drv_fname = 'f.n.u.' OR new_drv_fname = '' THEN /* first name unknown */
          SET new_drv_fname = NULL;
        END IF;

        BEGIN
          DECLARE CONTINUE HANDLER FOR NOT FOUND SET new_driver_id = NULL;

          /* Query shoud be unique or non-unique index lookup on idx_driver_unq */
          SELECT id
            INTO new_driver_id
            FROM drivers
           WHERE (   (title IS NULL AND new_drv_title IS NULL) /* no title */
                  OR title = new_drv_title
                 )
                 /* if first name unknown */
             AND (   (fname IS NULL AND new_drv_fname IS NULL)
                  OR fname = new_drv_fname
                 )
             AND lname   = new_drv_lname
                 /* if no nickname */
             AND (   (nickname IS NULL AND new_drv_nick IS NULL )
                  OR nickname = new_drv_nick
                 )
                 /* if no name suffix */
             AND (   (nm_suffix IS NULL AND new_drv_nm_sfx IS NULL )
                  OR nm_suffix = new_drv_nm_sfx
                 )
             AND sex     = new_drv_sex
             AND country = new_drv_cntry;

          IF new_driver_id IS NULL THEN
            INSERT INTO drivers
              (title,
               fname, lname, nm_suffix, nickname,
               sex, country)
            VALUES
              (new_drv_title,
               new_drv_fname, new_drv_lname, new_drv_nm_sfx, new_drv_nick,
               new_drv_sex, new_drv_cntry);

            SET new_driver_id = LAST_INSERT_ID();
          END IF;
        END;
      END;
      END IF;

      IF new_driver_id IS NOT NULL THEN
        INSERT INTO driver_results (driver_id, result_id, ord_num)
        VALUES (new_driver_id, new_res_id, new_drv_ord);
      END IF;

      IF NOT INSTR(res_drivers_name, '|') THEN
        SET res_drivers_name  = NULL;
        SET res_drivers_cntry = NULL;
      ELSE
        SET res_drivers_name  = SUBSTR(res_drivers_name , INSTR(res_drivers_name , '|') + 1);
        SET res_drivers_cntry = SUBSTR(res_drivers_cntry, INSTR(res_drivers_cntry, '|') + 1);
      END IF;
    END WHILE; /* drivers */

    /* Mark record processed */
    UPDATE results_in
       SET processed = TRUE
     WHERE id = res_id;
  END LOOP; /* res_loop */

  CLOSE cur_results;
END //

DELIMITER ;
