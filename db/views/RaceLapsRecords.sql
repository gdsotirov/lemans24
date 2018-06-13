CREATE OR REPLACE VIEW RaceLapsRecords AS
SELECT YEAR(R.event_date) 'Year',
       R.distance_km      'Distance (km)',
       R.laps             'Laps'
  FROM races    R
 WHERE R.cancelled = FALSE
   AND R.laps > (SELECT MAX(laps)
                   FROM races
                  WHERE YEAR(event_date) < YEAR(R.event_date)
                );
