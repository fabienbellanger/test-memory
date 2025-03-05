package main

import (
	"fmt"
	"net/http"
	"time"

	"github.com/go-chi/chi/v5"
)

func main() {
	// Channel to queue tasks
	taskQueue := make(chan http.ResponseWriter, 100)

	// Worker pool
	for i := 0; i < 100; i++ {
		go worker(taskQueue)
	}

	r := chi.NewRouter()
	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello, World!"))
	})

	r.Get("/worker", func(w http.ResponseWriter, r *http.Request) {
		taskQueue <- w
	})

	r.Get("/spawn", func(w http.ResponseWriter, r *http.Request) {
		go func() {
			time.Sleep(500 * time.Millisecond)
			w.Write([]byte("Hello, World!"))
		}()
	})

	fmt.Println("Server started at localhost:3000")
	http.ListenAndServe(":3000", r)
}

func worker(taskQueue chan http.ResponseWriter) {
	for w := range taskQueue {
		time.Sleep(500 * time.Millisecond)
		w.Write([]byte("Hello, World!"))
	}
}
