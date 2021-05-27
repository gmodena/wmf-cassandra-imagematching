package main

import  "net/http"

type server struct{}

var version = "unknown"
var buildDate = "unknown"

func main() {
	ima := ImageMatching{}
	http.Handle("/predict", &ima)
	http.ListenAndServe(":8000", nil)
}
