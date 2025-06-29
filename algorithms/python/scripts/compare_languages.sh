#!/bin/bash

echo "=== C++ vs Python Performance Comparison ==="

# Create a test dataset for comparison
echo "Generating comparison dataset..."
python3 -c "import random; print(' '.join(map(str, random.sample(range(1, 1001), 500))))" > comparison_data.txt

echo "Dataset created with 500 random integers."
echo ""

echo "=== Running C++ Implementation ==="
cd ../cpp
./algorithms_final --file ../python/comparison_data.txt --algorithms quick_sort,merge_sort,heap_sort --runs 5 > /dev/null 2>&1

echo "=== Running Python Implementation ==="
cd ../python
python3 algorithms.py --file comparison_data.txt --algorithms quick_sort,merge_sort,heap_sort --runs 5 > /dev/null 2>&1

echo ""
echo "=== Results Comparison ==="
echo "C++ Results (../../resources/results/results_cpp.json):"
echo "----------------------------------------"
if [ -f "../../resources/results/results_cpp.json" ]; then
    tail -30 ../../resources/results/results_cpp.json | head -20
else
    echo "C++ results file not found"
fi

echo ""
echo "Python Results (../../resources/results/results_python.json):"
echo "----------------------------------------"
if [ -f "../../resources/results/results_python.json" ]; then
    tail -30 ../../resources/results/results_python.json | head -20
else
    echo "Python results file not found"
fi

# Clean up
rm comparison_data.txt

echo ""
echo "✅ Comparison completed!"
echo ""
echo "Note: Timing differences between C++ and Python are expected due to:"
echo "  - Language performance characteristics"
echo "  - Runtime overhead differences"
echo "  - Memory management differences"
echo "  - Both implementations use the same algorithmic logic"
