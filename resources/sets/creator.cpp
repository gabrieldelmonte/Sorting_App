#include <algorithm>
#include <iostream>
#include <fstream>
#include <iomanip>
#include <vector>
#include <random>
#include <string>
#include <cmath>

/**
 * Data Set Creator for Sorting Algorithms
 * Creates arrays with configurable size, distribution, and perturbation levels
 */

enum class DistributionType {
    UNIFORM,
    NORMAL,
    EXPONENTIAL,
    BETA
};

class DataSetCreator {
private:
    std::mt19937 rng;

    // Convert uniform [0,1] to normal distribution using Box-Muller transform
    double uniformToNormal(double u1, double u2, double mean = 0.5, double stddev = 0.2) {
        static bool hasSpare = false;
        static double spare;

        if (hasSpare) {
            hasSpare = false;

            return spare * stddev + mean;
        }

        hasSpare = true;
        double mag = stddev * std::sqrt(-2.0 * std::log(u1));
        spare = mag * std::cos(2.0 * M_PI * u2);

        return mag * std::sin(2.0 * M_PI * u2) + mean;
    }

    // Convert uniform [0,1] to exponential distribution
    double uniformToExponential(double u, double lambda = 2.0) {
        return -std::log(1.0 - u) / lambda;
    }
    
    // Convert uniform [0,1] to beta distribution using rejection sampling
    double uniformToBeta(double u1, double u2, double alpha = 2.0, double beta = 5.0) {
        // Simple beta distribution approximation
        double x = std::pow(u1, 1.0 / alpha);
        double y = std::pow(u2, 1.0 / beta);

        return x / (x + y);
    }

    // Normalize value to range [1, maxValue]
    int normalizeToRange(double value, int maxValue) {
        // Clamp to [0, 1] and scale to [1, maxValue]
        value = std::max(0.0, std::min(1.0, value));
        if (maxValue <= 1)
            return 1;

        return static_cast<int>(value * (maxValue - 1)) + 1;
    }

public:
    DataSetCreator() : rng(std::random_device{}()) {}
    
    /**
     * Generate array with specified parameters
     */
    std::vector<int> generateArray(int size, DistributionType distType, double perturbationLevel) {
        if (size <= 0 || size > 500000)
            throw std::invalid_argument("Array size must be between 1 and 500,000");
        
        if (perturbationLevel < 0.0 || perturbationLevel > 1.0)
            throw std::invalid_argument("Perturbation level must be between 0.0 and 1.0");
        
        std::vector<int> array;
        array.reserve(size);
        
        // Generate uniform random values [0, 1]
        std::uniform_real_distribution<double> uniformDist(0.0, 1.0);
        
        // Apply distribution transformation
        for (int i = 0; i < size; ++i) {
            double uniformValue1 = uniformDist(rng);
            double uniformValue2 = uniformDist(rng);
            double transformedValue;
            
            switch (distType) {
                case DistributionType::UNIFORM:
                    transformedValue = uniformValue1;
                    break;
                    
                case DistributionType::NORMAL:
                    transformedValue = uniformToNormal(uniformValue1, uniformValue2);
                    break;
                    
                case DistributionType::EXPONENTIAL:
                    transformedValue = uniformToExponential(uniformValue1);
                    // Normalize exponential to [0, 1] range
                    transformedValue = 1.0 - std::exp(-transformedValue);
                    break;
                    
                case DistributionType::BETA:
                    transformedValue = uniformToBeta(uniformValue1, uniformValue2);
                    break;
                    
                default:
                    transformedValue = uniformValue1;
                    break;
            }
            
            // Convert to integer in range [1, size]
            int value = normalizeToRange(transformedValue, size);
            array.push_back(value);
        }
        
        // Apply perturbation (sort a portion of the array)
        if (perturbationLevel > 0.0) {
            int sortedElements = static_cast<int>(size * (1.0 - perturbationLevel));

            // Sort the first portion of the array
            if (sortedElements > 0)
                std::sort(array.begin(), array.begin() + sortedElements);
        }
        
        return array;
    }
    
    /**
     * Save array to file
     */
    bool saveToFile(const std::vector<int>& array, const std::string& filename) {
        std::ofstream file(filename);
        if (!file.is_open())
            return false;
        
        for (size_t i = 0; i < array.size(); ++i) {
            file << array[i];
            if (i < array.size() - 1)
                file << "\n";
        }
        file << std::endl;
        
        return true;
    }
};

// Helper function to parse distribution type
DistributionType parseDistributionType(const std::string& distStr) {
    std::string lower = distStr;
    std::transform(lower.begin(), lower.end(), lower.begin(), ::tolower);
    
    if (lower == "uniform")
        return DistributionType::UNIFORM;
    if (lower == "normal")
        return DistributionType::NORMAL;
    if (lower == "exponential")
        return DistributionType::EXPONENTIAL;
    if (lower == "beta")
        return DistributionType::BETA;
    
    throw std::invalid_argument("Unknown distribution type: " + distStr);
}

void showHelp(const std::string& programName) {
    std::cout << "Data Set Creator for Sorting Algorithms\n\n";
    std::cout << "Usage: " << programName << " --size <number> --distribution <type> --perturbation <level> --output <filename>\n\n";
    std::cout << "Required Arguments:\n";
    std::cout << "  --size <number>         Array size (1 to 500,000)\n";
    std::cout << "  --distribution <type>   Distribution type (uniform, normal, exponential, beta)\n";
    std::cout << "  --perturbation <level>  Perturbation level (0.0 to 1.0)\n";
    std::cout << "                         0.0 = fully sorted, 1.0 = fully random\n";
    std::cout << "  --output <filename>     Output file name\n\n";
    std::cout << "Optional Arguments:\n";
    std::cout << "  --help, -h             Show this help message\n\n";
    std::cout << "Distribution Types:\n";
    std::cout << "  uniform       Uniform distribution (default)\n";
    std::cout << "  normal        Normal/Gaussian distribution (mean=0.5, std=0.2)\n";
    std::cout << "  exponential   Exponential distribution (lambda=2.0)\n";
    std::cout << "  beta          Beta distribution (alpha=2.0, beta=5.0)\n\n";
    std::cout << "Perturbation Levels:\n";
    std::cout << "  0.0           Fully sorted array\n";
    std::cout << "  0.1           90% sorted, 10% random\n";
    std::cout << "  0.5           50% sorted, 50% random\n";
    std::cout << "  1.0           Fully random array\n\n";
    std::cout << "Examples:\n";
    std::cout << "  " << programName << " --size 1000 --distribution uniform --perturbation 1.0 --output data.txt\n";
    std::cout << "  " << programName << " --size 5000 --distribution normal --perturbation 0.2 --output test_data.txt\n";
    std::cout << "  " << programName << " --size 10000 --distribution exponential --perturbation 0.8 --output exp_data.txt\n\n";
    std::cout << "Note: Array elements will be in range [1, array_size]\n";
}

int main(int argc, char* argv[]) {
    // Default values
    int size = 1;
    DistributionType distType = DistributionType::UNIFORM;
    double perturbationLevel = 1.0;
    std::string outputFile;
    
    // Check for help first
    if (argc == 1 || (argc == 2 && (std::string(argv[1]) == "--help" || std::string(argv[1]) == "-h"))) {
        showHelp(argv[0]);
        return 0;
    }
    
    // Parse command line arguments
    for (int i = 1; i < argc; i++) {
        std::string arg = argv[i];
        
        if (arg == "--size" && i + 1 < argc) {
            try {
                size = std::stoi(argv[++i]);
            }
            catch (const std::exception& e) {
                std::cerr << "Error: Invalid size value: " << argv[i] << std::endl;

                return 1;
            }
        }
        else if (arg == "--distribution" && i + 1 < argc) {
            try {
                distType = parseDistributionType(argv[++i]);
            }
            catch (const std::exception& e) {
                std::cerr << "Error: " << e.what() << std::endl;

                return 1;
            }
        }
        else if (arg == "--perturbation" && i + 1 < argc) {
            try {
                perturbationLevel = std::stod(argv[++i]);
            }
            catch (const std::exception& e) {
                std::cerr << "Error: Invalid perturbation value: " << argv[i] << std::endl;

                return 1;
            }
        }
        else if (arg == "--output" && i + 1 < argc)
            outputFile = argv[++i];
        else if (arg == "--help" || arg == "-h") {
            showHelp(argv[0]);

            return 0;
        }
        else {
            std::cerr << "Error: Unknown argument: " << arg << std::endl;
            std::cerr << "Use --help for usage information." << std::endl;

            return 1;
        }
    }
    
    // Validate required arguments
    if (size == 0 || outputFile.empty()) {
        std::cerr << "Error: Missing required arguments." << std::endl;
        std::cerr << "Usage: " << argv[0] << " --size <number> --distribution <type> --perturbation <level> --output <filename>" << std::endl;
        std::cerr << "Use --help for detailed usage information." << std::endl;

        return 1;
    }
    
    try {
        // Create data set
        DataSetCreator creator;
        std::vector<int> array = creator.generateArray(size, distType, perturbationLevel);
        
        // Save to file
        if (!creator.saveToFile(array, outputFile)) {
            std::cerr << "Error: Could not save data to file: " << outputFile << std::endl;

            return 1;
        }
        
        // Print summary
        std::string distName;
        switch (distType) {
            case DistributionType::UNIFORM:
                distName = "uniform";
                break;
            case DistributionType::NORMAL:
                distName = "normal";
                break;
            case DistributionType::EXPONENTIAL:
                distName = "exponential";
                break;
            case DistributionType::BETA:
                distName = "beta";
                break;
        }
        
        std::cout << "Data set created successfully!" << std::endl;
        std::cout << "Size: " << size << " elements" << std::endl;
        std::cout << "Distribution: " << distName << std::endl;
        std::cout << "Perturbation level: " << std::fixed << std::setprecision(2) << perturbationLevel << std::endl;
        std::cout << "Output file: " << outputFile << std::endl;
        
        // Show some statistics
        auto minMax = std::minmax_element(array.begin(), array.end());
        std::cout << "Value range: [" << *minMax.first << ", " << *minMax.second << "]" << std::endl;
        
        // Check how much is actually sorted
        int sortedCount = 0;
        for (size_t i = 1; i < array.size(); ++i)
            if (array[i] >= array[i-1])
                sortedCount++;
        double sortedPercentage = static_cast<double>(sortedCount) / (array.size() - 1) * 100.0;
        std::cout << "Sorted pairs: " << std::fixed << std::setprecision(1) << sortedPercentage << "%" << std::endl;
        
    }
    catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;

        return 1;
    }
    
    return 0;
}
