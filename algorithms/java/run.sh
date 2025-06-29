#!/bin/bash

# Java Sorting Algorithms - Build and Run Script
# This script compiles and runs the Java sorting algorithms

echo "=== Java Sorting Algorithms - Build & Run ==="
echo

# Compile the program
echo "Compiling..."
javac -cp lib/gson-2.10.1.jar -d bin src/SortingAlgorithms.java
if [ $? -ne 0 ]; then
    echo "❌ Compilation failed!"
    exit 1
fi
echo "✅ Compilation successful"
echo

# Check if arguments were provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <arguments for SortingAlgorithms>"
    echo "Example: $0 --help"
    echo "Example: $0 --file data.txt --algorithms quick_sort --runs 5"
    echo
    java -cp bin:lib/gson-2.10.1.jar SortingAlgorithms --help
    exit 0
fi

# Run the program with provided arguments
echo "Running Java Sorting Algorithms..."
java -cp bin:lib/gson-2.10.1.jar SortingAlgorithms "$@"
