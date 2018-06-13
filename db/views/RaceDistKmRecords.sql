CREATE OR REPLACE VIEW RaceDistKmRecords AS
SELECT YEAR(R.event_date) 'Year',
       R.distance_km      'Distance (km)',
       R.laps             'Laps'
  FROM races    R
 WHERE R.cancelled = FALSE
   AND R.distance_km > (SELECT MAX(distance_km)
                          FROM races
                         WHERE YEAR(event_date) < YEAR(R.event_date)
                       );
