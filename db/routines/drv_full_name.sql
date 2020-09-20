DELIMITER //

CREATE FUNCTION drv_full_name(title     VARCHAR(16),
                              fname     VARCHAR(32),
                              lname     VARCHAR(32),
                              nickname  VARCHAR(32),
                              nm_suffix VARCHAR(4))
  RETURNS VARCHAR(64) NO SQL
BEGIN
  DECLARE full_name VARCHAR(64) DEFAULT '';

  /* first add royal title in front if title with name */
  IF title NOT LIKE 'Baron %' AND
     title NOT LIKE 'Earl %'  AND
     title NOT LIKE 'Lord %'
  THEN
    SET full_name := CONCAT(full_name, title, ' ');
  END IF;

  /* then add first name if known */
  IF fname IS NOT NULL THEN
    SET full_name := CONCAT(full_name, fname, ' ');
  END IF;

  /* then add nickname if any */
  IF nickname IS NOT NULL THEN
    SET full_name := CONCAT(full_name, '"', nickname, '" ');
  END IF;

  /* then add last name */
  SET full_name := CONCAT(full_name, lname);

  /* then add title after name */
  IF title LIKE 'Baron %' OR
     title LIKE 'Earl %'  OR
     title LIKE 'Lord %'
  THEN
    SET full_name := CONCAT(full_name, ', ', title); 
  END IF;

  /* finally add name suffix if any */
  IF nm_suffix IS NOT NULL THEN
    SET full_name := CONCAT(full_name, ' ', nm_suffix);
  END IF;

  RETURN full_name;
END //

DELIMITER ;

