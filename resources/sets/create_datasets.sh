#!/bin/bash

# Data Set Creator - Easy Usage Script
# This script compiles and runs the data set creator with common configurations

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Data Set Creator - Build and Run${NC}"
echo "================================="

# Check if creator executable exists, if not compile it
if [ ! -f "creator" ]; then
    echo -e "${YELLOW}Compiling creator...${NC}"
    make
    if [ $? -ne 0 ]; then
        echo -e "${RED}Compilation failed!${NC}"
        exit 1
    fi
    echo -e "${GREEN}Compilation successful!${NC}"
fi

# Function to create a data set
create_dataset() {
    local size=$1
    local distribution=$2
    local perturbation=$3
    local filename=$4
    
    echo -e "${YELLOW}Creating dataset: $filename${NC}"
    echo "  Size: $size elements"
    echo "  Distribution: $distribution"
    echo "  Perturbation: $perturbation"
    
    ./creator --size $size --distribution $distribution --perturbation $perturbation --output $filename
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Dataset created successfully: $filename${NC}"
    else
        echo -e "${RED}Failed to create dataset: $filename${NC}"
    fi
    echo ""
}

# Check command line arguments
if [ $# -eq 0 ]; then
    echo "Usage: $0 [quick|custom|help]"
    echo ""
    echo "Options:"
    echo "  quick   - Create predefined test datasets"
    echo "  custom  - Interactive mode to create custom dataset"
    echo "  help    - Show creator help"
    echo ""
    exit 1
fi

case "$1" in
    "quick")
        echo -e "${YELLOW}Creating quick test datasets...${NC}"
        echo ""
        
        # Small datasets for quick testing
        create_dataset 100 uniform 1.0 "small_random.txt"
        create_dataset 100 uniform 0.0 "small_sorted.txt"
        create_dataset 100 normal 0.5 "small_normal.txt"
        
        # Medium datasets
        create_dataset 1000 uniform 1.0 "medium_random.txt"
        create_dataset 1000 exponential 0.8 "medium_exp.txt"
        
        # Large dataset
        create_dataset 10000 uniform 1.0 "large_random.txt"
        
        echo -e "${GREEN}Quick datasets created!${NC}"
        echo "Files created:"
        ls -la *.txt 2>/dev/null || echo "No .txt files found"
        ;;
        
    "custom")
        echo -e "${YELLOW}Interactive Dataset Creator${NC}"
        echo ""
        
        # Get user input
        read -p "Enter array size (1-500000): " size
        echo "Available distributions: uniform, normal, exponential, beta"
        read -p "Enter distribution type: " distribution
        read -p "Enter perturbation level (0.0-1.0): " perturbation
        read -p "Enter output filename: " filename
        
        # Validate inputs
        if ! [[ "$size" =~ ^[0-9]+$ ]] || [ "$size" -lt 1 ] || [ "$size" -gt 500000 ]; then
            echo -e "${RED}Invalid size. Must be between 1 and 500000.${NC}"
            exit 1
        fi
        
        if ! [[ "$perturbation" =~ ^[0-9]*\.?[0-9]+$ ]]; then
            echo -e "${RED}Invalid perturbation level. Must be a number between 0.0 and 1.0.${NC}"
            exit 1
        fi
        
        create_dataset $size $distribution $perturbation $filename
        ;;
        
    "help")
        ./creator --help
        ;;
        
    *)
        echo -e "${RED}Unknown option: $1${NC}"
        echo "Use: $0 [quick|custom|help]"
        exit 1
        ;;
esac
