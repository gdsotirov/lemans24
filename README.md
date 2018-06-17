# LeMans24

A sample schema for statistics on 24 Hours of Le Mans endurance race.

# Contents

## Tables

* circuits   - Circuits register (to track changes in Circuit de la Sarthe length and configuration)
* drivers    - Drivers register
* races      - Races register (including cancelled)
* results    - Results register
* results_in - Results input buffer

## Triggers

* races_calc_laps_bi   - calculation of laps based on distance and circuit length
* races_calc_laps_bu   - calculation of laps based on distance and circuit length
* results_in_checks_bi - checks on input data
* results_in_checks_bu - checks on input data

## Views

* Circuits              - List circuits length and changes per years
* RaceAvgSpdKmhRecords  - Average speed in km/h records
* RaceDistKmRecords     - Distance in km records
* RaceLapsRecords       - Total number of laps records
* Races                 - List races with distance in km and mi, laps, average speed in km/h and mi/h

# Routines

* check_position - checks position for number, NC, DNF, DNS, DSQ values

# TODO

Implement routines for splitting the input results into a relational database for easier querying.

# Licenses

This code and data model in this sample project is available under GPL v2 license.
Data source is Wikipedia, so data is under CC BY-SA 3.0 license.
