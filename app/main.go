package main

import (
    "fmt"
    "io"
    "log"
    "net/http"
    "time"
)

func main() {
    http.HandleFunc("/wrong", HandlePostWrong);
    http.HandleFunc("/correct", HandlePostCorrect);
    http.HandleFunc("/health", HandleHealth);
	log.Println("starting")
    log.Fatal(http.ListenAndServe(":8080", nil))
}
func HandleHealth(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(200)
}
func HandlePostWrong(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Connection", "Keep-Alive")
    w.Header().Set("Transfer-Encoding", "Chunked")
    w.Header().Set("X-Content-Type-Options", "nosniff")

    ticker := time.NewTicker(time.Second)
    go func() {
        for t := range ticker.C {
            io.WriteString(w, "Chunk\n")
            fmt.Println("Tick at", t)
        }
    }()
    time.Sleep(time.Millisecond * 11000)
    ticker.Stop()
    fmt.Println("Finished: should return Content-Length: 0 here")
    w.Header().Set("Content-Length", "0")
}

func HandlePostCorrect(w http.ResponseWriter, r *http.Request) {
    // #1 add flusher
    flusher, ok := w.(http.Flusher)
    if !ok {
        panic("expected http.ResponseWriter to be an http.Flusher")
    }
    w.Header().Set("Connection", "Keep-Alive")
    // Don't need these this bc manually flushing sets this header
    // w.Header().Set("Transfer-Encoding", "chunked")
    
    // make sure this header is set
    w.Header().Set("X-Content-Type-Options", "nosniff")

    ticker := time.NewTicker(time.Second)
    go func() {
        for t := range ticker.C {
            io.WriteString(w, "Chunk\n")
            fmt.Println("Tick at", t)
            flusher.Flush()
        }
		fmt.Println("Closed")
    }()
    time.Sleep(time.Millisecond * 11000)
	ticker.Stop()
}
