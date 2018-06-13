# LeMans24

A sample schema for statistics on 24 Hours of Le Mans endurance race.

# Contents

## Tables

circuits  - Circuits register (to track changes in Circuit de la Sarthe length and configuration)
drivers   - Drivers register
races     - Races register (including cancelled)
results   - Results register

## Triggers

races_calc_laps_bi  - calculation of laps based on distance and circuit length
races_calc_laps_bu  - calculation of laps based on distance and circuit length

## Views

Circuits              - List circuits lenght and changes per years
RaceAvgSpdKmhRecords  - Average speed in km/h records
RaceDistKmRecords     - Distance in km records
RaceLapsRecords       - Total number of laps records
Races                 - List races with distance in km and mi, laps, average speed in km/h and mi/h

# License

This sample project is available under GPL v2 license.
