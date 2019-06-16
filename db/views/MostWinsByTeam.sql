CREATE OR REPLACE VIEW MostWinsByTeam AS
SELECT TM.title                                        Team,
       COUNT(*)                                        Wins,
       GROUP_CONCAT(R.id ORDER BY R.id SEPARATOR ', ') Years
  FROM races        R,
       results      RES,
       team_results TMR,
       teams        TM
 WHERE RES.race_id   = R.id
   AND TMR.result_id = RES.id
   AND TMR.team_id   = TM.id
   AND RES.pos = 1
 GROUP BY TM.id
 ORDER BY Wins   DESC,
          Years  ASC,
          Team ASC;
