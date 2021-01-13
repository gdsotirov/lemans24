CREATE OR REPLACE VIEW Results AS
SELECT R.id             AS Race,
       RES.pos          AS Pos,
       C.car_class      AS Class,
       CN.nbr           AS CarNb,
       GROUP_CONCAT(TM.country        ORDER BY TMR.ord_num ASC SEPARATOR '|')
                        AS TCountry,
       GROUP_CONCAT(DISTINCT TM.title ORDER BY TMR.ord_num ASC SEPARATOR '|')
                        AS Team,
       GROUP_CONCAT(D.country         ORDER BY DR.ord_num  ASC SEPARATOR '|')
                        AS DCountry,
       GROUP_CONCAT(CONCAT(IFNULL(D.fname, 'f.n.u.'), ' ', D.lname)
                                      ORDER BY DR.ord_num  ASC SEPARATOR '|')
                        AS Drivers,
       C.car_chassis    AS Chassis,
       C.car_engine     AS `Engine`,
       GROUP_CONCAT(DISTINCT T.brand SEPARATOR '|')
                        AS Tyre,
       RES.laps         AS Laps,
       RES.distance     AS Distance,
       RES.racing_time  AS RacingTime,
       RES.reason       AS Reason
  FROM results RES
       INNER JOIN races           R   ON RES.race_id    = R.id
       INNER JOIN car_numbers     CN  ON RES.car_id     = CN.id
                                     AND CN.race_id     = R.id
       LEFT JOIN  cars            C   ON CN.car_id      = C.id
       LEFT JOIN  car_tyres       CT  ON CT.car_id      = CN.id
       LEFT JOIN  tyres           T   ON CT.tyre_id     = T.id
       LEFT JOIN  driver_results  DR  ON DR.result_id   = RES.id
       LEFT JOIN  drivers         D   ON DR.driver_id   = D.id
       LEFT JOIN  team_results    TMR ON TMR.result_id  = RES.id
       LEFT JOIN  teams           TM  ON TMR.team_id    = TM.id
 GROUP BY R.id,
          RES.pos,
          C.car_class,
          CN.nbr,
          C.car_chassis,
          C.car_engine,
          RES.laps,
          RES.distance,
          RES.racing_time,
          RES.reason
 ORDER BY R.id                ASC,
          pos_to_num(RES.pos) ASC,
          RES.distance        DESC;

