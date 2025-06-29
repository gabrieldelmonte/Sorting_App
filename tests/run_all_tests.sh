#!/bin/bash

# Comprehensive Sorting Algorithms Test Suite
# Runs all sorting algorithms across all language implementations
# Uses the same dataset for fair comparison

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
DATASET_SIZE=10000
RUNS_PER_ALGORITHM=5
TEST_DATA_FILE="test_dataset.txt"

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ALGORITHMS_DIR="$PROJECT_ROOT/algorithms"
RESOURCES_DIR="$PROJECT_ROOT/resources"
SETS_DIR="$RESOURCES_DIR/sets"
RESULTS_DIR="$RESOURCES_DIR/results"

# All available sorting algorithms
ALGORITHMS="bubble_sort,selection_sort,insertion_sort,quick_sort,merge_sort,heap_sort,counting_sort,radix_sort,bucket_sort"

# Language implementations
declare -A LANGUAGE_DIRS=(
    ["cpp"]="$ALGORITHMS_DIR/cpp"
    ["python"]="$ALGORITHMS_DIR/python"
    ["java"]="$ALGORITHMS_DIR/java"
)

declare -A LANGUAGE_COMMANDS=(
    ["cpp"]="./algorithms"
    ["python"]="python3 algorithms.py"
    ["java"]="java -cp bin:lib/* SortingAlgorithms"
)

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_header() {
    echo ""
    echo "========================================================================"
    print_status $CYAN "$1"
    echo "========================================================================"
}

print_section() {
    echo ""
    print_status $YELLOW ">>> $1"
}

print_success() {
    print_status $GREEN "✓ $1"
}

print_error() {
    print_status $RED "✗ $1"
}

print_info() {
    print_status $BLUE "ℹ $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to create test dataset
create_test_dataset() {
    print_section "Creating Test Dataset"
    
    cd "$SETS_DIR" || {
        print_error "Could not navigate to sets directory: $SETS_DIR"
        return 1
    }
    
    # Compile creator if needed
    if [ ! -f "creator" ]; then
        print_info "Compiling dataset creator..."
        make
        if [ $? -ne 0 ]; then
            print_error "Failed to compile dataset creator"
            return 1
        fi
    fi
    
    # Create test dataset
    print_info "Generating dataset with $DATASET_SIZE elements..."
    ./creator --size $DATASET_SIZE --distribution uniform --perturbation 1.0 --output "$TEST_DATA_FILE"
    
    if [ $? -eq 0 ]; then
        print_success "Test dataset created: $TEST_DATA_FILE"
        
        # Copy dataset to each language directory for easy access
        for lang in "${!LANGUAGE_DIRS[@]}"; do
            cp "$TEST_DATA_FILE" "${LANGUAGE_DIRS[$lang]}/"
            print_info "Dataset copied to $lang directory"
        done
        
        return 0
    else
        print_error "Failed to create test dataset"
        return 1
    fi
}

# Function to build C++ implementation
build_cpp() {
    print_section "Building C++ Implementation"
    
    cd "${LANGUAGE_DIRS[cpp]}" || {
        print_error "Could not navigate to C++ directory"
        return 1
    }
    
    if [ "${VERBOSE:-false}" = true ]; then
        print_info "C++ directory contents:"
        ls -la | grep -E '\.(cpp|h|hpp|Makefile)$|^algorithms' | sed 's/^/  /'
    fi
    
    if [ ! -f "Makefile" ]; then
        print_error "No Makefile found in C++ directory, trying direct compilation"
        if [ "${VERBOSE:-false}" = true ]; then
            print_info "Running: g++ -std=c++11 -Wall -O2 -o algorithms algorithms.cpp"
            g++ -std=c++11 -Wall -O2 -o algorithms algorithms.cpp
        else
            g++ -std=c++11 -Wall -O2 -o algorithms algorithms.cpp 2>/dev/null
        fi
        if [ $? -eq 0 ]; then
            print_success "C++ implementation built successfully (direct compilation)"
            return 0
        else
            print_error "Failed to build C++ implementation"
            return 1
        fi
    fi
    
    if [ "${VERBOSE:-false}" = true ]; then
        print_info "Running: make clean && make"
        make clean && make
    else
        make clean && make 2>/dev/null
    fi
    if [ $? -eq 0 ]; then
        print_success "C++ implementation built successfully"
        return 0
    else
        print_error "Failed to build C++ implementation"
        return 1
    fi
}

# Function to build Java implementation
build_java() {
    print_section "Building Java Implementation"
    
    cd "${LANGUAGE_DIRS[java]}" || {
        print_error "Could not navigate to Java directory"
        return 1
    }
    
    if [ "${VERBOSE:-false}" = true ]; then
        print_info "Java directory contents:"
        ls -la | grep -E '\.(java|jar|class)$|^(src|lib|bin)' | sed 's/^/  /'
        if [ -d "lib" ]; then
            echo "  lib contents:"
            ls -la lib/ | sed 's/^/    /'
        fi
    fi
    
    # Create bin directory if it doesn't exist
    mkdir -p bin
    
    # Compile Java source
    if [ "${VERBOSE:-false}" = true ]; then
        print_info "Running: javac -cp lib/*:src -d bin src/SortingAlgorithms.java"
        javac -cp "lib/*:src" -d bin src/SortingAlgorithms.java
    else
        javac -cp "lib/*:src" -d bin src/SortingAlgorithms.java 2>/dev/null
    fi
    if [ $? -eq 0 ]; then
        print_success "Java implementation built successfully"
        return 0
    else
        print_error "Failed to build Java implementation"
        return 1
    fi
}

# Function to check Python implementation
check_python() {
    print_section "Checking Python Implementation"
    
    cd "${LANGUAGE_DIRS[python]}" || {
        print_error "Could not navigate to Python directory"
        return 1
    }
    
    if [ "${VERBOSE:-false}" = true ]; then
        print_info "Python directory contents:"
        ls -la | grep -E '\.py$' | sed 's/^/  /'
    fi
    
    if [ ! -f "algorithms.py" ]; then
        print_error "Python implementation not found"
        return 1
    fi
    
    # Check if required modules are available
    if [ "${VERBOSE:-false}" = true ]; then
        print_info "Checking Python modules: json, argparse, time, statistics, threading"
    fi
    python3 -c "import json, argparse, time, statistics, threading" 2>/dev/null
    if [ $? -eq 0 ]; then
        print_success "Python implementation ready"
        return 0
    else
        print_error "Required Python modules not available"
        return 1
    fi
}

# Function to run sorting algorithms for a specific language
run_language_tests() {
    local lang=$1
    local lang_dir="${LANGUAGE_DIRS[$lang]}"
    local command="${LANGUAGE_COMMANDS[$lang]}"
    
    print_header "Running $lang Implementation Tests"
    
    cd "$lang_dir" || {
        print_error "Could not navigate to $lang directory: $lang_dir"
        return 1
    }
    
    # Check if test data file exists
    if [ ! -f "$TEST_DATA_FILE" ]; then
        print_error "Test dataset not found in $lang directory"
        return 1
    fi
    
    print_info "Dataset: $TEST_DATA_FILE ($(wc -w < "$TEST_DATA_FILE") elements)"
    print_info "Algorithms: $ALGORITHMS"
    print_info "Runs per algorithm: $RUNS_PER_ALGORITHM"
    print_info "Command: $command"
    
    # Run the benchmark
    print_section "Executing benchmark..."
    
    # Record start time
    start_time=$(date +%s)
    
    # Run the command with appropriate output handling
    if [ "${VERBOSE:-false}" = true ]; then
        print_info "Running command with verbose output..."
        $command --file "$TEST_DATA_FILE" --algorithms "$ALGORITHMS" --runs $RUNS_PER_ALGORITHM
        local exit_code=$?
    else
        # Capture output for potential error reporting
        local test_output
        test_output=$($command --file "$TEST_DATA_FILE" --algorithms "$ALGORITHMS" --runs $RUNS_PER_ALGORITHM 2>&1)
        local exit_code=$?
        
        # Show output anyway since this is the main test
        echo "$test_output"
    fi
    
    # Record end time
    end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    if [ $exit_code -eq 0 ]; then
        print_success "$lang implementation completed successfully in ${duration}s"
        
        # Check if results file was created
        local results_file=""
        case $lang in
            "cpp") results_file="../../resources/results/results_cpp.json" ;;
            "python") results_file="../../resources/results/results_python.json" ;;
            "java") results_file="../../resources/results/results_java.json" ;;
        esac
        
        if [ -f "$results_file" ]; then
            print_success "Results saved to: $results_file"
            
            # Show quick stats
            local algorithm_count=$(jq length "$results_file" 2>/dev/null || echo "unknown")
            print_info "Algorithms tested: $algorithm_count"
            
            # Show file size
            local file_size=$(ls -lh "$results_file" | awk '{print $5}')
            print_info "Results file size: $file_size"
            
            # Show additional details in verbose mode
            if [ "${VERBOSE:-false}" = true ]; then
                print_info "Sample results preview:"
                if command -v jq >/dev/null 2>&1; then
                    jq -r '.[] | "  \(.algorithm): avg=\(.average_time)s, min=\(.min_time)s, max=\(.max_time)s"' "$results_file" | head -3
                else
                    head -10 "$results_file" | sed 's/^/  /'
                fi
            fi
        else
            print_error "Results file not found: $results_file"
            if [ "${VERBOSE:-false}" = true ] && [ -n "${test_output:-}" ]; then
                print_info "Command output was:"
                echo "$test_output" | head -10 | sed 's/^/  /'
            fi
        fi
        
        return 0
    else
        print_error "$lang implementation failed with exit code $exit_code"
        if [ "${VERBOSE:-false}" = true ] && [ -n "${test_output:-}" ]; then
            print_info "Error details:"
            echo "$test_output" | head -10 | sed 's/^/  /'
        fi
        return 1
    fi
}

# Function to analyze results
analyze_results() {
    print_header "Results Analysis"
    
    cd "$RESULTS_DIR" || {
        print_error "Could not navigate to results directory"
        return 1
    }
    
    local result_files=("results_cpp.json" "results_python.json" "results_java.json")
    local found_files=()
    
    # Check which result files exist
    for file in "${result_files[@]}"; do
        if [ -f "$file" ]; then
            found_files+=("$file")
            print_success "Found: $file"
        else
            print_error "Missing: $file"
        fi
    done
    
    if [ ${#found_files[@]} -eq 0 ]; then
        print_error "No result files found"
        return 1
    fi
    
    print_section "Result File Statistics"
    
    for file in "${found_files[@]}"; do
        if command_exists jq; then
            print_info "=== $file ==="
            
            # Count algorithms
            local count=$(jq length "$file")
            echo "  Algorithms: $count"
            
            # Show algorithm names
            local algorithms=$(jq -r '.[].algorithm' "$file" | tr '\n' ', ' | sed 's/,$//')
            echo "  Names: $algorithms"
            
            # Show average times
            echo "  Average Times:"
            jq -r '.[] | "    \(.algorithm): \(.average_time)s"' "$file"
            
            # Show additional details in verbose mode
            if [ "${VERBOSE:-false}" = true ]; then
                echo "  Detailed Statistics:"
                jq -r '.[] | "    \(.algorithm): avg=\(.average_time)s, min=\(.min_time)s, max=\(.max_time)s, std=\(.std_deviation)s, runs=\(.runs)"' "$file"
            fi
            
        else
            print_info "$file: $(wc -l < "$file") lines, $(ls -lh "$file" | awk '{print $5}')"
        fi
        echo ""
    done
    
    # Create summary
    print_section "Creating Test Summary"
    
    local summary_file="test_summary_$(date +%Y%m%d_%H%M%S).txt"
    {
        echo "Sorting Algorithms Benchmark Test Summary"
        echo "========================================"
        echo "Date: $(date)"
        echo "Dataset Size: $DATASET_SIZE elements"
        echo "Runs per Algorithm: $RUNS_PER_ALGORITHM"
        echo "Algorithms Tested: $ALGORITHMS"
        echo ""
        echo "Results Files:"
        for file in "${found_files[@]}"; do
            echo "  - $file"
        done
        echo ""
        echo "Test completed successfully!"
    } > "$summary_file"
    
    print_success "Test summary saved to: $summary_file"
}

# Function to cleanup
cleanup() {
    print_section "Cleaning up temporary files"
    
    # Remove test datasets from language directories
    for lang in "${!LANGUAGE_DIRS[@]}"; do
        local test_file="${LANGUAGE_DIRS[$lang]}/$TEST_DATA_FILE"
        if [ -f "$test_file" ]; then
            rm "$test_file"
            print_info "Removed $test_file"
        fi
    done
    
    # Keep the original test dataset in sets directory for reference
    print_info "Original dataset preserved in: $SETS_DIR/$TEST_DATA_FILE"
}

# Main execution function
main() {
    print_header "Comprehensive Sorting Algorithms Test Suite"
    
    print_info "Project Root: $PROJECT_ROOT"
    print_info "Test Configuration:"
    echo "  - Dataset Size: $DATASET_SIZE elements"
    echo "  - Runs per Algorithm: $RUNS_PER_ALGORITHM"
    echo "  - Languages: C++, Python, Java"
    echo "  - Algorithms: $(echo $ALGORITHMS | tr ',' ' ')"
    
    if [ "${VERBOSE:-false}" = true ]; then
        echo "  - Verbose Mode: Enabled"
        echo "  - Working Directory: $(pwd)"
        echo "  - Results Directory: $RESULTS_DIR"
        echo "  - Sets Directory: $SETS_DIR"
    fi
    
    # Check prerequisites
    print_section "Checking Prerequisites"
    
    local prerequisites_ok=true
    
    # Check if required commands exist
    if ! command_exists g++; then
        print_error "g++ compiler not found"
        prerequisites_ok=false
    else
        print_success "g++ compiler found"
    fi
    
    if ! command_exists python3; then
        print_error "Python 3 not found"
        prerequisites_ok=false
    else
        print_success "Python 3 found"
    fi
    
    if ! command_exists javac || ! command_exists java; then
        print_error "Java compiler/runtime not found"
        prerequisites_ok=false
    else
        print_success "Java found"
    fi
    
    if ! command_exists make; then
        print_error "Make not found"
        prerequisites_ok=false
    else
        print_success "Make found"
    fi
    
    if [ "$prerequisites_ok" = false ]; then
        print_error "Prerequisites not met. Please install missing components."
        exit 1
    fi
    
    # Create results directory if it doesn't exist
    mkdir -p "$RESULTS_DIR"
    
    # Execute test phases
    local phase_failed=false
    
    # Phase 1: Create test dataset
    if ! create_test_dataset; then
        phase_failed=true
    fi
    
    # Phase 2: Build implementations
    if [ "$phase_failed" = false ]; then
        if ! build_cpp; then
            print_error "C++ build failed"
            phase_failed=true
        fi
    fi
    
    if [ "$phase_failed" = false ]; then
        if ! check_python; then
            print_error "Python check failed"
            phase_failed=true
        fi
    fi
    
    if [ "$phase_failed" = false ]; then
        if ! build_java; then
            print_error "Java build failed"
            phase_failed=true
        fi
    fi
    
    # Phase 3: Run tests
    if [ "$phase_failed" = false ]; then
        local test_start_time=$(date +%s)
        
        # Run tests for each language
        for lang in cpp python java; do
            if ! run_language_tests "$lang"; then
                print_error "$lang tests failed"
                phase_failed=true
                break
            fi
            
            # Brief pause between language tests
            sleep 2
        done
        
        local test_end_time=$(date +%s)
        local total_duration=$((test_end_time - test_start_time))
        
        print_header "Test Execution Summary"
        print_info "Total test duration: ${total_duration}s"
    fi
    
    # Phase 4: Analysis
    if [ "$phase_failed" = false ]; then
        analyze_results
    fi
    
    # Phase 5: Cleanup
    cleanup
    
    # Final status
    if [ "$phase_failed" = false ]; then
        print_header "All Tests Completed Successfully! 🎉"
        print_success "Check the results in: $RESULTS_DIR"
    else
        print_header "Tests Failed ❌"
        print_error "Some tests did not complete successfully"
        exit 1
    fi
}

# Handle script arguments
    case "${1:-}" in
    "--help"|"-h")
        echo "Comprehensive Sorting Algorithms Test Suite"
        echo ""
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --help, -h    Show this help message"
        echo "  --clean       Clean build artifacts and temporary files"
        echo "  --verbose, -v Show detailed output and error messages"
        echo ""
        echo "This script will:"
        echo "  1. Create a test dataset with $DATASET_SIZE elements"
        echo "  2. Build all language implementations (C++, Python, Java)"
        echo "  3. Run all sorting algorithms $RUNS_PER_ALGORITHM times each"
        echo "  4. Generate performance results in JSON format"
        echo "  5. Create a summary report"
        echo ""
        echo "Results will be saved in: $RESULTS_DIR"
        exit 0
        ;;
    "--clean")
        print_header "Cleaning Build Artifacts"
        
        # Clean C++
        if [ -d "${LANGUAGE_DIRS[cpp]}" ]; then
            cd "${LANGUAGE_DIRS[cpp]}" && make clean 2>/dev/null
            print_info "Cleaned C++ build artifacts"
        fi
        
        # Clean Java
        if [ -d "${LANGUAGE_DIRS[java]}/bin" ]; then
            rm -rf "${LANGUAGE_DIRS[java]}/bin"/*
            print_info "Cleaned Java build artifacts"
        fi
        
        # Clean test files
        cleanup
        
        print_success "Cleanup completed"
        exit 0
        ;;
    "--verbose"|"-v")
        VERBOSE=true
        main
        ;;
    "")
        # No arguments, run main
        VERBOSE=false
        main
        ;;
    *)
        print_error "Unknown option: $1"
        echo "Use --help for usage information"
        exit 1
        ;;
esac
