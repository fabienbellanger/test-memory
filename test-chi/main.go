package main

import (
	"context"
	"fmt"
	"net/http"
	"time"

	"github.com/go-chi/chi/v5"
)

const (
	// MaxWorkers is the number of workers to spawn
	MaxWorkers = 10
)

func main() {
	// runtime.GOMAXPROCS(4)

	// Channel to queue tasks
	taskQueue := make(chan http.ResponseWriter, MaxWorkers)

	// Worker pool
	for range MaxWorkers {
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

		// Call Google
		httpClient := http.Client{}
		ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
		defer cancel()
		req, err := http.NewRequestWithContext(ctx, http.MethodGet, "https://google.com", nil)
		if err != nil {
			return
		}
		_, err = httpClient.Do(req)
		if err != nil {
			return
		}

		_ = w
		// w.Write([]byte("Hello, World!"))
	}
}
