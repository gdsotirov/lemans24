CREATE OR REPLACE VIEW RaceAvgSpdKmhRecords AS
SELECT YEAR(R.event_date) AS `Year`,
       R.distance_km      AS Distance_km,
       R.laps             AS Laps,
       R.avg_speed_kmh    AS AvgSpeed_kmh
  FROM races    R
 WHERE R.cancelled = FALSE
   AND R.avg_speed_kmh > (SELECT MAX(avg_speed_kmh)
                            FROM races
                           WHERE YEAR(event_date) < YEAR(R.event_date)
                         );

