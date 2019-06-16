CREATE OR REPLACE VIEW Circuits AS
SELECT CASE
         WHEN YEAR(C.since) != (SELECT MIN(YEAR(since)) FROM circuits WHERE YEAR(since) > YEAR(C.since)) - 1 THEN
           CONCAT(YEAR(C.since), '-',
                  (SELECT MIN(YEAR(since)) FROM circuits WHERE YEAR(since) > YEAR(C.since)) - 1)
         ELSE
           YEAR(C.since)
       END 'Years',
       C.length_km 'Length (km)', C.length_mi 'Length (mi)', C.changes 'Changes'
  FROM circuits C;
