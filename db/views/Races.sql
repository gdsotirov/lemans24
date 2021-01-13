CREATE OR REPLACE VIEW Races AS
SELECT ROW_NUMBER() OVER()  AS `Number`,
       CONCAT(YEAR(R.event_date), ' ', '24 Hours of Le Mans')
                            AS Race,
       CONCAT(DATE_FORMAT(R.event_date, '%Y-%m-%d'), '..', DAY(R.event_date)+1)
                            AS Dates,
       C.length_km          AS CircuitLenght_km,
       R.laps               AS Laps,
       R.distance_km        AS Distance_km,
       R.distance_mi        AS Distance_mi,
       R.avg_speed_kmh      AS AvgSpeed_kmh,
       R.avg_speed_mph      AS AvgSpeed_mih
  FROM races    R,
       circuits C
 WHERE R.cancelled  = FALSE
   AND R.circuit_id = C.id;

