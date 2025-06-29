# Tests Directory

This directory contains comprehensive test scripts for the Sorting Algorithms project.

## Files

- `run_all_tests.sh` - Master test script that runs all language implementations
- `quick_test.sh` - Quick verification script for fast testing

## Master Test Script

The `run_all_tests.sh` script provides a comprehensive testing suite that:

### Features

1. **Creates a single test dataset** (10,000 elements) used across all implementations
2. **Tests all 3 language implementations**: C++, Python, and Java
3. **Runs all 9 sorting algorithms**: bubble_sort, selection_sort, insertion_sort, quick_sort, merge_sort, heap_sort, counting_sort, radix_sort, bucket_sort
4. **Executes 5 runs per algorithm** for statistical accuracy
5. **Automatically builds** all implementations
6. **Generates JSON results** for each language
7. **Creates summary reports** with performance analysis

### Usage

```bash
# Run all tests
./run_all_tests.sh

# Show help
./run_all_tests.sh -h
./run_all_tests.sh --help

# Clean build artifacts
./run_all_tests.sh --clean

# Run with detailed output and error messages
./run_all_tests.sh --verbose
./run_all_tests.sh -v
```

### Test Process

The script follows this sequence:

1. **Prerequisites Check**: Verifies all required tools (g++, python3, java, make)
2. **Dataset Creation**: Generates a uniform random dataset using the creator tool
3. **Build Phase**: Compiles C++ and Java implementations, validates Python
4. **Test Execution**: Runs each language implementation with identical parameters
5. **Results Analysis**: Analyzes generated JSON files and creates summary
6. **Cleanup**: Removes temporary files, preserves results

### Configuration

Default settings in the script:
```bash
DATASET_SIZE=10000          # Array size for testing
RUNS_PER_ALGORITHM=5        # Number of runs per algorithm
TEST_DATA_FILE="test_dataset.txt"  # Temporary dataset filename
```

### Output

The script generates:

- `results_cpp.json` - C++ implementation results
- `results_python.json` - Python implementation results  
- `results_java.json` - Java implementation results
- `test_summary_YYYYMMDD_HHMMSS.txt` - Execution summary

All results are saved in `../resources/results/` directory.

### Example Output

```
========================================================================
Comprehensive Sorting Algorithms Test Suite
========================================================================
ℹ Project Root: /path/to/Sorting_App
ℹ Test Configuration:
  - Dataset Size: 10000 elements
  - Runs per Algorithm: 5
  - Languages: C++, Python, Java
  - Algorithms: bubble_sort selection_sort insertion_sort quick_sort merge_sort heap_sort counting_sort radix_sort bucket_sort

>>> Checking Prerequisites
✓ g++ compiler found
✓ Python 3 found
✓ Java found
✓ Make found

>>> Creating Test Dataset
ℹ Compiling dataset creator...
ℹ Generating dataset with 10000 elements...
✓ Test dataset created: test_dataset.txt

... (build and test phases) ...

========================================================================
All Tests Completed Successfully! 🎉
========================================================================
✓ Check the results in: /path/to/resources/results
```

### Error Handling

The script includes robust error handling:
- Validates all prerequisites before starting
- Checks build success for each language
- Verifies dataset creation
- Stops execution on critical failures
- Provides clear error messages with suggested fixes

### Performance Analysis

After completion, the script provides:
- Algorithm execution counts
- Average execution times
- Result file statistics
- Comparative analysis across languages

This comprehensive test suite ensures fair and accurate comparison between all language implementations using identical datasets and test conditions.

## Quick Test Script

The `quick_test.sh` script provides a lightweight verification tool that:

### Features

1. **Fast Verification**: Uses a smaller dataset (100 elements) for quick testing
2. **Core Algorithm Testing**: Tests 3 key algorithms (quick_sort, merge_sort, heap_sort)
3. **Reduced Runs**: Executes only 2 runs per algorithm for speed
4. **Prerequisites Validation**: Ensures all implementations work before full testing
5. **Timeout Protection**: 60-second timeout per language to prevent hanging
6. **Build Verification**: Checks if compilation works for all languages

### Usage

```bash
# Run quick verification
./quick_test.sh

# Show help
./quick_test.sh -h
./quick_test.sh --help
```

### When to Use Quick Test

- **Before Full Testing**: Verify all implementations work correctly
- **Development**: Quick validation during code changes
- **CI/CD**: Fast automated testing in build pipelines
- **Troubleshooting**: Isolate issues without waiting for full test suite

### Configuration

Quick test settings:
```bash
DATASET_SIZE=100           # Small array for fast testing
RUNS_PER_ALGORITHM=2       # Minimal runs for verification
ALGORITHMS="quick_sort,merge_sort,heap_sort"  # Core algorithms only
```

### Expected Output

```
========================================================================
Quick Test - Sorting Algorithms
========================================================================
ℹ Configuration: 100 elements, 2 runs, algorithms: quick_sort,merge_sort,heap_sort
ℹ Creating quick test dataset...
ℹ Testing cpp implementation...
✓ cpp test passed
ℹ Testing python implementation...
✓ python test passed
ℹ Testing java implementation...
✓ java test passed

ℹ Quick test results: 3/3 languages passed
✓ All quick tests passed! Ready to run full test suite.
```

### Verbose Mode

Both test scripts support a `--verbose` (or `-v`) option that provides detailed output:

#### Quick Test Verbose Features
- **Directory Contents**: Shows source files in each language directory
- **Build Commands**: Displays actual compilation commands
- **Error Details**: Shows first few lines of error output when tests fail
- **Setup Diagnostics**: Lists all files and dependencies before testing

#### Full Test Verbose Features
- **Build Process**: Shows complete compilation output and commands
- **Directory Analysis**: Lists all source files and dependencies
- **Command Execution**: Displays the exact commands being run
- **Detailed Statistics**: Shows min/max/std deviation for all algorithms
- **Error Reporting**: Captures and displays error messages when failures occur
- **Results Preview**: Shows sample timing data from JSON results

#### When to Use Verbose Mode
- **Debugging**: When tests fail and you need to see what went wrong
- **Development**: Understanding the build and execution process
- **CI/CD**: Logging detailed information for automated builds
- **Learning**: Seeing exactly how the tools work behind the scenes

#### Examples
```bash
# Quick test with verbose output
./quick_test.sh --verbose

# Full test with verbose output  
./run_all_tests.sh --verbose

# Both support short form
./quick_test.sh -v
./run_all_tests.sh -v
```

## Test Comparison

| Feature | Quick Test | Full Test |
|---------|------------|-----------|
| Dataset Size | 100 elements | 10,000 elements |
| Algorithms | 3 core algorithms | All 9 algorithms |
| Runs per Algorithm | 2 runs | 5 runs |
| Execution Time | ~30 seconds | ~5-10 minutes |
| Purpose | Verification | Benchmarking |
| Output | Pass/Fail status | JSON results + analysis |
| Verbose Option | `--verbose` or `-v` | `--verbose` or `-v` |

## Quick Start

### Recommended Workflow

```bash
# Navigate to tests directory
cd /home/gabriel/Documents/UNIFEI/Semestres/2025_1/ECOS04/Trabalho/Sorting_App/tests

# Step 1: Run quick verification first (recommended)
./quick_test.sh

# Step 2: If quick test passes, run full test suite
./run_all_tests.sh

# Alternative: Clean previous builds if needed
./run_all_tests.sh --clean
```

### Test Strategy

1. **Development Phase**: Use `quick_test.sh` for rapid iteration
2. **Pre-Commit**: Run `quick_test.sh` before committing changes  
3. **Benchmarking**: Use `run_all_tests.sh` for comprehensive performance analysis
4. **Troubleshooting**: Start with `quick_test.sh` to isolate issues

## Output Files

### Quick Test
- **Console Output Only**: Pass/fail status for each language
- **No Persistent Files**: Cleans up temporary files automatically

### Full Test Suite
All results saved to `../resources/results/`:
- `results_cpp.json` - C++ implementation results
- `results_python.json` - Python implementation results  
- `results_java.json` - Java implementation results
- `test_summary_YYYYMMDD_HHMMSS.txt` - Execution summary

## Troubleshooting

### Common Issues

**Quick Test Fails:**
1. Check if all compilers are installed (g++, javac, python3)
2. Verify source files exist in each language directory
3. Run `./run_all_tests.sh --clean` to reset build artifacts

**Full Test Takes Too Long:**
1. Reduce `DATASET_SIZE` in script (default: 10,000)
2. Reduce `RUNS_PER_ALGORITHM` (default: 5)
3. Test fewer algorithms by modifying `ALGORITHMS` variable

**Java Import Errors:**
1. Ensure GSON jar is in `algorithms/java/lib/`
2. Check classpath in Java compilation command
3. Verify VS Code Java extension settings

**Permission Denied:**
```bash
chmod +x *.sh  # Make scripts executable
```

The test suite provides both quick verification and comprehensive benchmarking capabilities, ensuring reliable and efficient testing of all sorting algorithm implementations.
