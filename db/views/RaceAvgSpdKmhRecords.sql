CREATE OR REPLACE VIEW RaceAvgSpdKmhRecords AS
SELECT YEAR(R.event_date) 'Year',
       R.distance_km      'Distance (km)',
       R.laps             'Laps',
       R.avg_speed_kmh    'Average speed (km/h)'
  FROM races    R
 WHERE R.cancelled = FALSE
   AND R.avg_speed_kmh > (SELECT MAX(avg_speed_kmh)
                            FROM races
                           WHERE YEAR(event_date) < YEAR(R.event_date)
                         );
