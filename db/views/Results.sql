CREATE OR REPLACE VIEW Results AS
SELECT R.id            Race,
       RES.pos         Pos,
       C.car_class     Class,
       CN.nbr          "CarNb",
       GROUP_CONCAT(TM.country        ORDER BY TMR.ord_num ASC SEPARATOR '|') "TCountry",
       GROUP_CONCAT(DISTINCT TM.title ORDER BY TMR.ord_num ASC SEPARATOR '|') "Team",
       GROUP_CONCAT(D.country         ORDER BY DR.ord_num  ASC SEPARATOR '|') "DCountry",
       GROUP_CONCAT(CONCAT(IFNULL(D.fname, 'f.n.u.'), ' ', D.lname)
                                      ORDER BY DR.ord_num  ASC SEPARATOR '|') "Drivers",
       C.car_chassis   Chassis,
       C.car_engine    "Engine",
       GROUP_CONCAT(DISTINCT T.brand SEPARATOR '|') "Tyre",
       RES.laps        "Laps",
       RES.distance    "Distance",
       RES.racing_time "Racing Time",
       RES.reason      "Reason"
  FROM results        RES
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
 ORDER BY R.id ASC,
          CASE
            WHEN RES.pos RLIKE '^[1-9][0-9]*$'
              THEN CAST(RES.pos AS UNSIGNED)
            WHEN RES.pos = 'NC'  THEN 93
            WHEN RES.pos = 'DNF' THEN 94
            WHEN RES.pos = 'DSQ' THEN 94
            WHEN RES.pos = 'DNS' THEN 95
            WHEN RES.pos = 'DNQ' THEN 96
            WHEN RES.pos = 'DNP' THEN 97
            WHEN RES.pos = 'DNA' THEN 98
            WHEN RES.pos = 'RES' THEN 99
          END ASC,
          RES.distance DESC;
