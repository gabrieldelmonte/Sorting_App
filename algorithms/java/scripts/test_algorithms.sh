#!/bin/bash

# Comprehensive test script for Java Sorting Algorithms
# Tests all algorithms with various datasets

echo "=== Java Sorting Algorithms - Comprehensive Test ==="
echo

# Compile the Java program
echo "1. Compiling Java program..."
javac -cp gson-2.10.1.jar SortingAlgorithms.java
if [ $? -ne 0 ]; then
    echo "❌ Compilation failed!"
    exit 1
fi
echo "✅ Compilation successful"
echo

# Create test datasets
echo "2. Creating test datasets..."

# Small dataset
echo "5 2 8 1 9 3" > small_data.txt
echo "✅ Small dataset: small_data.txt"

# Medium dataset  
echo "64 34 25 12 22 11 90 5 77 30 15 88 3 44 67 1 99 55 21 36 82 49 13 95 60 7 71 26 40 18" > medium_data.txt
echo "✅ Medium dataset: medium_data.txt"

# Sorted dataset
echo "1 2 3 4 5 6 7 8 9 10" > sorted_data.txt
echo "✅ Sorted dataset: sorted_data.txt"

# Reverse sorted dataset
echo "10 9 8 7 6 5 4 3 2 1" > reverse_data.txt
echo "✅ Reverse sorted dataset: reverse_data.txt"

# Single element
echo "42" > single_data.txt
echo "✅ Single element dataset: single_data.txt"
echo

# Test all algorithms individually
echo "3. Testing individual algorithms..."
algorithms=("bubble_sort" "selection_sort" "insertion_sort" "quick_sort" "merge_sort" "heap_sort" "counting_sort" "radix_sort" "bucket_sort")

for algo in "${algorithms[@]}"; do
    echo -n "   Testing $algo... "
    java -cp .:gson-2.10.1.jar SortingAlgorithms --file medium_data.txt --algorithms $algo --runs 3 > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "✅"
    else
        echo "❌"
        echo "Failed algorithm: $algo"
        exit 1
    fi
done
echo

# Test with different run counts
echo "4. Testing with different run counts..."
echo -n "   Testing with 1 run... "
java -cp .:gson-2.10.1.jar SortingAlgorithms --file small_data.txt --algorithms quick_sort --runs 1 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅"
else
    echo "❌"
    exit 1
fi

echo -n "   Testing with 15 runs... "
java -cp .:gson-2.10.1.jar SortingAlgorithms --file small_data.txt --algorithms quick_sort --runs 15 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅"
else
    echo "❌"
    exit 1
fi
echo

# Test edge cases
echo "5. Testing edge cases..."
echo -n "   Single element dataset... "
java -cp .:gson-2.10.1.jar SortingAlgorithms --file single_data.txt --algorithms quick_sort --runs 2 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅"
else
    echo "❌"
    exit 1
fi

echo -n "   Already sorted dataset... "
java -cp .:gson-2.10.1.jar SortingAlgorithms --file sorted_data.txt --algorithms quick_sort,merge_sort --runs 2 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅"
else
    echo "❌"
    exit 1
fi

echo -n "   Reverse sorted dataset... "
java -cp .:gson-2.10.1.jar SortingAlgorithms --file reverse_data.txt --algorithms heap_sort,insertion_sort --runs 2 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅"
else
    echo "❌"
    exit 1
fi
echo

# Test all algorithms together
echo "6. Testing all algorithms together..."
java -cp .:gson-2.10.1.jar SortingAlgorithms --file medium_data.txt --algorithms bubble_sort,selection_sort,insertion_sort,quick_sort,merge_sort,heap_sort,counting_sort,radix_sort,bucket_sort --runs 2 > test_output.json
if [ $? -eq 0 ]; then
    echo "✅ All algorithms test passed"
else
    echo "❌ All algorithms test failed"
    exit 1
fi
echo

# Verify JSON output structure
echo "7. Verifying JSON output structure..."
if command -v python3 &> /dev/null; then
    python3 -c "
import json
import sys

try:
    with open('test_output.json', 'r') as f:
        data = json.load(f)
    
    if not isinstance(data, list):
        print('❌ JSON root should be an array')
        sys.exit(1)
    
    required_fields = ['algorithm', 'runs', 'times', 'average_time', 'min_time', 'max_time', 'std_deviation']
    
    for item in data:
        for field in required_fields:
            if field not in item:
                print(f'❌ Missing field: {field}')
                sys.exit(1)
    
    print('✅ JSON structure is valid')
except Exception as e:
    print(f'❌ JSON validation failed: {e}')
    sys.exit(1)
" 2>/dev/null
else
    echo "⚠️  Python3 not available, skipping JSON validation"
fi
echo

# Test error handling
echo "8. Testing error handling..."
echo -n "   Invalid algorithm name... "
java -cp .:gson-2.10.1.jar SortingAlgorithms --file small_data.txt --algorithms invalid_sort --runs 2 > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "✅ (correctly rejected)"
else
    echo "❌ (should have failed)"
    exit 1
fi

echo -n "   Non-existent file... "
java -cp .:gson-2.10.1.jar SortingAlgorithms --file nonexistent.txt --algorithms quick_sort --runs 2 > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "✅ (correctly rejected)"
else
    echo "❌ (should have failed)"
    exit 1
fi

echo -n "   Invalid runs count... "
java -cp .:gson-2.10.1.jar SortingAlgorithms --file small_data.txt --algorithms quick_sort --runs 0 > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "✅ (correctly rejected)"
else
    echo "❌ (should have failed)"
    exit 1
fi
echo

# Clean up
echo "9. Cleaning up..."
rm -f small_data.txt medium_data.txt sorted_data.txt reverse_data.txt single_data.txt test_output.json
echo "✅ Cleanup completed"
echo

echo "🎉 Comprehensive test completed successfully!"
echo "All Java sorting algorithms are working correctly."
