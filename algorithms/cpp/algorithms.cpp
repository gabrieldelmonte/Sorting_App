// This file is part of the C++ Algorithms project.

// Include necessary headers
#include "nlohmann/json.hpp"

#include <functional>
#include <algorithm>
#include <iostream>
#include <fstream>
#include <numeric>
#include <cstdlib>
#include <vector>
#include <string>
#include <thread>
#include <chrono>
#include <mutex>
#include <queue>
#include <cmath>
#include <map>

using json = nlohmann::json;
std::mutex output_mutex;


// --- Sorting algorithms ---

// Bubble sort
void bubble_sort(std::vector<int>& array) {
    size_t size = array.size();
    bool swapped;

    if (size < 2)
        return;

    do {
        swapped = false;

        for (size_t index = 1; index < size; ++index)
            if (array[index - 1] > array[index]) {
                std::swap(array[index - 1], array[index]);
                swapped = true;
            }

        --size;
    } while (swapped);

    return;
}

// Selection sort
void selection_sort(std::vector<int>& array) {
    size_t size = array.size();

    if (size < 2)
        return;

    for (size_t index = 0; index < size - 1; ++index) {
        size_t min_index = index;

        for (size_t j = index + 1; j < size; ++j)
            if (array[j] < array[min_index])
                min_index = j;

        std::swap(array[index], array[min_index]);
    }

    return;
}

// Insertion sort
void insertion_sort(std::vector<int>& array) {
    size_t size = array.size();

    if (size < 2)
        return;

    for (size_t index = 1; index < size; ++index) {
        int key = array[index];
        size_t j = index - 1;

        while (j < size && array[j] > key) {
            array[j + 1] = array[j];
            --j;
        }

        array[j + 1] = key;
    }

    return;
}

// Quick sort
int partition(std::vector<int>& array, int low, int high) {
    int pivot = array[high];
    int i = low - 1;

    for (int j = low; j < high; ++j)
        if (array[j] < pivot) {
            ++i;
            std::swap(array[i], array[j]);
        }

    std::swap(array[i + 1], array[high]);

    return i + 1;
}

void quick_sort_recursive(std::vector<int>& array, int low, int high) {
    if (low < high) {
        int pi = partition(array, low, high);

        quick_sort_recursive(array, low, pi - 1);
        quick_sort_recursive(array, pi + 1, high);
    }

    return;
}

void quick_sort(std::vector<int>& array) {
    if (array.size() < 2)
        return;

    quick_sort_recursive(array, 0, array.size() - 1);

    return;
}

// Merge sort
void merge(std::vector<int>& array, int left, int mid, int right) {
    int n1 = mid - left + 1;
    int n2 = right - mid;

    std::vector<int> L(n1), R(n2);

    for (int i = 0; i < n1; ++i)
        L[i] = array[left + i];
    
    for (int j = 0; j < n2; ++j)
        R[j] = array[mid + 1 + j];

    int i = 0;
    int j = 0;
    int k = left;

    while (i < n1 && j < n2)
        array[k++] = (L[i] <= R[j]) ? L[i++] : R[j++];

    while (i < n1)
        array[k++] = L[i++];

    while (j < n2)
        array[k++] = R[j++];

    return;
}

void merge_sort_recursive(std::vector<int>& array, int left, int right) {
    if (left < right) {
        int mid = left + (right - left) / 2;

        merge_sort_recursive(array, left, mid);
        merge_sort_recursive(array, mid + 1, right);
        merge(array, left, mid, right);
    }

    return;
}

void merge_sort(std::vector<int>& array) {
    if (array.size() < 2)
        return;

    merge_sort_recursive(array, 0, array.size() - 1);

    return;
}

// Heap sort
void heapify(std::vector<int>& array, int n, int i) {
    int largest = i;
    int left = (2 * i) + 1;
    int right = (2 * i) + 2;

    if (left < n && array[left] > array[largest])
        largest = left;

    if (right < n && array[right] > array[largest])
        largest = right;

    if (largest != i) {
        std::swap(array[i], array[largest]);
        heapify(array, n, largest);
    }

    return;
}

void heap_sort(std::vector<int>& array) {
    size_t size = array.size();

    if (size < 2)
        return;

    for (size_t i = static_cast<size_t>(size / 2) - 1; i != static_cast<size_t>(-1); --i)
        heapify(array, size, i);

    for (size_t i = size - 1; i > 0; --i) {
        std::swap(array[0], array[i]);
        heapify(array, i, 0);
    }

    return;
}

// Counting sort
void counting_sort(std::vector<int>& array) {
    if (array.empty())
        return;

    if (array.size() < 2)
        return;

    int max_value = *std::max_element(array.begin(), array.end());
    int min_value = *std::min_element(array.begin(), array.end());
    int range = max_value - min_value + 1;
    std::vector<int> count(range, 0);

    for (int num : array)
        ++count[num - min_value];

    int index = 0;

    for (int i = 0; i < range; ++i)
        while (count[i]--)
            array[index++] = i + min_value;

    return;
}

// Radix sort
void radix_sort(std::vector<int>& array) {
    if (array.empty())
        return;

    if (array.size() < 2)
        return;

    int max_value = *std::max_element(array.begin(), array.end());
    int exp = 1;

    while (max_value / exp > 0) {
        std::vector<int> output(array.size());
        int count[10] = {0};

        for (int num : array)
            ++count[(num / exp) % 10];

        for (int i = 1; i < 10; ++i)
            count[i] += count[i - 1];

        for (int i = static_cast<int>(array.size()) - 1; i >= 0; --i) {
            output[count[(array[i] / exp) % 10] - 1] = array[i];
            --count[(array[i] / exp) % 10];
        }

        array = output;
        exp *= 10;
    }

    return;
}

// Bucket sort
void bucket_sort(std::vector<int>& array) {
    if (array.empty())
        return;

    if (array.size() < 2)
        return;

    int max_value = *std::max_element(array.begin(), array.end());
    size_t bucket_count = static_cast<size_t>(std::sqrt(array.size()));
    std::vector<std::vector<int>> buckets(bucket_count);

    for (int num : array) {
        size_t bucket_index = static_cast<size_t>((static_cast<double>(num) / (max_value + 1)) * bucket_count);
        if (bucket_index >= bucket_count)
            bucket_index = bucket_count - 1;
        buckets[bucket_index].push_back(num);
    }

    array.clear();

    for (auto& bucket : buckets) {
        if (bucket.size() < 2) {
            array.insert(array.end(), bucket.begin(), bucket.end());
            continue;
        }

        std::sort(bucket.begin(), bucket.end());
        array.insert(array.end(), bucket.begin(), bucket.end());
    }

    return;
}


// --- Utility functions ---

std::vector<int> read_file(const std::string& path) {
    std::ifstream infile(path);

    if (!infile)
        throw std::runtime_error("Could not open file: " + path);

    int number;    
    std::vector<int> data;

    while (infile >> number)
        data.push_back(number);

    infile.close();
    return data;
}

std::pair<std::vector<double>, std::string> run_sort_multiple(const std::string& algorithm,
                                                              const std::function<void(std::vector<int>&)>& sort_function,
                                                              const std::vector<int>& data,
                                                              int runs = 10) {
    std::vector<double> times;
    times.reserve(runs);
    
    for (int i = 0; i < runs; ++i) {
        auto copy = data;
        auto start = std::chrono::high_resolution_clock::now();
        sort_function(copy);
        auto end = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double> duration = end - start;
        times.push_back(duration.count());
    }
    
    return {times, algorithm};
}

// --- Main function ---

int main(int argc, char* argv[]) {
    std::string file_path;
    std::vector<std::string> chosen_algorithms;
    int num_runs = 10; // Default number of runs

    // Check for help first
    if (argc == 1 || (argc == 2 && (std::string(argv[1]) == "--help" || std::string(argv[1]) == "-h"))) {
        std::cout << "C++ Sorting Algorithms Benchmark Tool\n\n";
        std::cout << "Usage: " << argv[0] << " --file <input_file> --algorithms <algorithm_list> [--runs <number>]\n\n";
        std::cout << "Required Arguments:\n";
        std::cout << "  --file <path>           Input file containing space-separated integers\n";
        std::cout << "  --algorithms <list>     Comma-separated list of algorithms to run\n\n";
        std::cout << "Optional Arguments:\n";
        std::cout << "  --runs <number>         Number of runs per algorithm (default: 10)\n";
        std::cout << "  --help, -h              Show this help message\n\n";
        std::cout << "Available Algorithms:\n";
        std::cout << "  bubble_sort             Bubble Sort (O(n^2))\n";
        std::cout << "  selection_sort          Selection Sort (O(n^2))\n";
        std::cout << "  insertion_sort          Insertion Sort (O(n^2))\n";
        std::cout << "  quick_sort              Quick Sort (O(n log n) average)\n";
        std::cout << "  merge_sort              Merge Sort (O(n log n))\n";
        std::cout << "  heap_sort               Heap Sort (O(n log n))\n";
        std::cout << "  counting_sort           Counting Sort (O(n + k))\n";
        std::cout << "  radix_sort              Radix Sort (O(d x (n + k)))\n";
        std::cout << "  bucket_sort             Bucket Sort (O(n + k))\n\n";
        std::cout << "Examples:\n";
        std::cout << "  " << argv[0] << " --file data.txt --algorithms quick_sort,merge_sort\n";
        std::cout << "  " << argv[0] << " --file data.txt --algorithms bubble_sort --runs 15\n";
        std::cout << "  " << argv[0] << " --file data.txt --algorithms quick_sort,merge_sort,heap_sort --runs 5\n\n";
        std::cout << "Output:\n";
        std::cout << "  Results are saved to: ../../resources/results/results_cpp.json\n";
        return 0;
    }

    for (int index = 1; index < argc; ++index) {
        std::string arg = argv[index];

        if (arg == "--file" && index + 1 < argc)
            file_path = argv[++index];
        else if (arg == "--algorithms" && index + 1 < argc) {
            std::string algorithms = argv[++index];
            size_t pos = 0;

            while ((pos = algorithms.find(',')) != std::string::npos) {
                chosen_algorithms.push_back(algorithms.substr(0, pos));
                algorithms.erase(0, pos + 1);
            }

            chosen_algorithms.push_back(algorithms);
        }
        else if (arg == "--runs" && index + 1 < argc) {
            num_runs = std::stoi(argv[++index]);
            if (num_runs < 1) {
                std::cerr << "Number of runs must be at least 1." << std::endl;
                return 1;
            }
        }
        else if (arg == "--help" || arg == "-h") {
            // Help already handled above, but include here for completeness
            return 0;
        }
        else {
            std::cerr << "Unknown argument: " << arg << std::endl;
            std::cerr << "Use --help for usage information." << std::endl;
            return 1;
        }
    }

    if (file_path.empty() || chosen_algorithms.empty()) {
        std::cerr << "Error: Missing required arguments." << std::endl;
        std::cerr << "Usage: " << argv[0] << " --file <path> --algorithms <alg1,alg2,...> [--runs <number>]" << std::endl;
        std::cerr << "Use --help for detailed usage information." << std::endl;
        return 1;
    }

    std::map<std::string, std::function<void(std::vector<int>&)>> algorithms = {
        {"bubble_sort", bubble_sort},
        {"selection_sort", selection_sort},
        {"insertion_sort", insertion_sort},
        {"quick_sort", quick_sort},
        {"merge_sort", merge_sort},
        {"heap_sort", heap_sort},
        {"counting_sort", counting_sort},
        {"radix_sort", radix_sort},
        {"bucket_sort", bucket_sort}
    };

    std::vector<int> data;
    try {
        data = read_file(file_path);
    } 
    catch (const std::runtime_error& e) {
        std::cerr << "Error reading file: " << e.what() << std::endl;
        return 1;
    }

    if (data.empty()) {
        std::cerr << "No data to sort." << std::endl;
        return 1;
    }

    json results = json::array();
    std::vector<std::thread> threads;

    for (const auto& algorithm : chosen_algorithms) {
        auto it = algorithms.find(algorithm);
        if (it != algorithms.end()) {
            threads.emplace_back([&, algorithm, sort_function = it->second, num_runs]() {
                auto [times, algo_name] = run_sort_multiple(algorithm, sort_function, data, num_runs);
                
                // Calculate statistics
                double avg_time = std::accumulate(times.begin(), times.end(), 0.0) / times.size();
                double min_time = *std::min_element(times.begin(), times.end());
                double max_time = *std::max_element(times.begin(), times.end());

                // Calculate standard deviation
                double sum_sq = 0.0;
                for (double time : times)
                    sum_sq += (time - avg_time) * (time - avg_time);
                double std_dev = std::sqrt(sum_sq / times.size());

                std::lock_guard<std::mutex> lock(output_mutex);
                results.push_back({
                    {"algorithm", algo_name},
                    {"runs", num_runs},
                    {"times", times},
                    {"average_time", avg_time},
                    {"min_time", min_time},
                    {"max_time", max_time},
                    {"std_deviation", std_dev}
                });
            });
        }
        else {
            std::cerr << "Unknown algorithm: " << algorithm << std::endl;
            return 1;
        }
    }

    for (auto& thread : threads)
        if (thread.joinable())
            thread.join();

    // Create the results directory path relative to the project root
    std::string results_dir = "../../resources/results/";
    std::string results_file = results_dir + "results_cpp.json";
    
    // Create directory if it doesn't exist (using system call)
    system("mkdir -p ../../resources/results/");

    std::ofstream outfile(results_file);
    if (!outfile) {
        std::cerr << "Error: Could not create results file at " << results_file << std::endl;
        // Fallback to current directory
        results_file = "results_cpp.json";
        outfile.open(results_file);
    }
    
    std::cout << results.dump(4) << std::endl;
    outfile << results.dump(4);
    outfile.close();
    std::cout << "Sorting completed. Results saved to " << results_file << std::endl;

    return 0;
}
