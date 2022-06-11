CREATE OR REPLACE VIEW MostWinsByConstructor AS
SELECT CASE /* adjust engine constructor names */
         WHEN CAR.car_engine LIKE 'Alfa Romeo%'         THEN 'Alfa Romeo'
         WHEN CAR.car_engine LIKE 'Aston Martin%'       THEN 'Aston Martin'
         WHEN CAR.car_engine LIKE 'Chenard et Walcker%' THEN 'Chenard & Walcker'
         WHEN CAR.car_engine LIKE 'Ford Cosworth%'      THEN 'Ford Cosworth'
         WHEN CAR.car_engine LIKE 'Matra%'              THEN 'Matra-Simca'
         ELSE SUBSTR(CAR.car_engine, 1, INSTR(CAR.car_engine, ' '))
       END                                              AS Constructor,
       COUNT(*)                                         AS Wins,
       MIN(R.id)                                        AS FirstWin,
       MAX(R.id)                                        AS LastWin,
       GROUP_CONCAT(R.id ORDER BY R.id SEPARATOR ', ')  AS Years
  FROM races        R,
       results      RES,
       car_numbers  CN,
       cars         CAR
 WHERE RES.race_id   = R.id
   AND RES.car_id    = CN.id
   AND RES.pos       = 1
   AND CN.race_id    = R.id
   AND CN.car_id     = CAR.id
 GROUP BY Constructor
 ORDER BY Wins        DESC,
          Years       ASC,
          Constructor ASC;

