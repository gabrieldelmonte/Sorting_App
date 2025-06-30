#!/bin/bash
# Launcher script for Sorting Algorithms Comparison GUI

echo "Starting Sorting Algorithms Comparison GUI..."
echo "========================================"

# Check if we're in the correct directory
if [ ! -f "sorting_gui.py" ]; then
    echo "Error: sorting_gui.py not found in current directory"
    echo "Please run this script from the ui/ directory"
    exit 1
fi

# Check if result files exist
RESULTS_DIR="../resources/results"
if [ ! -d "$RESULTS_DIR" ]; then
    echo "Warning: Results directory not found at $RESULTS_DIR"
    echo "The GUI will still launch but may not display data"
fi

# Check for result files
for lang in cpp python java; do
    if [ ! -f "$RESULTS_DIR/results_${lang}.json" ]; then
        echo "Warning: results_${lang}.json not found"
    else
        echo "Found: results_${lang}.json"
    fi
done

echo ""
echo "Launching GUI..."

# Run the GUI
python3 sorting_gui.py

echo "GUI closed."
