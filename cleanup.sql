SELECT relname, n_dead_tup
FROM pg_stat_user_tables
ORDER BY n_dead_tup DESC;

VACUUM VERBOSE books;
VACUUM VERBOSE events;

SELECT date_trunc('month', now()) AS reference,
       pg_total_relation_size('loans')/1024/1024 AS size_mb;
