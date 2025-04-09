#!/bin/bash

failed=false

mkdir -p results

HOST=localhost
PORT=1048
USER=postgres
DB=pg_normalized
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

