CREATE OR REPLACE VIEW Winners AS
SELECT ROW_NUMBER() OVER()  "Number",
       R.id                 "Year",
       GROUP_CONCAT(DISTINCT TM.title ORDER BY TMR.ord_num ASC SEPARATOR ' / ') "Team",
       GROUP_CONCAT(CONCAT(IFNULL(D.fname, 'f.n.u.'), ' ', D.lname)
                                      ORDER BY DR.ord_num  ASC SEPARATOR ' / ') "Drivers"
  FROM races          R,
       results        RES,
       team_results   TMR,
       teams          TM,
       driver_results DR,
       drivers        D
 WHERE RES.race_id    = R.id
   AND TMR.result_id  = RES.id
   AND TMR.team_id    = TM.id
   AND DR.result_id   = RES.id
   AND DR.driver_id   = D.id
   AND R.cancelled    = 0 /* not cancelled */
   AND RES.pos        = 1 /* winners */
 GROUP BY R.id
 ORDER BY R.id;
