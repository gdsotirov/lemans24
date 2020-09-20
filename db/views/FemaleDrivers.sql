CREATE OR REPLACE VIEW FemaleDrivers AS
SELECT `Name`, `Country`, `Years`, `Starts`, `BestFinish`,
       `Ov Wins`, `Ov Top 10`, `Ov Top 10 Years`,
       `Class Wins`, `Class Win Years`
  FROM AllDriversResults
 WHERE Sex = 'Female';

