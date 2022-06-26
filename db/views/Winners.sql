CREATE OR REPLACE VIEW Winners AS
SELECT ROW_NUMBER() OVER()  AS `Number`,
       R.id                 AS `Year`,
       GROUP_CONCAT(DISTINCT TM.title ORDER BY TMR.ord_num ASC SEPARATOR ' / ')
                            AS Team,
       GROUP_CONCAT(CONCAT(IFNULL(D.fname, 'f.n.u.'), ' ', D.lname)
                                      ORDER BY DR.ord_num  ASC SEPARATOR ' / ')
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
   AND RES.pos        = 1 /* winners */
 GROUP BY R.id
 ORDER BY R.id;

