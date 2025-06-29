# C++ Sorting Algorithms Implementation

This directory contains a complete C++ implementation of sorting algorithms with performance measurement capabilities, featuring multi-threading and JSON output.

## Features

- ✅ **9 Sorting Algorithms**: Bubble, Selection, Insertion, Quick, Merge, Heap, Counting, Radix, and Bucket sort
- ✅ **Configurable Runs**: Run each algorithm multiple times for statistical accuracy
- ✅ **Concurrent Execution**: Multiple algorithms run in parallel using std::thread
- ✅ **Statistical Analysis**: Calculate average, min, max, and standard deviation
- ✅ **JSON Output**: Results saved in structured JSON format using nlohmann/json
- ✅ **Error Handling**: Comprehensive error checking and user feedback
- ✅ **Command Line Interface**: Easy-to-use CLI with argument parsing
- ✅ **High Performance**: Optimized C++ implementation with compiler optimizations

## Compilation

```bash
g++ -std=c++17 -Wall -Wextra -O2 -I. algorithms.cpp -o algorithms
```

## Usage

### Basic Usage
```bash
./algorithms --file data.txt --algorithms quick_sort,merge_sort
```

### Custom Number of Runs
```bash
./algorithms --file data.txt --algorithms bubble_sort --runs 15
```

### Multiple Algorithms
```bash
./algorithms --file data.txt --algorithms quick_sort,merge_sort,heap_sort --runs 5
```

### All Available Algorithms
```bash
./algorithms --file data.txt --algorithms bubble_sort,selection_sort,insertion_sort,quick_sort,merge_sort,heap_sort,counting_sort,radix_sort,bucket_sort --runs 10
```

## Available Scripts

### Testing Scripts
- `quick_test.sh` - Quick validation test
- `test_algorithms.sh` - Comprehensive algorithm testing
- `performance_benchmark.sh` - Performance benchmarking with various dataset sizes
- `verify_correctness.sh` - Correctness verification

### Running Test Scripts
```bash
./quick_test.sh                # Quick validation
./test_algorithms.sh           # Comprehensive testing
./performance_benchmark.sh     # Performance benchmarks
./verify_correctness.sh        # Correctness verification
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

Results are saved to: `../../resources/results/results_cpp.json`

## Error Handling

The program handles various error conditions:
- Invalid algorithm names
- File not found errors
- Invalid number of runs
- Empty data files
- Malformed input data

## Requirements

- C++17 compatible compiler (GCC 7+, Clang 5+, MSVC 2017+)
- nlohmann/json library (included in project)
- POSIX-compatible system for scripts

## Examples

### Example 1: Basic Performance Test
```bash
echo "15 3 9 1 5 8 2 7 4 6" > sample.txt
./algorithms --file sample.txt --algorithms quick_sort --runs 5
```

### Example 2: Comparison Test
```bash
# Generate random data
python3 -c "import random; print(' '.join(map(str, random.sample(range(1, 1001), 100))))" > random_data.txt

# Test multiple algorithms
./algorithms --file random_data.txt --algorithms bubble_sort,quick_sort,merge_sort --runs 3
```

### Example 3: Performance Benchmarking
```bash
# Large dataset test
python3 -c "import random; print(' '.join(map(str, random.sample(range(1, 10001), 1000))))" > large_data.txt
./algorithms --file large_data.txt --algorithms quick_sort,merge_sort,heap_sort --runs 10
```

## Help

```bash
./algorithms --help
# Shows comprehensive usage information

./algorithms -h
# Short version of help

./algorithms
# Shows help when no arguments are provided
```

## Build Instructions

### Debug Build
```bash
g++ -std=c++17 -Wall -Wextra -g -I. algorithms.cpp -o algorithms_debug
```

### Release Build (Recommended)
```bash
g++ -std=c++17 -Wall -Wextra -O2 -DNDEBUG -I. algorithms.cpp -o algorithms
```

### With Additional Optimizations
```bash
g++ -std=c++17 -Wall -Wextra -O3 -march=native -I. algorithms.cpp -o algorithms_optimized
```

## Dependencies

- **nlohmann/json**: JSON library for C++ (included in `nlohmann/` directory)
- **Standard C++ Libraries**: `<iostream>`, `<vector>`, `<thread>`, `<chrono>`, etc.

## Implementation Notes

- **Thread Safety**: Uses `std::mutex` for thread-safe JSON result writing
- **Memory Efficiency**: Efficient memory management with RAII principles
- **High Performance**: Optimized algorithms with minimal overhead
- **Statistical Accuracy**: Precise timing using `std::chrono::high_resolution_clock`
- **Error Recovery**: Falls back to current directory if results directory cannot be created
- **Cross-Platform**: Works on Linux, macOS, and Windows with appropriate compiler

## Architecture

- **Multi-threading**: Uses `std::thread` for concurrent algorithm execution
- **Timing**: High-resolution timing with `std::chrono`
- **JSON Output**: Structured results using nlohmann/json library
- **Statistics**: Standard deviation and statistical measures
- **Memory Management**: RAII and smart memory usage patterns

## Performance Characteristics

- **Execution Speed**: Native C++ performance
- **Memory Usage**: Minimal memory overhead
- **Concurrency**: True parallel execution of algorithms
- **Precision**: Nanosecond-precision timing measurements

## Troubleshooting

### Common Issues

1. **Compilation Errors**
   ```bash
   # Ensure C++17 support
   g++ --version
   # Use appropriate flags
   g++ -std=c++17 -pthread -I. algorithms.cpp -o algorithms
   ```

2. **Permission Denied**
   ```bash
   chmod +x algorithms
   chmod +x *.sh
   ```

3. **Missing pthread Support**
   ```bash
   # On some systems, explicitly link pthread
   g++ -std=c++17 -lpthread -I. algorithms.cpp -o algorithms
   ```

4. **JSON Library Issues**
   ```bash
   # Ensure nlohmann/json is in the correct location
   ls nlohmann/json.hpp
   # If missing, download from: https://github.com/nlohmann/json
   ```

5. **Results Directory Issues**
   ```bash
   # Ensure results directory exists
   mkdir -p ../../resources/results/
   ```

## Technical Details

### Thread Implementation
- Uses `std::thread` for true parallelism
- `std::mutex` for thread-safe operations
- Concurrent execution of different algorithms

### Timing Precision
- `std::chrono::high_resolution_clock` for maximum precision
- Nanosecond accuracy on supported platforms
- Multiple runs for statistical significance

### Memory Management
- RAII principles for automatic resource management
- Efficient vector operations
- Copy-based data isolation between runs

### Error Handling Strategy
- Exception-safe code design
- Graceful fallbacks for directory creation
- Comprehensive input validation

## Contributing

When modifying the code:
1. Maintain C++17 compatibility
2. Keep thread safety in mind
3. Preserve the JSON output format
4. Update tests accordingly
5. Follow existing code style and patterns
6. Test with both debug and release builds
