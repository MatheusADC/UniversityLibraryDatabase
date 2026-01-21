CREATE TABLE events (
    id    serial PRIMARY KEY,
    data  jsonb
);

INSERT INTO events(data)
VALUES ('{"user":"alice","action":"login","meta":{"ip":"10.0.0.1"}}');

EXPLAIN ANALYZE
SELECT data->>'user' FROM events;

SELECT data->>'action' AS act FROM events;

UPDATE events
SET data = jsonb_set(data, '{meta,device}', '"mobile"');

WITH docs AS (
    SELECT '{"tags":["banco","nosql","pgsql"]}'::jsonb AS d
)
SELECT tag
FROM docs, jsonb_array_elements(d->'tags') AS arr(tag);

CREATE INDEX idx_events_data_gin ON events USING GIN (data);

CREATE INDEX idx_events_data_path ON events USING GIN (data jsonb_path_ops);

EXPLAIN ANALYZE
SELECT * FROM events WHERE data @> '{"action":"login"}';

CREATE TABLE search (
    id serial PRIMARY KEY,
    answers text[]
);

INSERT INTO search(answers) VALUES (ARRAY['yes','no','maybe']);

SELECT id, unnest(answers) AS resposta FROM search;

CREATE EXTENSION IF NOT EXISTS hstore;

CREATE TABLE configs (
    id serial PRIMARY KEY,
    props hstore
);

INSERT INTO configs(props)
VALUES ('theme => "dark", notifications => "on"');

SELECT props->'theme' AS tema FROM configs;