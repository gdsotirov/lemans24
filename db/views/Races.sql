CREATE OR REPLACE VIEW Races AS
SELECT ROW_NUMBER() OVER() 'Number',
       CONCAT(YEAR(R.event_date), ' ', '24 Hours of Le Mans') 'Race',
       CONCAT(DATE_FORMAT(R.event_date, '%Y-%m-%d'), '..', DAY(R.event_date)+1) 'Dates',
       C.length_km      'Circuit lenght (km)',
       R.laps           'Laps',
       R.distance_km    'Distance (km)',
       R.distance_mi    'Distance (mi)',
       R.avg_speed_kmh  'Average speed (km/h)',
       R.avg_speed_mph  'Average speed (mi/h)'
  FROM races    R,
       circuits C
 WHERE R.cancelled = FALSE
   AND R.circuit_id = C.id;
