CREATE OR REPLACE VIEW MostWinsByDriver AS
SELECT CONCAT(IFNULL(D.fname, 'f.n.u.'), ' ', D.lname)  AS Driver,
       COUNT(*)                                         AS Wins,
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
 GROUP BY D.id
 ORDER BY Wins   DESC,
          Years  ASC,
          Driver ASC;

