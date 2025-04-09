#!/bin/bash

failed=false

mkdir -p results

if [ -z "$CI" ]; then
  # Local environment
  HOST=localhost
  PORT=1048
  DB=pg_normalized
else
  # GitHub Actions / Docker environment
  HOST=pg_normalized
  PORT=5432
  DB=pg_normalized
fi

USER=postgres
PASSWORD=pass
export PGPASSWORD=$PASSWORD

for problem in sql/*; do
    printf "$problem "
    problem_id=$(basename ${problem%.sql})
    result="results/$problem_id.out"
    expected="expected/$problem_id.out"
    psql -h $HOST -p $PORT -U $USER -d $DB < $problem > $result
    DIFF=$(diff -B $expected $result)
    if [ -z "$DIFF" ]; then
        echo pass
    else
        echo fail
        failed=true
    fi
done

if [ "$failed" = "true" ]; then
    exit 2
fi

