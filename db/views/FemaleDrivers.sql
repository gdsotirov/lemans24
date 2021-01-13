CREATE OR REPLACE VIEW FemaleDrivers AS
SELECT `Name`, Country, Years, `Starts`, BestFinish,
       OvWins, OvTop10, OvTop10Years,
       ClassWins, ClassWinYears
  FROM AllDriversResults
 WHERE Sex = 'Female';

