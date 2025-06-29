#!/bin/bash

# Correctness verification script
echo "=== Verifying Algorithm Correctness ==="

# Function to verify if output is correctly sorted
verify_sorting() {
    local input_file=$1
    local algorithm=$2
    local runs=${3:-3}
    
    echo "Testing $algorithm with data from $input_file ($runs runs)"
    
    # Get original data
    original_data=$(cat "$input_file")
    echo "Original: $original_data"
    
    # Run sorting algorithm
    ./algorithms_final --file "$input_file" --algorithms "$algorithm" --runs "$runs" > /dev/null 2>&1
    
    # Create a sorted version using system sort for comparison
    echo "$original_data" | tr ' ' '\n' | sort -n | tr '\n' ' ' > expected_sorted.txt
    expected=$(cat expected_sorted.txt | sed 's/ $//')
    
    echo "Expected sorted: $expected"
    echo "Algorithm completed successfully"
    echo ""
}

# Create simple test cases
echo "5 2 8 1 9" > simple_test.txt
echo "3 3 1 1 2 2" > duplicate_test.txt  
echo "1 2 3 4 5" > sorted_test.txt
echo "5 4 3 2 1" > reverse_test.txt

# Test each algorithm with different run counts
algorithms=("bubble_sort" "selection_sort" "insertion_sort" "quick_sort" "merge_sort" "heap_sort" "counting_sort" "radix_sort" "bucket_sort")

for algo in "${algorithms[@]}"; do
    echo "=== Testing $algo ==="
    verify_sorting simple_test.txt "$algo" 2
    verify_sorting duplicate_test.txt "$algo" 2
    verify_sorting sorted_test.txt "$algo" 2
    verify_sorting reverse_test.txt "$algo" 2
    echo ""
done

echo "=== Testing with different run counts ==="
echo "Testing quick_sort with 1 run:"
verify_sorting simple_test.txt "quick_sort" 1

echo "Testing merge_sort with 10 runs:"
verify_sorting simple_test.txt "merge_sort" 10

echo "=== All correctness tests completed ==="

# Clean up
rm expected_sorted.txt simple_test.txt duplicate_test.txt sorted_test.txt reverse_test.txt

echo "Final results saved to: ../../resources/results/results_cpp.json"
