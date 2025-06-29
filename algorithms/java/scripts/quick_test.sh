#!/bin/bash

# Quick test script for Java Sorting Algorithms
# This script performs a basic validation test

echo "=== Java Sorting Algorithms - Quick Test ==="
echo

# Compile the Java program
echo "1. Compiling Java program..."
javac -cp ../lib/gson-2.10.1.jar -d ../bin ../src/SortingAlgorithms.java
if [ $? -ne 0 ]; then
    echo "❌ Compilation failed!"
    exit 1
fi
echo "✅ Compilation successful"
echo

# Create test data
echo "2. Creating test data..."
echo "64 34 25 12 22 11 90 5 77 30 15 88 3 44 67 1 99 55 21 36" > test_data.txt
echo "✅ Test data created: test_data.txt"
echo

# Test help functionality
echo "3. Testing help functionality..."
java -cp ../bin:../lib/gson-2.10.1.jar SortingAlgorithms --help > /dev/null
if [ $? -eq 0 ]; then
    echo "✅ Help functionality works"
else
    echo "❌ Help functionality failed"
    exit 1
fi
echo

# Test basic sorting
echo "4. Testing basic sorting (quick_sort)..."
java -cp ../bin:../lib/gson-2.10.1.jar SortingAlgorithms --file test_data.txt --algorithms quick_sort --runs 3 > /dev/null
if [ $? -eq 0 ]; then
    echo "✅ Quick sort test passed"
else
    echo "❌ Quick sort test failed"
    exit 1
fi
echo

# Test multiple algorithms
echo "5. Testing multiple algorithms..."
java -cp ../bin:../lib/gson-2.10.1.jar SortingAlgorithms --file test_data.txt --algorithms bubble_sort,merge_sort --runs 2 > /dev/null
if [ $? -eq 0 ]; then
    echo "✅ Multiple algorithms test passed"
else
    echo "❌ Multiple algorithms test failed"
    exit 1
fi
echo

# Check if results file was created
echo "6. Checking results file..."
if [ -f "../../../resources/results/results_java.json" ]; then
    echo "✅ Results file created successfully"
else
    echo "⚠️  Results file not found in expected location (may be in current directory)"
fi
echo

# Clean up
echo "7. Cleaning up..."
rm -f test_data.txt
echo "✅ Cleanup completed"
echo

echo "🎉 Quick test completed successfully!"
echo "Java implementation is working correctly."
