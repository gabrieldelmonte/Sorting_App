#!/bin/bash

# Test script for algorithms.py
echo "=== Testing Python Sorting Algorithms ==="

# Create test files with different data sizes
echo "Creating test data files..."

# Small dataset
echo "15 3 9 1 5 8 2 7 4 6" > small_data.txt

# Medium dataset (100 numbers)
python3 -c "import random; print(' '.join(map(str, random.sample(range(1, 1001), 100))))" > medium_data.txt

# Large dataset (1000 numbers) 
python3 -c "import random; print(' '.join(map(str, random.sample(range(1, 10001), 1000))))" > large_data.txt

# Already sorted data
echo "1 2 3 4 5 6 7 8 9 10" > sorted_data.txt

# Reverse sorted data  
echo "10 9 8 7 6 5 4 3 2 1" > reverse_data.txt

# Duplicate data
echo "5 3 5 1 3 5 1 3 5 1" > duplicate_data.txt

echo "Test files created!"
echo ""

# Test all algorithms on small data with custom runs
echo "=== Testing all algorithms on small dataset (3 runs each) ==="
python3 algorithms.py --file small_data.txt --algorithms bubble_sort,selection_sort,insertion_sort,quick_sort,merge_sort,heap_sort,counting_sort,radix_sort,bucket_sort --runs 3

echo ""
echo "=== Testing performance on medium dataset (5 runs each) ==="
python3 algorithms.py --file medium_data.txt --algorithms quick_sort,merge_sort,heap_sort --runs 5

echo ""
echo "=== Testing edge cases ==="
echo "Testing on sorted data (3 runs each):"
python3 algorithms.py --file sorted_data.txt --algorithms quick_sort,merge_sort --runs 3

echo ""
echo "Testing on reverse sorted data (3 runs each):"
python3 algorithms.py --file reverse_data.txt --algorithms quick_sort,merge_sort --runs 3

echo ""
echo "Testing on duplicate data (3 runs each):"
python3 algorithms.py --file duplicate_data.txt --algorithms counting_sort,radix_sort --runs 3

echo ""
echo "=== Testing different run counts ==="
echo "Single run test:"
python3 algorithms.py --file small_data.txt --algorithms quick_sort --runs 1

echo ""
echo "Many runs test (15 runs):"
python3 algorithms.py --file small_data.txt --algorithms merge_sort --runs 15

echo ""
echo "=== All tests completed! ==="

# Clean up
rm small_data.txt medium_data.txt large_data.txt sorted_data.txt reverse_data.txt duplicate_data.txt

echo "Check results at: ../../resources/results/results_python.json"
