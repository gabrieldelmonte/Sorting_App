# Sorting Algorithms Comparison GUI

A comprehensive Tkinter-based graphical user interface for visualizing and comparing the performance of sorting algorithms across different programming languages (C++, Python, Java).

## Features

### Left Panel Controls
- **Language Selection**: Choose which programming languages to include in the comparison (C++, Python, Java)
- **Algorithm Selection**: Select specific sorting algorithms to analyze:
  - Bubble Sort
  - Bucket Sort
  - Counting Sort
  - Heap Sort
  - Insertion Sort
  - Merge Sort
  - Quick Sort
  - Radix Sort
  - Selection Sort

- **Number of Runs**: Set the number of benchmark runs (1-15)
  - Slider for quick adjustment
  - Text input box for precise values
- **Number of Elements**: Configure the dataset size (100-500,000 elements)
  - Slider for quick adjustment
  - Text input box for precise values
- **Perturbation Level**: Control dataset randomness (0.0-1.0)
  - 0.0 = fully sorted array (best case for some algorithms)
  - 1.0 = fully random array (average case)
  - Slider and text input for precise control
- **Plot Type Selection**: Choose what metric to visualize:
  - Average Time
  - Minimum Time
  - Maximum Time
  - Standard Deviation
- **Run Algorithms**: Execute new benchmarks with current settings
- **Control Buttons**: Update plots, export results, reload data

### Right Panel Visualization
- **Bar Chart Comparison**: Side-by-side comparison of selected algorithms across languages
- **Trend Line Plot**: Detailed performance trends showing algorithm behavior
- **Interactive Navigation**: Zoom, pan, and navigate through the plots
- **Export Functionality**: Save plots as PNG, PDF, or SVG files

## Requirements

- Python 3.7+
- matplotlib >= 3.5.0
- numpy >= 1.21.0
- tkinter (usually included with Python)

## Installation

1. Install required packages:
```bash
pip install -r requirements.txt
```

2. Ensure you have result data files in the `../resources/results/` directory:
   - `results_cpp.json`
   - `results_python.json`
   - `results_java.json`

   **Note**: If you don't have real benchmark data, you can generate demo data:
   ```bash
   python generate_demo_data.py
   ```

## Usage

### Quick Start
```bash
# Generate demo data (if needed)
python generate_demo_data.py

# Run the GUI
python sorting_gui.py

# Or use the launcher script
./launch_gui.sh
```

### Running the GUI
```bash
python sorting_gui.py
```

### Using the Interface

1. **Select Languages**: Check/uncheck the desired programming languages for comparison
2. **Choose Algorithms**: Select which sorting algorithms to include in the analysis
   - Use "Select All" or "Deselect All" for quick selection
3. **Configure Parameters**: 
   - Set the number of runs using the slider or text input (1-15)
   - Set the number of elements using the slider or text input (100-500,000)
   - Adjust perturbation level (0.0-1.0) to control dataset randomness
4. **Choose Visualization Type**: Select the performance metric to display
5. **Run New Benchmarks**: Click "🚀 Run Algorithms" to execute benchmarks with current settings
6. **Update Plots**: Click "Update Plots" to refresh the visualization
7. **Export Results**: Use "Export Plot" to save the current visualization

### New Benchmark Execution

The GUI now includes the ability to run new benchmarks directly:

- **Interactive Controls**: Both sliders and text input boxes for precise parameter control
- **Large Datasets**: Support for up to 500,000 elements
- **Real-time Execution**: Run algorithms with custom parameters and see results immediately
- **Multi-language Support**: Execute benchmarks for selected languages automatically
- **Auto-compilation**: Automatically detects and recompiles C++ and Java sources when needed
- **Auto-cleanup**: Automatically removes old result files on startup and before new runs
- **Progress Feedback**: Real-time status updates during benchmark execution

### Perturbation Levels

The GUI uses an advanced dataset creator that supports different levels of data randomness:

- **0.0**: Fully sorted array - tests best-case performance
- **0.2**: 80% sorted, 20% random - tests nearly-sorted data
- **0.5**: 50% sorted, 50% random - mixed conditions
- **0.8**: 20% sorted, 80% random - mostly random with some order
- **1.0**: Fully random array - tests average-case performance

This allows you to study how different algorithms perform under various data conditions, from best-case (sorted) to worst-case (completely random) scenarios.

**Default Settings** (recommended for first-time users):
- All 9 algorithms selected
- 2 runs for quick execution
- 1,000 elements for moderate dataset size
- 1.0 perturbation level (fully random data)

### Data Format

The GUI expects JSON result files with the following structure:
```json
[
    {
        "algorithm": "quick_sort",
        "runs": 5,
        "times": [0.001, 0.002, 0.0015, 0.0018, 0.0016],
        "average_time": 0.0016,
        "min_time": 0.001,
        "max_time": 0.002,
        "std_deviation": 0.0003
    }
]
```

## Features in Detail

### Interactive Controls
- **Real-time Updates**: Changes to selections automatically trigger plot updates
- **Status Feedback**: Status bar shows current operation state and any errors
- **Flexible Selection**: Mix and match languages and algorithms for custom comparisons

### Visualization Types
- **Grouped Bar Charts**: Easy comparison of performance metrics across languages
- **Line Plots**: Show performance trends and patterns
- **Grid Lines**: Improve readability of numerical values
- **Color Coding**: Distinct colors for each language/algorithm

### Export Options
- **Multiple Formats**: PNG, PDF, SVG support
- **High Quality**: 300 DPI export for publication-ready graphics
- **Customizable**: Full matplotlib navigation toolbar included

## Troubleshooting

### Common Issues

1. **"No data found" error**: 
   - Check that result JSON files exist in `../resources/results/`
   - Verify JSON file format matches expected structure

2. **Import errors**:
   - Install required packages: `pip install matplotlib numpy`
   - Ensure Python version is 3.7 or higher

3. **Plot not updating**:
   - Check that at least one language and algorithm are selected
   - Click "Reload Data" to refresh from files
   - Verify result files contain the selected algorithms

4. **C++ execution errors**:
   - Ensure g++ compiler is installed and available in PATH
   - Check that `algorithms/cpp/algorithms.cpp` source file exists
   - **Auto-compilation**: The GUI automatically detects when C++ source is newer than executable and recompiles as needed

5. **Java execution errors**:
   - Ensure Java is installed and available in PATH
   - Check that `algorithms/java/bin/` contains compiled `.class` files
   - Verify `algorithms/java/lib/gson-2.10.1.jar` exists
   - Run `./run.sh --help` from the java directory to test compilation
   - **Auto-compilation**: The GUI automatically detects when Java source is newer than compiled classes and recompiles as needed

### File Structure
```
ui/
├── sorting_gui.py          # Main GUI application
├── test_gui.py            # Test script for validation
├── generate_demo_data.py   # Demo data generator
├── launch_gui.sh          # Launcher script
├── requirements.txt       # Python dependencies
└── README.md             # This file
```

## Future Enhancements

- Support for custom result file locations
- Additional plot types (scatter plots, box plots)
- Statistical significance testing
- Real-time benchmarking integration
- Custom styling and themes
- Data filtering and sorting options

## License

This GUI component is part of the Sorting Algorithms Comparison Project and follows the same license terms as the main project.
