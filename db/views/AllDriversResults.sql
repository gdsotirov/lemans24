CREATE OR REPLACE VIEW AllDriversResults AS
WITH ranks AS (
SELECT RES.id AS id,
       DENSE_RANK() OVER (PARTITION BY RES.race_id, C.car_class
                              ORDER BY RES.race_id, pos_to_num(RES.pos) ASC) AS InClass
  FROM results     RES,
       car_numbers CN,
       cars        C
 WHERE RES.car_id   = CN.id
   AND CN.car_id    = C.id
   AND CN.race_id   = RES.race_id
 ORDER BY RES.race_id, pos_to_num(pos)
)
SELECT D.full_name                                     AS `Name`,
       CASE D.sex
         WHEN 'F' THEN 'Female'
         ELSE 'Male'
       END                                             AS Sex,
       D.country                                       AS Country,
       GROUP_CONCAT(R.id ORDER BY R.id SEPARATOR ', ') AS Years,
       COUNT(*)                                        AS `Starts`,
       num_to_pos(MIN(pos_to_num(RES.pos)))            AS BestFinish,
       SUM(CASE WHEN RES.pos = 1 THEN 1 ELSE 0 END)    AS OvWins,
       SUM(CASE WHEN RES.pos BETWEEN 1 AND 10
                THEN 1 ELSE 0 END)                     AS OvTop10,
       GROUP_CONCAT(CASE WHEN RES.pos BETWEEN 1 AND 10
                         THEN CONCAT(R.id, ' (', RES.pos, ')')
                         ELSE NULL
                    END
                    ORDER BY R.id SEPARATOR ', ')      AS OvTop10Years,
       SUM(CASE
            WHEN 1 = (SELECT InClass FROM ranks WHERE id = RES.id) THEN 1
            ELSE 0
           END)                                        AS ClassWins,
       GROUP_CONCAT(
           CASE
            WHEN 1 = (SELECT InClass FROM ranks WHERE id = RES.id)
              THEN CONCAT(R.id, ' (', C.car_class, ')')
            ELSE NULL
           END
           ORDER BY R.id SEPARATOR ', ')               AS ClassWinYears
  FROM drivers        D,
       driver_results DR,
       races          R,
       results        RES,
       car_numbers    CN,
       cars           C
 WHERE DR.driver_id = D.id
   AND DR.result_id = RES.id
   AND RES.race_id  = R.id
   AND RES.car_id   = CN.id
   AND CN.car_id    = C.id
   AND CN.race_id   = R.id
   AND RES.pos NOT IN ('DNA', 'DNP', 'DNQ', 'DNS', 'RES')
 GROUP BY D.id, D.country
 ORDER BY `Name`;

