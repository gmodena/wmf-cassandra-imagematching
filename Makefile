dataset_variant := api
dataset := imagerec_prod
dataset_archive := ${dataset}.tar.bz2
dataset_url := https://analytics.wikimedia.org/published/datasets/one-off/platform-imagematching/${dataset_variant}/${dataset_archive}

download:
	test -d ${dataset_archive} || curl -o ${dataset_archive} ${dataset_url}

data:	download
	test -d ${dataset} || mkdir ${dataset}
	tar xvjf ${dataset_archive} -C ${dataset}
	cat ${dataset}/prod* |sed 's/"/\\"/' | shuf > ${dataset}/matches.tsv
	rm ${dataset}/prod*
sqlite: 
	test -d ${dataset} || make data
	docker-compose run sqlite /bin/bash -c "sqlite3 < /imagerec.sqlite /imagerec_prod/imagerec.db"
cassandra: 
	test -d ${dataset} || make data
	docker-compose up cassandra-load-imagerec

clean:
	rm -r ${dataset} ${dataset_archive}
