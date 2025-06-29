#include <iostream>
#include <vector>
#include <algorithm>
#include <random>
#include <cassert>
#include <chrono>

// Copy your sorting functions here (just the declarations for testing)
void bubble_sort(std::vector<int>& array);
void selection_sort(std::vector<int>& array);
void insertion_sort(std::vector<int>& array);
void quick_sort(std::vector<int>& array);
void merge_sort(std::vector<int>& array);
void heap_sort(std::vector<int>& array);
void counting_sort(std::vector<int>& array);
void radix_sort(std::vector<int>& array);
void bucket_sort(std::vector<int>& array);

// Test if a vector is sorted
bool is_sorted(const std::vector<int>& arr) {
    for (size_t i = 1; i < arr.size(); ++i)
        if (arr[i-1] > arr[i])
            return false;

    return true;
}

// Test a sorting algorithm
bool test_sorting_algorithm(const std::string& name, 
                            void (*sort_func)(std::vector<int>&),
                            const std::vector<int>& test_data) {
    auto data_copy = test_data;
    sort_func(data_copy);

    bool sorted = is_sorted(data_copy);
    std::cout << name << ": " << (sorted ? "PASS" : "FAIL") << std::endl;

    return sorted;
}

// Generate test data
std::vector<int> generate_random_data(size_t size, int min_val = 1, int max_val = 1000) {
    std::vector<int> data;
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(min_val, max_val);

    for (size_t i = 0; i < size; ++i)
        data.push_back(dis(gen));
    
    return data;
}

int main() {
    std::cout << "=== Correctness Verification Test ===" << std::endl;
    
    // Test cases
    std::vector<std::vector<int>> test_cases = {
        {},                                    // Empty
        {1},                                   // Single element
        {1, 2},                                // Two elements
        {2, 1},                                // Two elements reverse
        {3, 1, 4, 1, 5, 9, 2, 6, 5},         // Duplicates
        {1, 2, 3, 4, 5},                      // Already sorted
        {5, 4, 3, 2, 1},                      // Reverse sorted
        generate_random_data(100),             // Random data
        generate_random_data(1000, 1, 10)     // Many duplicates
    };
    
    // Test all algorithms
    struct Algorithm {
        std::string name;
        void (*func)(std::vector<int>&);
    };
    
    // Note: You'll need to link this with your algorithms.cpp or include the implementations
    std::cout << "To run this test, compile with: g++ -std=c++17 test_correctness.cpp algorithms.cpp -o test_correctness" << std::endl;
    
    return 0;
}
