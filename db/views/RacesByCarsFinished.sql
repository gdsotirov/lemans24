CREATE OR REPLACE VIEW RacesByCarsFinished AS
SELECT race_id                                                                       AS `Year`,
       SUM(CASE WHEN pos NOT REGEXP '^(DNA|DNP|DNQ|DNS|RES)$'     THEN 1 ELSE 0 END) AS Started,
       SUM(CASE WHEN pos NOT REGEXP '^(DNA|DNP|DNQ|DNF|DNS|RES)$' THEN 1 ELSE 0 END) AS Finished,
       SUM(CASE WHEN pos IN ('DSQ', 'NC')                         THEN 1 ELSE 0 END) AS Disqualified,
       SUM(CASE WHEN pos IN ('DNF')                               THEN 1 ELSE 0 END) AS Retired
  FROM results RES
 WHERE race_id != 1936 /* cancelled */
 GROUP BY race_id
 ORDER BY Finished DESC;

