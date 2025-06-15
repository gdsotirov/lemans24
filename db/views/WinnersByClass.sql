CREATE OR REPLACE VIEW WinnersByClass AS
WITH ClassWinners AS (
SELECT R.id                 AS `Year`,
       DENSE_RANK() OVER (PARTITION BY R.id, C.car_class
                              ORDER BY R.id, pos_to_num(RES.pos) ASC)
                            AS InClass,
       pos_to_num(RES.pos)  AS Overall,
       C.car_class          AS Class,
       CN.nbr               AS CarNbr,
       GROUP_CONCAT(DISTINCT TM.title ORDER BY TMR.ord_num ASC SEPARATOR ' / ')
                            AS Team,
       GROUP_CONCAT(D.full_name       ORDER BY DR.ord_num  ASC SEPARATOR ' / ')
                            AS Drivers,
       CONCAT(C.car_chassis, ' / ', C.car_engine)
                            AS Car,
       T.brand              AS Tyres
  FROM races          R,
       results        RES,
       team_results   TMR,
       teams          TM,
       driver_results DR,
       drivers        D,
       car_numbers    CN,
       cars           C,
       car_tyres      CT,
       tyres          T
 WHERE RES.race_id    = R.id
   AND TMR.result_id  = RES.id
   AND TMR.team_id    = TM.id
   AND DR.result_id   = RES.id
   AND DR.driver_id   = D.id
   AND CN.car_id      = C.id
   AND CN.race_id     = R.id
   AND RES.car_id     = CN.id
   AND CT.car_id      = CN.id
   AND CT.tyre_id     = T.id
   AND R.cancelled    = 0 /* not cancelled */
   AND RES.pos NOT IN ('DNA', 'DNF', 'DNP', 'DNQ', 'DNS', 'DSQ', 'NC', 'RES')
 GROUP BY RES.id
)
SELECT `Year`, Overall, Class, CarNbr, Team, Drivers, Car, Tyres
  FROM ClassWinners
 WHERE InClass = 1
 ORDER BY `Year`, Overall;

