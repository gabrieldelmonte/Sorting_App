#!/bin/bash

echo "=== Quick Test Script - Python Version ==="
echo "Testing your algorithms.py with the --runs parameter..."

# Create a simple test file
echo "10 5 15 3 20 1 8 12" > quick_test.txt

echo ""
echo "Test 1: Default runs (should be 10)"
python3 algorithms.py --file quick_test.txt --algorithms quick_sort

echo ""
echo "Test 2: Custom 5 runs"
python3 algorithms.py --file quick_test.txt --algorithms merge_sort --runs 5

echo ""
echo "Test 3: Single run"
python3 algorithms.py --file quick_test.txt --algorithms heap_sort --runs 1

echo ""
echo "Test 4: Multiple algorithms with custom runs"
python3 algorithms.py --file quick_test.txt --algorithms bubble_sort,quick_sort --runs 3

echo ""
echo "Test 5: Error handling test"
echo "Testing with invalid algorithm:"
python3 algorithms.py --file quick_test.txt --algorithms invalid_sort --runs 3 2>&1 | head -3

echo ""
echo "Testing with invalid runs:"
python3 algorithms.py --file quick_test.txt --algorithms quick_sort --runs 0 2>&1 | head -3

echo ""
echo "✅ All tests completed! Check that:"
echo "   - 'runs' field matches what you specified"
echo "   - 'times' array has the correct number of elements"
echo "   - Results are saved to ../../resources/results/results_python.json"
echo "   - Statistics (average, min, max, std_deviation) are calculated correctly"

# Clean up
rm quick_test.txt

echo ""
echo "Scripts available:"
echo "  ./test_algorithms.sh       - Comprehensive algorithm testing"
echo "  ./performance_benchmark.sh - Performance benchmarking"
echo "  ./verify_correctness.sh    - Correctness verification"
echo ""
echo "Usage examples:"
echo "  python3 algorithms.py --file data.txt --algorithms quick_sort,merge_sort"
echo "  python3 algorithms.py --file data.txt --algorithms bubble_sort --runs 15"
echo "  python3 algorithms.py --file data.txt --algorithms quick_sort,merge_sort,heap_sort --runs 5"
