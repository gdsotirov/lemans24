#!/bin/bash
# Retrieve Wikipedia pages with 24 Hours of Le Mans results

curr_year=$(date +%Y)

if [ "$1" == "clean" ]; then
  rm -f results_*.html
  exit 0
fi

for i in `seq 1923 1935; seq 1937 1939; seq 1949 ${curr_year}`; do
  echo -n "Fetching year ${i}... ";
  wget -q "https://en.wikipedia.org/wiki/${i}_24_Hours_of_Le_Mans" -O results_${i}.html;
  if [ $? -eq 0 ]; then
    echo "Done.";
  else
    echo "Fail!";
  fi
done

