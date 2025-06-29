#!/bin/bash

echo "=== Quick Test Script ==="
echo "Testing your algorithms.cpp with the --runs parameter..."

# Create a simple test file
echo "10 5 15 3 20 1 8 12" > quick_test.txt

echo ""
echo "Test 1: Default runs (should be 10)"
./algorithms_final --file quick_test.txt --algorithms quick_sort

echo ""
echo "Test 2: Custom 5 runs"
./algorithms_final --file quick_test.txt --algorithms merge_sort --runs 5

echo ""
echo "Test 3: Single run"
./algorithms_final --file quick_test.txt --algorithms heap_sort --runs 1

echo ""
echo "Test 4: Multiple algorithms with custom runs"
./algorithms_final --file quick_test.txt --algorithms bubble_sort,quick_sort --runs 3

echo ""
echo "✅ All tests completed! Check that:"
echo "   - 'runs' field matches what you specified"
echo "   - 'times' array has the correct number of elements"
echo "   - Results are saved to ../../resources/results/results_cpp.json"

# Clean up
rm quick_test.txt

echo ""
echo "Scripts available:"
echo "  ./test_algorithms.sh       - Comprehensive algorithm testing"
echo "  ./performance_benchmark.sh - Performance benchmarking"
echo "  ./verify_correctness.sh    - Correctness verification"
