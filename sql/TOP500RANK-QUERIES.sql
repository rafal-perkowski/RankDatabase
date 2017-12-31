/* USE DATABASE top500rank */
USE top500rank;

/* SELECT * FROM STATEMENTS - for all created tables */
SELECT * FROM rankmonths;
SELECT * FROM countries;
SELECT * FROM architectures;
SELECT * FROM segments;
SELECT * FROM interconnects;
SELECT * FROM opsystems;
SELECT * FROM processors;
SELECT * FROM systemfams;
SELECT * FROM manufacturers;
SELECT * FROM sites;
SELECT * FROM configurations;
SELECT * FROM installations;
SELECT * FROM ranks;
SELECT * FROM rankusers;

/* SELECT COUNT(*) STATEMENTS - for all created tables */
SELECT count(*) AS rankmonths FROM rankmonths;
SELECT count(*) AS countries FROM countries;
SELECT count(*) AS architectures FROM architectures;
SELECT count(*) AS segments FROM segments;
SELECT count(*) AS interconnects FROM interconnects;
SELECT count(*) AS opsystems FROM opsystems;
SELECT count(*) AS processors FROM processors;
SELECT count(*) AS systemfams FROM systemfams;
SELECT count(*) AS manufacturers FROM manufacturers;
SELECT count(*) AS sites FROM sites;
SELECT count(*) AS configurations FROM configurations;
SELECT count(*) AS installations FROM installations;
SELECT count(*) AS ranks FROM ranks;
SELECT count(*) AS rankusers FROM rankusers;

/* SELECT * FROM VIEWS - for all created views */
SELECT * FROM view_allranks_simple;
SELECT * FROM view_allranks_detailed;
SELECT * FROM view_newestrank;
SELECT * FROM view_polranks;

/* SELECT COUNT(*) STATEMENTS - for all created views */
SELECT count(*) AS view_allranks_simple FROM view_allranks_simple;
SELECT count(*) AS view_allranks_detailed FROM view_allranks_detailed;
SELECT count(*) AS view_newestrank FROM view_newestrank;
SELECT count(*) AS view_polranks FROM view_polranks;
