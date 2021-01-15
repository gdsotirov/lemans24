#!/bin/sh

mydump=$(which mysqldump)
user='lemans24'
db='lemans24'

if [ -x "${mydump}" ]; then
  echo -n "Dumping data from ${db}... "
  # Dump all tables except results_in, which is for raw data import.
  "${mydump}" \
    --complete-insert \
    --dump-date \
    --ignore-table="${db}.results_in" \
    --no-create-info \
    --password \
    --result-file="${db}-data.sql" \
    --single-transaction \
    --skip-triggers \
    --user="${user}" \
    "${db}"
  if [ $? == 0 ]; then
    echo "Done."
  else
    echo "FAIL!"
  fi
else
  echo "Error: Command '${mydump}' not executable!"
  exit 1
fi

