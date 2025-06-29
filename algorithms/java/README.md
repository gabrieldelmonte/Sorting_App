# Java Sorting Algorithms Implementation

This directory contains a complete Java implementation of sorting algorithms with performance measurement capabilities, featuring multi-threaded benchmarking and JSON output, equivalent to the C++ and Python versions.

## Project Structure

```
java/
├── src/
│   └── SortingAlgorithms.java    # Main Java source file
├── lib/
│   └── gson-2.10.1.jar          # GSON library for JSON
├── bin/                         # Compiled class files
├── scripts/                     # Test and utility scripts
│   ├── quick_test.sh
│   ├── test_algorithms.sh
│   ├── performance_benchmark.sh
│   └── verify_correctness.sh
├── .vscode/
│   └── settings.json            # VS Code Java project settings
├── run.sh                       # Build and run script
└── README.md                    # This file
```

## Features

- ✅ **9 Sorting Algorithms**: Bubble, Selection, Insertion, Quick, Merge, Heap, Counting, Radix, and Bucket sort
- ✅ **Configurable Runs**: Run each algorithm multiple times for statistical accuracy
- ✅ **Concurrent Execution**: Multiple algorithms run in parallel using ExecutorService
- ✅ **Statistical Analysis**: Calculate average, min, max, and standard deviation
- ✅ **JSON Output**: Results saved in structured JSON format using GSON
- ✅ **Error Handling**: Comprehensive error checking and user feedback
- ✅ **Command Line Interface**: Easy-to-use CLI with help documentation
- ✅ **VS Code Integration**: Proper project structure for IDE support

## Requirements

- Java 8 or higher (JDK/JRE)
- GSON library (included: `lib/gson-2.10.1.jar`)
- Standard Java libraries

## Quick Start

### Using the run script (Recommended)
```bash
./run.sh --help                                          # Show help
./run.sh --file data.txt --algorithms quick_sort --runs 5  # Run sorting
```

### Manual compilation and execution
```bash
javac -cp lib/gson-2.10.1.jar -d bin src/SortingAlgorithms.java
java -cp bin:lib/gson-2.10.1.jar SortingAlgorithms --file data.txt --algorithms quick_sort,merge_sort
```

## Usage

### Basic Usage
```bash
./run.sh --file data.txt --algorithms quick_sort,merge_sort
```

### Custom Number of Runs
```bash
./run.sh --file data.txt --algorithms bubble_sort --runs 15
```

### Multiple Algorithms
```bash
./run.sh --file data.txt --algorithms quick_sort,merge_sort,heap_sort --runs 5
```

### All Available Algorithms
```bash
./run.sh --file data.txt --algorithms bubble_sort,selection_sort,insertion_sort,quick_sort,merge_sort,heap_sort,counting_sort,radix_sort,bucket_sort --runs 10
```

## Available Scripts

### Testing Scripts
- `scripts/quick_test.sh` - Quick validation test
- `scripts/test_algorithms.sh` - Comprehensive algorithm testing
- `scripts/performance_benchmark.sh` - Performance benchmarking with various dataset sizes
- `scripts/verify_correctness.sh` - Correctness verification

### Running Test Scripts
```bash
cd scripts/
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

Results are saved to: `../../resources/results/results_java.json`

## Error Handling

The program handles various error conditions:
- Invalid algorithm names
- File not found errors
- Invalid number of runs
- Empty data files
- Malformed input data

## Examples

### Example 1: Basic Performance Test
```bash
echo "15 3 9 1 5 8 2 7 4 6" > sample.txt
java -cp .:gson-2.10.1.jar SortingAlgorithms --file sample.txt --algorithms quick_sort --runs 5
```

### Example 2: Comparison Test
```bash
# Generate random data (if Python available)
python3 -c "import random; print(' '.join(map(str, random.sample(range(1, 1001), 100))))" > random_data.txt

# Test multiple algorithms
java -cp .:gson-2.10.1.jar SortingAlgorithms --file random_data.txt --algorithms bubble_sort,quick_sort,merge_sort --runs 3
```

### Example 3: Performance Benchmarking
```bash
# Large dataset test
python3 -c "import random; print(' '.join(map(str, random.sample(range(1, 10001), 1000))))" > large_data.txt
java -cp .:gson-2.10.1.jar SortingAlgorithms --file large_data.txt --algorithms quick_sort,merge_sort,heap_sort --runs 10
```

## Help

```bash
java -cp .:gson-2.10.1.jar SortingAlgorithms --help
# Shows comprehensive usage information

java -cp .:gson-2.10.1.jar SortingAlgorithms -h
# Short version of help

java -cp .:gson-2.10.1.jar SortingAlgorithms
# Shows help when no arguments are provided
```

## Implementation Notes

- **Thread Safety**: Uses ExecutorService for thread pool management
- **Memory Efficiency**: Efficient array operations and proper memory management
- **High Precision Timing**: Uses System.nanoTime() for accurate measurements
- **Statistical Accuracy**: Proper standard deviation and statistical calculations
- **Error Recovery**: Falls back to current directory if results directory cannot be created
- **Cross-Platform**: Works on Linux, macOS, and Windows

## Architecture

- **Multi-threading**: Uses `ExecutorService` and `Future` for concurrent execution
- **Timing**: High-precision timing with `System.nanoTime()`
- **JSON Output**: Structured results using GSON library
- **Statistics**: Standard deviation and comprehensive statistical measures
- **Memory Management**: Proper array cloning and garbage collection friendly

## Performance Characteristics

- **Execution Speed**: JVM optimized performance
- **Memory Usage**: Efficient memory allocation
- **Concurrency**: True parallel execution of algorithms
- **Precision**: Nanosecond-precision timing measurements
- **JIT Optimization**: Benefits from Just-In-Time compilation

## Dependencies

### GSON Library
- **File**: `gson-2.10.1.jar`
- **Purpose**: JSON serialization and deserialization
- **Version**: 2.10.1
- **License**: Apache License 2.0

### Installation
The GSON library is included in the project directory. If you need to download it separately:
```bash
wget https://repo1.maven.org/maven2/com/google/code/gson/gson/2.10.1/gson-2.10.1.jar
```

## Compilation Options

### Standard Compilation
```bash
javac -cp gson-2.10.1.jar SortingAlgorithms.java
```

### With Debugging Information
```bash
javac -g -cp gson-2.10.1.jar SortingAlgorithms.java
```

### With Warnings
```bash
javac -Xlint:all -cp gson-2.10.1.jar SortingAlgorithms.java
```

### Optimized Compilation (Java 8+)
```bash
javac -cp gson-2.10.1.jar -source 8 -target 8 SortingAlgorithms.java
```

## Execution Options

### Standard Execution
```bash
java -cp .:gson-2.10.1.jar SortingAlgorithms [arguments]
```

### With JVM Optimization
```bash
java -server -cp .:gson-2.10.1.jar SortingAlgorithms [arguments]
```

### With Memory Settings
```bash
java -Xmx1g -cp .:gson-2.10.1.jar SortingAlgorithms [arguments]
```

### With Garbage Collection Logging
```bash
java -XX:+PrintGC -cp .:gson-2.10.1.jar SortingAlgorithms [arguments]
```

## Comparison with C++ and Python Versions

This Java implementation provides equivalent functionality to both C++ and Python versions:
- Same algorithms and logic
- Same command-line interface
- Same JSON output format
- Same statistical calculations
- Same error handling
- Performance typically between C++ (fastest) and Python (slowest)
- Benefits from JIT compilation for repeated operations

## Troubleshooting

### Common Issues

1. **Compilation Errors**
   ```bash
   # Ensure Java version compatibility
   java -version
   javac -version
   # Check GSON library is present
   ls -la gson-2.10.1.jar
   ```

2. **ClassPath Issues**
   ```bash
   # Always include both current directory and GSON jar
   java -cp .:gson-2.10.1.jar SortingAlgorithms [args]
   # On Windows, use semicolon separator
   java -cp .;gson-2.10.1.jar SortingAlgorithms [args]
   ```

3. **Permission Denied**
   ```bash
   chmod +x *.sh
   ```

4. **Out of Memory Errors**
   ```bash
   # Increase heap size
   java -Xmx2g -cp .:gson-2.10.1.jar SortingAlgorithms [args]
   ```

5. **Results Directory Issues**
   ```bash
   # Ensure results directory exists
   mkdir -p ../../resources/results/
   ```

## Technical Details

### Algorithm Implementations
- **Bubble Sort**: Classic implementation with early termination
- **Selection Sort**: Finds minimum element in each iteration
- **Insertion Sort**: Builds sorted portion incrementally
- **Quick Sort**: Recursive divide-and-conquer with last element pivot
- **Merge Sort**: Stable divide-and-conquer with merging
- **Heap Sort**: Binary heap-based sorting with heapify
- **Counting Sort**: Integer sorting using counting array
- **Radix Sort**: Digit-by-digit sorting using counting sort
- **Bucket Sort**: Distribution sorting with ArrayList buckets

### Thread Management
- Uses `ExecutorService.newFixedThreadPool()` for controlled concurrency
- `Future` objects for task completion tracking
- Synchronized collections for thread-safe result aggregation
- Proper resource cleanup with executor shutdown

### Error Handling Strategy
- Comprehensive input validation
- Graceful exception handling
- Meaningful error messages
- Proper exit codes for script integration

## Contributing

When modifying the code:
1. Maintain Java 8+ compatibility
2. Keep thread safety in mind
3. Preserve the JSON output format
4. Update tests accordingly
5. Follow Java coding conventions
6. Update documentation as needed

## Performance Tips

1. **JVM Warm-up**: Run algorithms multiple times for JIT optimization
2. **Memory Management**: Use appropriate heap sizes for large datasets
3. **Concurrency**: Leverage multi-core systems with parallel execution
4. **Profiling**: Use Java profiling tools for performance analysis
5. **Optimization**: Enable server-class JVM for better performance
