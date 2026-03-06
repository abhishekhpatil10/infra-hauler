package main

import (
	"embed"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
)

// This variable will be filled by the compiler
var Version = "development"

//go:embed Script/*
var scriptFiles embed.FS

func main() {
	// 1. Check if the user asked for the version
	if len(os.Args) > 1 && (os.Args[1] == "--version" || os.Args[1] == "-v") {
		fmt.Printf("infra-hauler version: %s\n", Version)
		return
	}

	// 2. Create a temporary directory
	tmpDir, err := os.MkdirTemp("", "infra-hauler-*")
	if err != nil {
		fmt.Printf("Error: %v\n", err)
		os.Exit(1)
	}
	defer os.RemoveAll(tmpDir)

	// 3. Extract scripts
	entries, _ := scriptFiles.ReadDir("Script")
	for _, entry := range entries {
		data, _ := scriptFiles.ReadFile("Script/" + entry.Name())
		destPath := filepath.Join(tmpDir, entry.Name())
		os.WriteFile(destPath, data, 0755)
	}

	// 4. Run the main script
	mainScript := filepath.Join(tmpDir, "infra-hauler.sh")
	cmd := exec.Command("bash", append([]string{mainScript}, os.Args[1:]...)...)
	
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin

	if err := cmd.Run(); err != nil {
		os.Exit(1)
	}
}
