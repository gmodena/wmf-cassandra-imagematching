package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

type ImageMatching struct {
	 Prediction [] map[string]interface{} `json:"prediction"`
	 ModelVersion string `json:"model_version"`
}


func (* ImageMatching) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	session := GetCassandraSession() // we should not re-init at every request.
	wiki, ok := r.URL.Query()["wiki"]
	if ok {}
	page_id, ok := r.URL.Query()["page_id"]
	if ok {}

	maxrows := 3
	stmt := fmt.Sprintf("select image_id from imagerec.matches where wiki = '%s' and page_id = '%s' limit %d;", wiki[0], page_id[0], maxrows)
	query := session.Query(stmt)

	var recs []map[string]interface{};


	for row := range IterRows(*query) {
		recs = append(recs, row)
	}

	ima := ImageMatching{Prediction: recs, ModelVersion: "1a"}
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	response, err := json.Marshal(ima)
	if err != nil {
		log.Print(err)
	}
	w.Write(response)
}
