# wmf-cassandra-imagematching
A Docker Compose configuration for testing/developing Cassandra ingestion of IMA data.

# Requirements

You will need Docker Engine and Docker Compose. On non-linux systems, you'll need to install
`coreutils`. The latter is needed to satisfy a dependency on `shuf`.

# Data preparation

Run
```
$ make data
```

The command will download the lastet available `imagerec_prod` tarball, combine wiki files into a single dataset,
and shuffles records. Output will be available under `imagerec_prod`.

# Running
```
$ docker-compose <up|down> [--build] cassandra-load-imagerec
```

Rows not imported will be stored under `ingestion_status/import_imagerec_matches.err`.

