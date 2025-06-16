CREATE OR REPLACE VIEW FemaleDriversByCountry AS
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
SELECT D.country                                       AS Country,
       MIN(R.id)                                       AS `First`,
       COUNT(DISTINCT D.id)                            AS Drivers,
       COUNT(*)                                        AS `Starts`,
       SUM(CASE WHEN RES.pos BETWEEN 1 AND 10
                THEN 1 ELSE 0 END)                     AS Top10,
       GROUP_CONCAT(DISTINCT
                    CASE WHEN RES.pos BETWEEN 1 AND 10
                         THEN CONCAT(R.id, ' (', RES.pos, ')')
                         ELSE NULL
                    END
                    ORDER BY R.id SEPARATOR ', ')      AS Top10Years,
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
   AND D.sex        = 'F'
   AND RES.pos NOT IN ('DNA', 'DNP', 'DNQ', 'DNS', 'RES')
 GROUP BY D.country
 ORDER BY COUNT(DISTINCT D.id)  DESC,
          `First`               ASC;

