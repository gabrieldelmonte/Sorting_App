#!/bin/bash

# Quick Test Version - Uses smaller dataset for fast verification
# This is a lightweight version of run_all_tests.sh for quick testing

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration for quick testing
DATASET_SIZE=100
RUNS_PER_ALGORITHM=2
TEST_DATA_FILE="quick_test_dataset.txt"

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ALGORITHMS_DIR="$PROJECT_ROOT/algorithms"
SETS_DIR="$PROJECT_ROOT/resources/sets"
RESULTS_DIR="$PROJECT_ROOT/resources/results"

# Test with fewer algorithms for speed
ALGORITHMS="quick_sort,merge_sort,heap_sort"

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

print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
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

# Function to check language directory contents
check_language_setup() {
    local lang=$1
    local lang_dir="${LANGUAGE_DIRS[$lang]}"
    
    print_info "Checking $lang setup..."
    
    if [ ! -d "$lang_dir" ]; then
        print_error "$lang directory not found: $lang_dir"
        return 1
    fi
    
    cd "$lang_dir" || return 1
    
    case $lang in
        "cpp")
            print_info "C++ directory contents:"
            ls -la | grep -E '\.(cpp|h|hpp|Makefile)$|^sorting' | sed 's/^/  /'
            ;;
        "python")
            print_info "Python directory contents:"
            ls -la | grep -E '\.py$' | sed 's/^/  /'
            ;;
        "java")
            print_info "Java directory contents:"
            ls -la | grep -E '\.(java|jar|class)$|^(src|lib|bin)' | sed 's/^/  /'
            if [ -d "lib" ]; then
                echo "  lib contents:"
                ls -la lib/ | sed 's/^/    /'
            fi
            ;;
    esac
    
    return 0
}

# Quick test function
quick_test() {
    echo "========================================================================"
    print_status $YELLOW "Quick Test - Sorting Algorithms"
    echo "========================================================================"
    
    print_info "Configuration: $DATASET_SIZE elements, $RUNS_PER_ALGORITHM runs, algorithms: $ALGORITHMS"
    
    # Create quick test dataset
    cd "$SETS_DIR" || {
        print_error "Could not navigate to sets directory"
        return 1
    }
    
    if [ ! -f "creator" ]; then
        print_info "Building creator..."
        make
    fi
    
    print_info "Creating quick test dataset..."
    ./creator --size $DATASET_SIZE --distribution uniform --perturbation 1.0 --output "$TEST_DATA_FILE"
    
    if [ $? -ne 0 ]; then
        print_error "Failed to create test dataset"
        return 1
    fi
    
    # Test each language
    local languages=("cpp" "python" "java")
    local success_count=0
    
    # First, check all language setups
    print_info "Performing setup diagnostics..."
    for lang in "${languages[@]}"; do
        check_language_setup "$lang"
        echo ""
    done
    
    for lang in "${languages[@]}"; do
        print_info "Testing $lang implementation..."
        
        local lang_dir="${LANGUAGE_DIRS[$lang]}"
        local command="${LANGUAGE_COMMANDS[$lang]}"
        
        cd "$lang_dir" || {
            print_error "Could not navigate to $lang directory"
            continue
        }
        
        # Copy test dataset
        cp "$SETS_DIR/$TEST_DATA_FILE" .
        
        # Build if needed
        local build_success=true
        case $lang in
            "cpp")
                if [ ! -f "algorithms" ]; then
                    print_info "Building C++..."
                    if [ -f "Makefile" ]; then
                        make 2>/dev/null
                        if [ $? -ne 0 ]; then
                            print_error "C++ build failed"
                            build_success=false
                        fi
                    else
                        # Try direct compilation
                        print_info "No Makefile found, trying direct compilation..."
                        g++ -std=c++11 -Wall -O2 -o algorithms algorithms.cpp 2>/dev/null
                        if [ $? -ne 0 ]; then
                            print_error "Direct C++ compilation failed"
                            build_success=false
                        fi
                    fi
                fi
                ;;
            "java")
                if [ ! -f "bin/SortingAlgorithms.class" ]; then
                    print_info "Building Java..."
                    mkdir -p bin
                    javac -cp "lib/*:src" -d bin src/SortingAlgorithms.java 2>/dev/null
                    if [ $? -ne 0 ]; then
                        print_error "Java compilation failed"
                        build_success=false
                    fi
                fi
                ;;
            "python")
                # Check if Python file exists
                if [ ! -f "algorithms.py" ]; then
                    print_error "Python file algorithms.py not found"
                    build_success=false
                fi
                ;;
        esac
        
        # Run quick test only if build succeeded
        if [ "$build_success" = true ]; then
            print_info "Running $lang test..."
            
            # Capture both stdout and stderr for debugging
            local test_output
            test_output=$(timeout 60s $command --file "$TEST_DATA_FILE" --algorithms "$ALGORITHMS" --runs $RUNS_PER_ALGORITHM 2>&1)
            local test_exit_code=$?
            
            if [ $test_exit_code -eq 0 ]; then
                print_success "$lang test passed"
                ((success_count++))
            else
                print_error "$lang test failed (exit code: $test_exit_code)"
                # Show first few lines of error for debugging
                if [ -n "$test_output" ] && [ "${VERBOSE:-false}" = true ]; then
                    echo "  Error details:"
                    echo "$test_output" | head -3 | sed 's/^/  /'
                fi
            fi
        else
            print_error "$lang test skipped due to build failure"
        fi
        
        # Cleanup
        rm -f "$TEST_DATA_FILE"
    done
    
    # Cleanup original dataset
    rm -f "$SETS_DIR/$TEST_DATA_FILE"
    
    echo ""
    print_info "Quick test results: $success_count/3 languages passed"
    
    if [ $success_count -eq 3 ]; then
        print_success "All quick tests passed! Ready to run full test suite."
        return 0
    else
        print_error "Some quick tests failed. Check your implementations."
        return 1
    fi
}

# Main execution
case "${1:-}" in
    "--help"|"-h")
        echo "Quick Test Script for Sorting Algorithms"
        echo ""
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --help, -h    Show this help message"
        echo "  --verbose     Show detailed output and error messages"
        echo ""
        echo "This script runs a quick verification test with:"
        echo "  - Dataset size: $DATASET_SIZE elements"
        echo "  - Runs per algorithm: $RUNS_PER_ALGORITHM"
        echo "  - Algorithms: $ALGORITHMS"
        echo ""
        echo "Use this before running the full test suite to verify everything works."
        ;;
    "--verbose"|"-v")
        VERBOSE=true
        quick_test
        ;;
    *)
        VERBOSE=false
        quick_test
        ;;
esac
