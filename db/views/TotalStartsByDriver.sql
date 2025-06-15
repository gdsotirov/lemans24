CREATE OR REPLACE VIEW TotalStartsByDriver AS
SELECT D.full_name                                              AS Driver,
       D.country                                                AS DCountry,
       COUNT(DISTINCT R.id)                                     AS `Starts`,
       MIN(R.id)                                                AS FirstStart,
       MAX(R.id)                                                AS LastStart,
       GROUP_CONCAT(DISTINCT R.id ORDER BY R.id SEPARATOR ', ') AS Years
  FROM races          R,
       results        RES,
       driver_results DR,
       drivers        D
 WHERE RES.race_id  = R.id
   AND DR.result_id = RES.id
   AND DR.driver_id = D.id
   AND RES.pos NOT IN ('DNA', 'DNP', 'DNQ', 'DNS', 'RES')
 GROUP BY D.id
 ORDER BY `Starts`  DESC,
          Years     ASC,
          Driver    ASC;

