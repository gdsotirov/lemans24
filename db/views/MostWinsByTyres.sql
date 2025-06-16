CREATE OR REPLACE VIEW MostWinsByTyres AS
SELECT T.brand                                          AS TyreBrand,
       COUNT(*)                                         AS Wins,
       MIN(R.id)                                        AS FirstWin,
       MAX(R.id)                                        AS LastWin,
       GROUP_CONCAT(R.id ORDER BY R.id SEPARATOR ', ')  AS Years
  FROM races        R,
       results      RES,
       car_numbers  CN,
       cars         C,
       car_tyres    CT,
       tyres        T
 WHERE RES.race_id   = R.id
   AND RES.car_id    = CN.id
   AND CN.race_id    = R.id
   AND CN.car_id     = C.id
   AND CT.car_id     = CN.id
   AND CT.tyre_id    = T.id
   AND RES.pos       = 1
 GROUP BY TyreBrand
 ORDER BY Wins  DESC,
          Years ASC;

