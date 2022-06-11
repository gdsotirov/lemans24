CREATE OR REPLACE VIEW MostWinsByCar AS
SELECT CASE /* adjust car names, commented are to match Wikipedia, see
             * https://en.wikipedia.org/wiki/List_of_24_hours_of_Le_Mans_records */
         WHEN CAR.car_chassis LIKE 'Alfa Romeo 8C 2300%'      THEN 'Alfa Romeo 8C 2300'
         WHEN CAR.car_chassis LIKE 'Audi R18%'                THEN 'Audi R18'
       /*WHEN CAR.car_chassis LIKE 'Bentley 3 Litre%'         THEN 'Bentley 3 Litre'*/
         WHEN CAR.car_chassis LIKE 'Bentley Speed Six%'       THEN 'Bentley Speed Six'
         WHEN CAR.car_chassis LIKE 'Bugatti Type 57%'         THEN 'Bugatti Type 57'
         WHEN CAR.car_chassis LIKE 'Ferrari 250 TR%'          THEN 'Ferrari 250 TR'
       /*WHEN CAR.car_chassis LIKE 'Ferrari 275%'             THEN 'Ferrari 275'*/
         WHEN CAR.car_chassis LIKE 'Ford GT40%'               THEN 'Ford GT40'
         WHEN CAR.car_chassis LIKE 'Ford Mk IV'               THEN 'Ford GT40'
         WHEN CAR.car_chassis LIKE 'Lorraine-Dietrich B3-6%'  THEN 'Lorraine-Dietrich B3-6'
         WHEN CAR.car_chassis LIKE 'Matra-Simca MS670%'       THEN 'Matra-Simca MS670'
         WHEN CAR.car_chassis LIKE 'Peugeot 905%'             THEN 'Peugeot 905'
         WHEN CAR.car_chassis LIKE 'Porsche 936%'             THEN 'Porsche 936'
         WHEN CAR.car_chassis LIKE 'Porsche 956%'             THEN 'Porsche 956'
         WHEN CAR.car_chassis LIKE '%Porsche WSC-95%'         THEN 'Porsche WSC-95'
         ELSE CAR.car_chassis
       END                                              AS Car,
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
 GROUP BY Car
 ORDER BY Wins  DESC,
          Years ASC,
          Car   ASC;

