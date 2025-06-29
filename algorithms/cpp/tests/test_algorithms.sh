#!/bin/bash

# Test script for algorithms.cpp
echo "=== Testing C++ Sorting Algorithms ==="

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

# Test all algorithms on small data
echo "=== Testing all algorithms on small dataset ==="
./algorithms_test --file small_data.txt --algorithms bubble_sort,selection_sort,insertion_sort,quick_sort,merge_sort,heap_sort,counting_sort,radix_sort,bucket_sort

echo ""
echo "=== Testing performance on medium dataset ==="
./algorithms_test --file medium_data.txt --algorithms quick_sort,merge_sort,heap_sort

echo ""
echo "=== Testing edge cases ==="
echo "Testing on sorted data:"
./algorithms_test --file sorted_data.txt --algorithms quick_sort,merge_sort

echo ""
echo "Testing on reverse sorted data:"
./algorithms_test --file reverse_data.txt --algorithms quick_sort,merge_sort

echo ""
echo "Testing on duplicate data:"
./algorithms_test --file duplicate_data.txt --algorithms counting_sort,radix_sort

echo ""
echo "=== All tests completed! ==="
