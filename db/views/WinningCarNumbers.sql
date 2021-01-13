CREATE OR REPLACE VIEW WinningCarNumbers AS
SELECT CN.nbr                                                     AS `Number`,
       GROUP_CONCAT(R.id ORDER BY R.id SEPARATOR ', ')            AS Years,
       ROUND((COUNT(*) / (SELECT COUNT(*) FROM races)) * 100, 2)  AS Percent
  FROM races R
       INNER JOIN results    RES  ON RES.race_id = R.id
       INNER JOIN car_numbers CN  ON CN.id = RES.car_id AND CN.race_id = R.id
 WHERE RES.pos = 1
GROUP BY CN.nbr
ORDER BY CN.nbr ASC;

