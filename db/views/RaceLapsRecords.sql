CREATE OR REPLACE VIEW RaceLapsRecords AS
SELECT YEAR(R.event_date) AS `Year`,
       R.distance_km      AS Distance_km,
       R.laps             AS Laps
  FROM races    R
 WHERE R.cancelled = FALSE
   AND (   R.laps > (SELECT MAX(laps)
                       FROM races
                      WHERE YEAR(event_date) < YEAR(R.event_date)
                    )
        OR R.id = (SELECT MIN(id) FROM races)
       );

