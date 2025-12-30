package main

import (
	"fmt"
	"net/http"
)

func HelloWorld() string {
	return "Hello, World!"
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, HelloWorld())
}

func main() {
	http.HandleFunc("/", helloHandler)
	fmt.Println("Server starting on :3000...")
	if err := http.ListenAndServe(":3000", nil); err != nil {
		fmt.Printf("Error starting server: %s\n", err)
	}
}
