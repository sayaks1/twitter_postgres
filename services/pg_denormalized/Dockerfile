FROM postgres:13

RUN apt-get update && apt-get install -y \
    less \
    make \
    vim  \
    bash \
    postgresql-client

WORKDIR /tmp/db

RUN mkdir /data && chown postgres /data
ENV POSTGRES_DB=pg_denormalized

# copy over the pagila database;
# we rename the files so that they get executed in the correct order
COPY schema.sql /docker-entrypoint-initdb.d/01.sql
