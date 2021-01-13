CREATE OR REPLACE VIEW Circuits AS
SELECT CASE
         WHEN YEAR(C.since) != (SELECT MIN(YEAR(since))
                                  FROM circuits
                                 WHERE YEAR(since) > YEAR(C.since)
                               ) - 1
         THEN
           CONCAT(YEAR(C.since), '-', (SELECT MIN(YEAR(since))
                                         FROM circuits
                                        WHERE YEAR(since) > YEAR(C.since)
                                      ) - 1
                 )
         ELSE
           YEAR(C.since)
       END         AS Years,
       C.length_km AS Length_km,
       C.length_mi AS Length_mi,
       C.changes   AS `Changes`
  FROM circuits C;

