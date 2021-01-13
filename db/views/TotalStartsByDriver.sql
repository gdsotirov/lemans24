CREATE OR REPLACE VIEW TotalStartsByDriver AS
SELECT CONCAT(IFNULL(D.fname, 'f.n.u.'), ' ', D.lname)  AS Driver,
       D.country                                        AS DCountry,
       COUNT(*)                                         AS `Starts`,
       GROUP_CONCAT(R.id ORDER BY R.id SEPARATOR ', ')  AS Years
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

