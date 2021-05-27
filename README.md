# wmf-cassandra-imagematching
A Docker Compose configuration for testing/developing Cassandra ingestion of IMA data.

# Requirements

You will need Docker Engine and Docker Compose. On non-linux systems, you'll need to install
`coreutils`. The latter is needed to satisfy a dependency on `shuf`.

This setup is memory hungry. When running on Docker Desktop (macOS or Windows), we recommend to [allocate 
4GB or memory to the docker VM](https://docs.docker.com/docker-for-mac/) for things to work properly. 

# Data preparation

Run
```
$ make data
```

The command will download the lastet available `imagerec_prod` tarball, combine wiki files into a single dataset,
and shuffles records. Output will be available under `imagerec_prod`.

# Data load into Cassandra

To load a sample into a Cassandra (single node) cluster run
```
$ make cassandra
```
Uner the hood, this command will spin up a single node Cassandra cluster via `docker-compose`. Rows not imported will be stored 
under `ingestion_status/import_imagerec_matches.err`.

## Limitations
This command uses `cqlsh` to load data in Cassandra, which is an inefficient method for large datasets. To keep things reproducible,
the `COPY` command is limited to loading at most `300000` rows. This value can be tweaked by setting `MAXROWS` in `ddl/imagerec.cql` accordingly.

# Accessing Cassandra

The dataset will be available in a container that exposes the following port to its host: `7000-7001/tcp`, `7199/tcp`, `9042/tcp`, `9160/tcp`.

You can access the database over the network using any Cassandra Driver or `cqlsh`.

Alternatively, you can attach to the running container and execute `cqlsh` locally. For examle:
```
$ docker ps
CONTAINER ID   IMAGE              COMMAND                  CREATED          STATUS          PORTS                                                                          NAMES
6c116c75986b   cassandra:latest   "docker-entrypoint.s…"   17 minutes ago   Up 17 minutes   7001/tcp, 0.0.0.0:7000->7000/tcp, 7199/tcp, 0.0.0.0:9042->9042/tcp, 9160/tcp   cassandra

$  docker exec -ti 6c116c75986b cqlsh cassandra
Connected to Test Cluster at cassandra:9042.
[cqlsh 5.0.1 | Cassandra 3.11.10 | CQL spec 3.4.4 | Native protocol v4]
Use HELP for help.
cqlsh> 
```

From this shell, we can query IMA data as follows:
```
cqlsh> use imagerec;
cqlsh:imagerec> select count(*) from matches;

 count
 299998

(1 rows)

Warnings :
Aggregation query used without partition key
```

## CQL Driver

Cassandra offers client API in a number of languages.
`client-example` contains examples of basic lookup and Json SerDe with `golang` and the [gocl](https://github.com/gocql/gocql) driver.

# Other targets
Run
`make sqlite` 

to load the full IMA data into a sqlite database under `imagerec_prod/matches.db`.
Once loaded, data can be queried with
```
$ sqlite3 imagerec_prod/imagerec.db
```

See `ddl/imagerec.sqlite` for schema, indexing and import details.
