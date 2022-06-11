CREATE OR REPLACE VIEW RaceDistKmRecords AS
SELECT YEAR(R.event_date) AS `Year`,
       R.distance_km      AS Distance_km,
       R.laps             AS Laps
  FROM races    R
 WHERE R.cancelled = FALSE
   AND (   R.distance_km > (SELECT MAX(distance_km)
                              FROM races
                             WHERE YEAR(event_date) < YEAR(R.event_date)
                           )
        OR R.id = (SELECT MIN(id) FROM races)
       );

