dataset_variant := api
dataset := imagerec_prod
dataset_archive := ${dataset}.tar.bz2
dataset_url := https://analytics.wikimedia.org/published/datasets/one-off/platform-imagematching/${dataset_variant}/${dataset_archive}

download:
	test ${dataset_archive} || curl -o ${dataset_archive} ${dataset_url}

data:	download
	test -d ${dataset} || mkdir ${dataset}
	tar xvjf ${dataset_archive} -C ${dataset}
	cat ${dataset}/prod* | shuf > ${dataset}/matches.tsv
	rm ${dataset}/prod*
sqlite: 
	test -d ${dataset} || make data
	sqlite3 < ddl/imagerec.sqlite ${dataset}/imagerec.db
clean:
	rm -r ${dataset} ${dataset_archive}
