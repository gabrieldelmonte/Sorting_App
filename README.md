# Sorting Algorithms Comparison Project

A comprehensive implementation and comparison of sorting algorithms in both C++ and Python, featuring multi-threaded benchmarking, statistical analysis, and structured JSON output.

## Project Overview

This project provides identical implementations of 9 sorting algorithms in C++, Python, and Java, allowing for comprehensive performance comparisons between the three languages. All implementations feature the same command-line interface, statistical analysis capabilities, and output formats.

## Project Structure

```
Sorting_App/
├── algorithms/
│   ├── cpp/                      # C++ Implementation
│   │   ├── algorithms.cpp        # Main C++ program
│   │   ├── README.md             # C++ documentation
│   │   ├── quick_test.sh         # Quick validation test
│   │   ├── test_algorithms.sh    # Comprehensive testing
│   │   ├── performance_benchmark.sh # Performance benchmarks
│   │   ├── verify_correctness.sh # Correctness verification
│   │   └── nlohmann/             # JSON library
│   │       └── json.hpp
│   │
│   └── python/                   # Python Implementation
│       ├── algorithms.py         # Main Python program
│       ├── README.md             # Python documentation
│       ├── quick_test.sh         # Quick validation test
│       ├── test_algorithms.sh    # Comprehensive testing
│       ├── performance_benchmark.sh # Performance benchmarks
│       ├── verify_correctness.sh # Correctness verification
│       └── compare_languages.sh  # Cross-language comparison
│
│   └── java/                     # Java Implementation
│       ├── SortingAlgorithms.java # Main Java program
│       ├── gson-2.10.1.jar      # GSON library for JSON
│       ├── README.md             # Java documentation
│       ├── quick_test.sh         # Quick validation test
│       ├── test_algorithms.sh    # Comprehensive testing
│       ├── performance_benchmark.sh # Performance benchmarks
│       └── verify_correctness.sh # Correctness verification
│
├── resources/
│   ├── data/                     # Test datasets
│   │   ├── random_10.txt
│   │   ├── random_100.txt
│   │   ├── random_1000.txt
│   │   ├── sorted_data.txt
│   │   └── reverse_sorted.txt
│   │
│   └── results/                  # Output files
│       ├── results_cpp.json     # C++ results
│       ├── results_python.json  # Python results
│       └── results_java.json    # Java results
│
└── README.md                     # This file
```

## Features

### ✅ **Identical Implementations**
- Same 9 sorting algorithms in C++, Python, and Java
- Identical command-line interfaces
- Same statistical analysis methods
- Consistent JSON output formats

### ✅ **Comprehensive Algorithm Suite**
1. **Bubble Sort** - Simple comparison-based sorting (O(n²))
2. **Selection Sort** - Find minimum and swap (O(n²))
3. **Insertion Sort** - Build sorted portion incrementally (O(n²))
4. **Quick Sort** - Divide and conquer with pivot (O(n log n) average)
5. **Merge Sort** - Divide and conquer with merging (O(n log n))
6. **Heap Sort** - Binary heap-based sorting (O(n log n))
7. **Counting Sort** - Integer sorting by counting (O(n + k))
8. **Radix Sort** - Digit-by-digit sorting (O(d × (n + k)))
9. **Bucket Sort** - Distribute into buckets (O(n + k))

### ✅ **Advanced Features**
- **Multi-threading**: Concurrent execution of different algorithms
- **Statistical Analysis**: Average, min, max, standard deviation
- **Configurable Runs**: Multiple executions for accuracy
- **Error Handling**: Comprehensive input validation and error recovery
- **JSON Output**: Structured results for easy analysis
- **Cross-Platform**: Works on Linux, macOS, and Windows

## Quick Start

### Prerequisites

#### For C++
```bash
# Install C++ compiler with C++17 support
sudo apt-get install g++          # Ubuntu/Debian
# or
brew install gcc                  # macOS
```

#### For Python
```bash
# Install Python 3.7+ 
sudo apt-get install python3      # Ubuntu/Debian
# or
brew install python3              # macOS
```

#### For Java
```bash
# Install Java 8+ (JDK)
sudo apt-get install openjdk-11-jdk  # Ubuntu/Debian
# or
brew install openjdk@11           # macOS
```

### Building and Running

#### C++ Version
```bash
cd algorithms/cpp/
g++ -std=c++17 -pthread -O2 -I. algorithms.cpp -o algorithms
./algorithms --file ../../resources/data/random_100.txt --algorithms quick_sort,merge_sort --runs 5
```

#### Python Version
```bash
cd algorithms/python/
python3 algorithms.py --file ../../resources/data/random_100.txt --algorithms quick_sort,merge_sort --runs 5
```

#### Java Version
```bash
cd algorithms/java/
javac -cp gson-2.10.1.jar SortingAlgorithms.java
java -cp .:gson-2.10.1.jar SortingAlgorithms --file ../../resources/data/random_100.txt --algorithms quick_sort,merge_sort --runs 5
```

## Usage Examples

### Basic Algorithm Testing
```bash
# Test a single algorithm with default settings
./algorithms --file data.txt --algorithms quick_sort

# Test multiple algorithms with custom runs
./algorithms --file data.txt --algorithms bubble_sort,quick_sort,merge_sort --runs 10
```

### Performance Comparison
```bash
# C++ performance test
cd algorithms/cpp/
./performance_benchmark.sh

# Python performance test  
cd algorithms/python/
./performance_benchmark.sh

# Java performance test
cd algorithms/java/
./performance_benchmark.sh

# Cross-language comparison
cd algorithms/python/
./compare_languages.sh
```

### Quick Validation
```bash
# Validate C++ implementation
cd algorithms/cpp/
./quick_test.sh

# Validate Python implementation
cd algorithms/python/
./quick_test.sh

# Validate Java implementation
cd algorithms/java/
./quick_test.sh
```

## Output Format

All three implementations produce identical JSON output:

```json
[
    {
        "algorithm": "quick_sort",
        "runs": 5,
        "times": [0.001234, 0.001456, 0.001123, 0.001345, 0.001289],
        "average_time": 0.001289,
        "min_time": 0.001123,
        "max_time": 0.001456,
        "std_deviation": 0.000123
    },
    {
        "algorithm": "merge_sort",
        "runs": 5,
        "times": [0.001567, 0.001634, 0.001598, 0.001612, 0.001589],
        "average_time": 0.001600,
        "min_time": 0.001567,
        "max_time": 0.001634,
        "std_deviation": 0.000025
    }
]
```

## Performance Comparison

### Expected Performance Characteristics

#### C++
- **Execution Speed**: Fastest (compiled machine code)
- **Memory Usage**: Lowest overhead
- **Startup Time**: Minimal
- **Concurrency**: True multi-threading

#### Python
- **Execution Speed**: Slower (interpreted)
- **Memory Usage**: Higher overhead
- **Startup Time**: Longer (interpreter startup)
- **Concurrency**: Multi-threading with GIL considerations

#### Java
- **Execution Speed**: Fast (JIT compilation benefits)
- **Memory Usage**: Moderate overhead (JVM managed)
- **Startup Time**: Medium (JVM initialization)
- **Concurrency**: True multi-threading with ExecutorService

### Typical Performance Ratios
- C++ is typically **5-15x faster** than Python for CPU-intensive algorithms
- Java is typically **2-5x faster** than Python after JIT warm-up
- C++ is typically **1.5-3x faster** than Java for computational tasks
- Memory usage: **C++ < Java < Python**
- Startup time: **C++ < Java < Python**

## Available Scripts

### Testing Scripts (All Languages)
- `quick_test.sh` - Quick validation and basic functionality test
- `test_algorithms.sh` - Comprehensive algorithm testing with various datasets
- `performance_benchmark.sh` - Performance benchmarking with multiple dataset sizes
- `verify_correctness.sh` - Correctness verification against known results

### Additional Python Scripts
- `compare_languages.sh` - Cross-language performance comparison

## Input Data Formats

### Supported Input
- **Space-separated integers**: `64 34 25 12 22 11 90`
- **Newline-separated integers**: Each number on a separate line
- **Mixed whitespace**: Any combination of spaces, tabs, newlines

### Sample Data Files
The `resources/data/` directory contains pre-generated test datasets:
- `random_10.txt` - 10 random integers
- `random_100.txt` - 100 random integers  
- `random_1000.txt` - 1000 random integers
- `sorted_data.txt` - Pre-sorted data for best-case testing
- `reverse_sorted.txt` - Reverse-sorted data for worst-case testing

## Error Handling

All three implementations handle:
- **Invalid file paths**: Clear error messages
- **Malformed data**: Graceful parsing with error reporting
- **Invalid algorithm names**: Suggestions for correct names
- **Invalid parameters**: Input validation with helpful messages
- **System errors**: File permissions, memory issues, etc.

## Development

### Code Style
- **C++**: Modern C++17 features, RAII principles, STL containers
- **Python**: PEP 8 compliance, type hints, clear function documentation
- **Java**: Oracle/Google Java style, proper OOP principles, comprehensive documentation
- **All**: Consistent naming, comprehensive error handling, extensive comments

### Testing Strategy
- **Unit Testing**: Each algorithm tested individually
- **Integration Testing**: Full workflow validation
- **Performance Testing**: Statistical significance with multiple runs
- **Correctness Testing**: Verification against known results
- **Cross-Platform Testing**: Linux, macOS, Windows compatibility

### Adding New Algorithms

To add a new sorting algorithm:

1. **Implement in all three languages** with identical logic
2. **Add to algorithm selection** in all CLI parsers
3. **Update documentation** in all README files
4. **Add test cases** to verification scripts
5. **Update help text** and usage examples

## Contributing

1. **Fork the repository**
2. **Create feature branch**: `git checkout -b feature/new-algorithm`
3. **Implement in all three languages** with identical functionality
4. **Add comprehensive tests** and documentation
5. **Verify cross-platform compatibility**
6. **Submit pull request** with detailed description

## License

This project is open source. See individual implementation directories for specific license information.

## Educational Value

This project demonstrates:
- **Language Comparison**: Direct performance comparison between C++, Python, and Java
- **Algorithm Analysis**: Practical implementation of classic sorting algorithms
- **Software Engineering**: Multi-threading, error handling, testing strategies
- **Data Analysis**: Statistical analysis and JSON data handling
- **Cross-Platform Development**: Consistent behavior across operating systems

## Research Applications

Ideal for:
- **Performance Studies**: Quantitative analysis of language performance
- **Algorithm Education**: Teaching sorting algorithms with practical examples
- **Benchmarking Research**: Standardized testing framework
- **Language Evaluation**: Comparing implementation approaches
- **Concurrency Studies**: Multi-threading performance analysis
