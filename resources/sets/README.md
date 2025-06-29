# Data Set Creator

This tool creates customizable data sets for testing sorting algorithms with configurable size, distribution types, and perturbation levels.

## Features

- **Dynamic Array Size**: Create arrays from 1 to 500,000 elements
- **Value Range Constraint**: Array elements are constrained to [1, array_size]
- **Multiple Distributions**: Support for uniform, normal, exponential, and beta distributions
- **Perturbation Control**: Specify how much of the array should be pre-sorted
- **Distribution Conversion**: Uses inverse transform sampling for non-uniform distributions

## Compilation

```bash
make
```

Or manually:
```bash
g++ -std=c++11 -Wall -Wextra -O2 -o creator creator.cpp
```

## Usage

### Basic Usage
```bash
./creator --size <number> --distribution <type> --perturbation <level> --output <filename>
```

### Parameters

- `--size <number>`: Array size (1 to 500,000)
- `--distribution <type>`: Distribution type (uniform, normal, exponential, beta)
- `--perturbation <level>`: Perturbation level (0.0 to 1.0)
  - 0.0 = fully sorted array
  - 1.0 = fully random array
- `--output <filename>`: Output file name

### Distribution Types

1. **Uniform**: Equal probability for all values in range
2. **Normal**: Gaussian distribution (mean=0.5, std=0.2)
3. **Exponential**: Exponential distribution (lambda=2.0)
4. **Beta**: Beta distribution (alpha=2.0, beta=5.0)

### Distribution Conversion Functions

The tool generates uniform random values [0,1] and converts them using:

- **Normal**: Box-Muller transform
- **Exponential**: Inverse transform: -ln(1-u)/λ
- **Beta**: Rejection sampling approximation

## Examples

### Create Different Types of Data Sets

```bash
# Fully random uniform distribution
./creator --size 1000 --distribution uniform --perturbation 1.0 --output random_data.txt

# Mostly sorted with some randomness
./creator --size 5000 --distribution uniform --perturbation 0.2 --output mostly_sorted.txt

# Normal distribution, 50% pre-sorted
./creator --size 2000 --distribution normal --perturbation 0.5 --output normal_data.txt

# Exponential distribution, fully random
./creator --size 10000 --distribution exponential --perturbation 1.0 --output exp_data.txt

# Beta distribution, fully sorted
./creator --size 1000 --distribution beta --perturbation 0.0 --output sorted_beta.txt
```

### Using the Helper Script

For convenience, use the provided shell script:

```bash
# Create predefined test datasets
./create_datasets.sh quick

# Interactive mode
./create_datasets.sh custom

# Show help
./create_datasets.sh help
```

## Output Format

The tool creates a text file with space-separated integers:
```
1 5 3 8 2 10 4 7 6 9
```

## Perturbation Explanation

The perturbation level controls how much of the array is pre-sorted:

- **0.0**: Array is fully sorted [1, 2, 3, ...]
- **0.2**: 80% of array is sorted, 20% is random
- **0.5**: 50% of array is sorted, 50% is random
- **1.0**: Array is fully random

This allows testing sorting algorithms on various levels of pre-sorted data.

## Statistics

After creation, the tool displays:
- Array size and distribution type
- Value range (always [1, array_size])
- Percentage of sorted adjacent pairs
- Output file location

## Integration with Sorting Algorithms

The generated files can be used directly with the sorting algorithm benchmarks:

```bash
# C++ implementation
./sorting_algorithms --file random_data.txt --algorithms quick_sort,merge_sort

# Python implementation
python sorting_algorithms.py --file random_data.txt --algorithms quick_sort,merge_sort

# Java implementation
java SortingAlgorithms --file random_data.txt --algorithms quick_sort,merge_sort
```

## Technical Details

- Uses Mersenne Twister random number generator for high-quality randomness
- Implements proper statistical transformations for each distribution
- Ensures all generated values are within the specified range [1, array_size]
- Memory efficient for large arrays (up to 500,000 elements)
