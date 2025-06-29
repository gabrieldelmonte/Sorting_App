# Python Sorting Algorithms Implementation

This directory contains a complete Python implementation of sorting algorithms with performance measurement capabilities, equivalent to the C++ version.

## Features

- ✅ **9 Sorting Algorithms**: Bubble, Selection, Insertion, Quick, Merge, Heap, Counting, Radix, and Bucket sort
- ✅ **Configurable Runs**: Run each algorithm multiple times for statistical accuracy
- ✅ **Concurrent Execution**: Multiple algorithms run in parallel using threading
- ✅ **Statistical Analysis**: Calculate average, min, max, and standard deviation
- ✅ **JSON Output**: Results saved in structured JSON format
- ✅ **Error Handling**: Comprehensive error checking and user feedback
- ✅ **Command Line Interface**: Easy-to-use CLI with help documentation

## Usage

### Basic Usage
```bash
python3 algorithms.py --file data.txt --algorithms quick_sort,merge_sort
```

### Custom Number of Runs
```bash
python3 algorithms.py --file data.txt --algorithms bubble_sort --runs 15
```

### Multiple Algorithms
```bash
python3 algorithms.py --file data.txt --algorithms quick_sort,merge_sort,heap_sort --runs 5
```

### All Available Algorithms
```bash
python3 algorithms.py --file data.txt --algorithms bubble_sort,selection_sort,insertion_sort,quick_sort,merge_sort,heap_sort,counting_sort,radix_sort,bucket_sort --runs 10
```

## Available Scripts

### Testing Scripts
- `quick_test.sh` - Quick validation test
- `test_algorithms.sh` - Comprehensive algorithm testing
- `performance_benchmark.sh` - Performance benchmarking with various dataset sizes
- `verify_correctness.sh` - Correctness verification
- `compare_languages.sh` - Compare C++ vs Python performance

### Running Test Scripts
```bash
./quick_test.sh                # Quick validation
./test_algorithms.sh           # Comprehensive testing
./performance_benchmark.sh     # Performance benchmarks
./verify_correctness.sh        # Correctness verification
./compare_languages.sh         # Language comparison
```

## Available Algorithms

1. **bubble_sort** - Bubble Sort (O(n²))
2. **selection_sort** - Selection Sort (O(n²))
3. **insertion_sort** - Insertion Sort (O(n²))
4. **quick_sort** - Quick Sort (O(n log n) average)
5. **merge_sort** - Merge Sort (O(n log n))
6. **heap_sort** - Heap Sort (O(n log n))
7. **counting_sort** - Counting Sort (O(n + k))
8. **radix_sort** - Radix Sort (O(d × (n + k)))
9. **bucket_sort** - Bucket Sort (O(n + k))

## Input File Format

The input file should contain space-separated integers:
```
64 34 25 12 22 11 90 5 77 30
```

## Output Format

Results are saved in JSON format with detailed statistics:

```json
[
    {
        "algorithm": "quick_sort",
        "runs": 10,
        "times": [0.001, 0.002, ...],
        "average_time": 0.0015,
        "min_time": 0.001,
        "max_time": 0.002,
        "std_deviation": 0.0005
    }
]
```

## Output Location

Results are saved to: `../../resources/results/results_python.json`

## Error Handling

The program handles various error conditions:
- Invalid algorithm names
- File not found errors
- Invalid number of runs
- Empty data files
- Malformed input data

## Requirements

- Python 3.6 or higher
- Standard library modules (no external dependencies)

## Examples

### Example 1: Basic Performance Test
```bash
echo "15 3 9 1 5 8 2 7 4 6" > sample.txt
python3 algorithms.py --file sample.txt --algorithms quick_sort --runs 5
```

### Example 2: Comparison Test
```bash
# Generate random data
python3 -c "import random; print(' '.join(map(str, random.sample(range(1, 1001), 100))))" > random_data.txt

# Test multiple algorithms
python3 algorithms.py --file random_data.txt --algorithms bubble_sort,quick_sort,merge_sort --runs 3
```

### Example 3: Performance Benchmarking
```bash
# Large dataset test
python3 -c "import random; print(' '.join(map(str, random.sample(range(1, 10001), 1000))))" > large_data.txt
python3 algorithms.py --file large_data.txt --algorithms quick_sort,merge_sort,heap_sort --runs 10
```

## Help

```bash
python3 algorithms.py --help
```

## Implementation Notes

- **Thread Safety**: Uses threading locks for concurrent execution
- **Memory Efficiency**: Creates data copies for each run to ensure accuracy
- **Statistical Accuracy**: Calculates proper standard deviation and statistics
- **Error Recovery**: Falls back to current directory if results directory cannot be created
- **Cross-Platform**: Works on Linux, macOS, and Windows

## Comparison with C++ Version

This Python implementation provides the same functionality as the C++ version:
- Same algorithms and logic
- Same command-line interface
- Same JSON output format
- Same statistical calculations
- Same error handling
- Expected performance differences due to language characteristics
