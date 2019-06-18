CREATE OR REPLACE VIEW AllWomenTeams AS
SELECT R.id                                       "Year",
       GROUP_CONCAT(DISTINCT TM.title
                    ORDER BY TR.ord_num
                    SEPARATOR ', ')               "Team",
       GROUP_CONCAT(CONCAT(D.fname, ' ', D.lname)
                    ORDER BY DR.ord_num
                    SEPARATOR ', ')               "Drivers",
       C.car_chassis                              "Car",
       RES.pos                                    "Finish",
       NULL                                       "In class"
  FROM drivers        D,
       driver_results DR,
       races          R,
       results        RES,
       car_numbers    CN,
       cars           C,
       team_results   TR,
       teams          TM
 WHERE DR.driver_id = D.id
   AND DR.result_id = RES.id
   AND RES.race_id  = R.id
   AND RES.car_id   = CN.id
   AND CN.car_id    = C.id
   AND TR.result_id = RES.id
   AND TR.team_id   = TM.id
   AND D.sex        = 'F'
   /* all women => no man in the team */
   AND NOT EXISTS (SELECT 1
                     FROM driver_results IDR,
                          drivers ID
                    WHERE IDR.result_id = RES.id
                      AND IDR.driver_id = ID.id
                      AND ID.sex = 'M'
                  )
   AND RES.pos NOT IN ('DNA', 'DNP', 'DNQ', 'DNS', 'RES')
 GROUP BY R.id, RES.id
 ORDER BY R.id                ASC,
          RES.distance        DESC,
          pos_to_num(RES.pos) ASC;
