CREATE OR REPLACE VIEW FemaleDriversByCntry AS
SELECT D.country                                       "Country",
       MIN(R.id)                                       "First",
       COUNT(DISTINCT D.id)                            "Drivers",
       COUNT(*)                                        "Starts",
       SUM(CASE WHEN RES.pos BETWEEN 1 AND 10
                THEN 1 ELSE 0 END)                     "Top 10",
       GROUP_CONCAT(DISTINCT
                    CASE WHEN RES.pos BETWEEN 1 AND 10
                         THEN CONCAT(R.id, ' (', RES.pos, ')')
                         ELSE NULL
                    END
                    ORDER BY R.id SEPARATOR ', ')      "Top 10 Years",
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
          )                                           "Class Wins",
       GROUP_CONCAT(
           DISTINCT
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
           ORDER BY R.id SEPARATOR ', ')              "Class Win Years"
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
 ORDER BY COUNT(DISTINCT D.id) DESC, `First`;

