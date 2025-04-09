#!/bin/sh

# Check if running in CI environment
if [ -n "$CI" ]; then
  # CI environment settings
  NORMALIZED_DB="postgresql://postgres:pass@localhost:1048/postgres"
  DENORMALIZED_HOST="localhost"
  DENORMALIZED_PORT="1047"
  DENORMALIZED_DB="postgres"
else
  # Local environment settings
  NORMALIZED_DB="postgresql://postgres:pass@localhost:1048/pg_normalized"
  DENORMALIZED_HOST="localhost"
  DENORMALIZED_PORT="1047"
  DENORMALIZED_DB="pg_denormalized"
fi

# list all of the files that will be loaded into the database
# for the first part of this assignment, we will only load a small test zip file with ~10000 tweets
# but we will write are code so that we can easily load an arbitrary number of files
files='
test-data.zip
'

echo 'load normalized'
for file in $files; do
    # call the load_tweets.py file to load data into pg_normalized
    python3 load_tweets.py --db "$NORMALIZED_DB" --inputs "$file"
done

echo 'load denormalized'
for file in $files; do
    # use SQL's COPY command to load data into pg_denormalized
    export PGPASSWORD=pass
    unzip -p "$file" | sed 's/\\u0000//g' | psql \
        -h "$DENORMALIZED_HOST" -p "$DENORMALIZED_PORT" -U postgres -d "$DENORMALIZED_DB" \
        -c "\copy tweets_jsonb (data) FROM STDIN WITH (FORMAT csv, DELIMITER E'\t', QUOTE E'\b')"

done
