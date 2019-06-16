CREATE OR REPLACE VIEW MostPodiumsByDriver AS
SELECT CONCAT(IFNULL(D.fname, 'f.n.u.'), ' ', D.lname) Driver,
       SUM(CASE WHEN RES.pos = 1 THEN 1 ELSE 0 END)    FstPlace,
       SUM(CASE WHEN RES.pos = 2 THEN 1 ELSE 0 END)    SndPlace,
       SUM(CASE WHEN RES.pos = 3 THEN 1 ELSE 0 END)    TrdPlace,
       COUNT(*)                                        TtlPodiums,
       GROUP_CONCAT(CONCAT(R.id, ' (', RES.pos, ')')
                    ORDER BY R.id SEPARATOR ', ')      Years
  FROM races          R,
       results        RES,
       driver_results DR,
       drivers        D
 WHERE RES.race_id  = R.id
   AND DR.result_id = RES.id
   AND DR.driver_id = D.id
   AND RES.pos IN (1, 2, 3)
 GROUP BY D.id
 ORDER BY TtlPodiums DESC,
          FstPlace   DESC,
          SndPlace   DESC,
          TrdPlace   DESC,
          Driver ASC;
