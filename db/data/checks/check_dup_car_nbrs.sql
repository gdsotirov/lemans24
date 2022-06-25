/* Check for duplicate car numbers in races excluding cars that did not attend,
 * practice, qualify, start or were reserves.
 */
SELECT CN.race_id, CN.nbr, COUNT(*) cnt
  FROM car_numbers CN,
       results     R
 WHERE R.race_id = CN.race_id
   AND R.car_id  = CN.id
   AND R.pos NOT IN ('DNA', 'DNP', 'DNQ', 'DNS', 'RES')
 GROUP BY CN.race_id, CN.nbr
 HAVING COUNT(*) > 1;

