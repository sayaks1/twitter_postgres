FROM postgis/postgis:14-3.3

RUN apt-get update && apt-get install -y \
    less \
    make \
    vim  \
    postgresql-client \
    bash

WORKDIR /tmp/db

RUN mkdir /data && chown postgres /data
ENV POSTGRES_DB=pg_normalized


# copy over the pagila database;
# we rename the files so that they get executed in the correct order
COPY schema.sql /docker-entrypoint-initdb.d/01.sql
