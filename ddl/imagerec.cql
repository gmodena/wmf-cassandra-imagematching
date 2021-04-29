-- Based on @eevans example at https://gist.github.com/eevans/d2e06b8163e05f7e2fbd6691ac7caccb
DROP KEYSPACE IF EXISTS imagerec;

CREATE KEYSPACE imagerec WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

CREATE TABLE imagerec.matches (
    page_id TEXT,
    page_title TEXT,
    image_id TEXT,
    confidence_rating TEXT,
    source TEXT,
    dataset_id TEXT,
    creation_time FLOAT,
    wiki TEXT,
    found_on TEXT,
    PRIMARY KEY(wiki, page_id)
);

COPY imagerec.matches(page_id, page_title, image_id, confidence_rating, source, dataset_id, creation_time, wiki, found_on)
    FROM 'imagerec_prod/matches.tsv' WITH DELIMITER='\t' AND NULL='' AND ERRFILE='/ingestion_status/import_imagerec_matches.err' AND MAXROWS=300000;
