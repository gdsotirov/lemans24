CREATE OR REPLACE VIEW MostWinsByTeamWAppr AS
SELECT CASE /* some approximations */
         WHEN TM.title LIKE '%Joest%'                     THEN 'Joest Racing'
         WHEN TM.title LIKE '%Porsche%'
          AND TM.title NOT LIKE 'Martini Racing Porsche%' THEN 'Porsche'
         WHEN TM.title LIKE '%Ferrari%'                   THEN 'Ferrari'
         WHEN TM.title LIKE '%Jaguar%'                    THEN 'Jaguar'
         WHEN TM.title LIKE '%Peugeot%'                   THEN 'Peugeot'
         ELSE TM.title
       END                                              AS Team,
       COUNT(*)                                         AS Wins,
       GROUP_CONCAT(R.id ORDER BY R.id SEPARATOR ', ')  AS Years
  FROM races        R,
       results      RES,
       team_results TMR,
       teams        TM
 WHERE RES.race_id   = R.id
   AND TMR.result_id = RES.id
   AND TMR.team_id   = TM.id
   AND RES.pos       = 1
 GROUP BY Team
 ORDER BY Wins  DESC,
          Years ASC,
          Team  ASC;

