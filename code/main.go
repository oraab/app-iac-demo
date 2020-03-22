package main

import (
	"fmt"
	"log"
	"net/http"
)

func defaultHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Generic web app server says it's A-OK. You requested: %s\n",r.URL.Path[1:])
}

func main() {
	http.HandleFunc("/",defaultHandler)
	err := http.ListenAndServe(":8080",nil)
	if err != nil {
		log.Fatalf("Error when running server: %s",err)
	}
}
