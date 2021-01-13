CREATE OR REPLACE VIEW DriversWithNickname AS
SELECT CONCAT('"', D.nickname, '"',
              CASE WHEN IFNULL(D.fname, '') = '' AND IFNULL(D.lname, '') = '' THEN ''
              ELSE CONCAT(' (', IFNULL(D.fname, ''), ' ', IFNULL(D.lname, ''), ')')
              END)                                     AS `Name`,
       CASE D.sex
         WHEN 'F' THEN 'Female'
         ELSE 'Male'
       END                                             AS Sex,
       D.country                                       AS Country,
       GROUP_CONCAT(R.id ORDER BY R.id SEPARATOR ', ') AS Years,
       COUNT(*)                                        AS `Starts`,
       num_to_pos(MIN(pos_to_num(RES.pos)))            AS BestFinish
  FROM drivers        D,
       driver_results DR,
       races          R,
       results        RES
 WHERE DR.driver_id = D.id
   AND DR.result_id = RES.id
   AND RES.race_id  = R.id
   AND D.nickname IS NOT NULL
 GROUP BY D.id, D.country
 ORDER BY MIN(R.id) ASC, `Name`;

