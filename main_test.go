package main

import (
	"log"
	"testing"
)

func TestMainExternal(t *testing.T) {
	// TODO: guard with flag?

	log.Println("TestMainExternal start")
	main()
	log.Println("TestMainExternal done")
}
