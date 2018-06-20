#!/bin/bash
# Builds a single CSV with all the results

curr_year=$(date +%Y)
idx=1

for i in `seq 1923 1935; seq 1937 1939; seq 1949 ${curr_year}`; do
  if [ $idx -gt 1 ]; then
    ./extract_results.pl results_${i}.html | ./parse_results.pl ${i} 2>/dev/null | tail -n +2;
  else
    ./extract_results.pl results_${i}.html | ./parse_results.pl ${i} 2>/dev/null;
  fi

  idx=$((idx + 1))
done

