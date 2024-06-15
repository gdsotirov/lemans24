CREATE OR REPLACE VIEW MostWinsByNation AS
SELECT D.country                                        AS Nationality,
       COUNT(*)                                         AS Wins,
       COUNT(DISTINCT D.id)                             AS Drivers,
       MIN(R.id)                                        AS FirstWin,
       MAX(R.id)                                        AS LastWin,
       GROUP_CONCAT(R.id ORDER BY R.id SEPARATOR ', ')  AS Years
  FROM races          R,
       results        RES,
       driver_results DR,
       drivers        D
 WHERE RES.race_id  = R.id
   AND DR.result_id = RES.id
   AND DR.driver_id = D.id
   AND RES.pos      = 1
 GROUP BY D.country
 ORDER BY Wins        DESC,
          Years       ASC,
          Nationality ASC;

