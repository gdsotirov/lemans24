CREATE OR REPLACE VIEW AllDriversResults AS
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
             WHEN RES.pos =
               (SELECT MIN(pos_to_num(IR.pos)) /* best class position */
                  FROM results     IR,
                       car_numbers ICN,
                       cars        IC
                 WHERE IR.car_id  = ICN.id
                   AND ICN.car_id  = IC.id
                   AND IR.pos NOT IN ('DNA', 'DNF', 'DNP', 'DNQ', 'DNS', 'DSQ', 'NC', 'RES')
                   AND IR.race_id   = R.id
                   AND IC.car_class = C.car_class
               )
             THEN 1
             ELSE 0
           END
          )                                           AS ClassWins,
       GROUP_CONCAT(
           CASE
             WHEN RES.pos =
               (SELECT MIN(pos_to_num(IR.pos)) /* best class position */
                  FROM results     IR,
                       car_numbers ICN,
                       cars        IC
                 WHERE IR.car_id  = ICN.id
                   AND ICN.car_id  = IC.id
                   AND IR.pos NOT IN ('DNA', 'DNF', 'DNP', 'DNQ', 'DNS', 'DSQ', 'NC', 'RES')
                   AND IR.race_id   = R.id
                   AND IC.car_class = C.car_class
               )
             THEN CONCAT(R.id, ' (', C.car_class, ')')
             ELSE NULL
           END
           ORDER BY R.id SEPARATOR ', ')              AS ClassWinYears
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
   AND RES.pos NOT IN ('DNA', 'DNP', 'DNQ', 'DNS', 'RES')
 GROUP BY D.id, D.country
 ORDER BY `Name`;

