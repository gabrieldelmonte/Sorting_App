#!/usr/bin/env python3
"""
This file is part of the Python Algorithms project.
Sorting algorithms implementation with performance measurement and JSON output.
"""

import json
import time
import argparse
import sys
import os
import threading
import statistics
from typing import List, Tuple, Callable, Dict
from concurrent.futures import ThreadPoolExecutor
import random
import math


# Global mutex for thread-safe JSON results writing
results_lock = threading.Lock()


# --- Sorting algorithms ---

def bubble_sort(array: List[int]) -> None:
    """Bubble sort implementation"""
    size = len(array)
    
    if size < 2:
        return
    
    while True:
        swapped = False
        
        for index in range(1, size):
            if array[index - 1] > array[index]:
                array[index - 1], array[index] = array[index], array[index - 1]
                swapped = True
        
        size -= 1
        if not swapped:
            break


def selection_sort(array: List[int]) -> None:
    """Selection sort implementation"""
    size = len(array)
    
    if size < 2:
        return
    
    for index in range(size - 1):
        min_index = index
        
        for j in range(index + 1, size):
            if array[j] < array[min_index]:
                min_index = j
        
        array[index], array[min_index] = array[min_index], array[index]


def insertion_sort(array: List[int]) -> None:
    """Insertion sort implementation"""
    size = len(array)
    
    if size < 2:
        return
    
    for index in range(1, size):
        key = array[index]
        j = index - 1
        
        while j >= 0 and array[j] > key:
            array[j + 1] = array[j]
            j -= 1
        
        array[j + 1] = key


def quick_sort(array: List[int]) -> None:
    """Quick sort implementation"""
    if len(array) < 2:
        return
    
    def partition(arr: List[int], low: int, high: int) -> int:
        pivot = arr[high]
        i = low - 1
        
        for j in range(low, high):
            if arr[j] < pivot:
                i += 1
                arr[i], arr[j] = arr[j], arr[i]
        
        arr[i + 1], arr[high] = arr[high], arr[i + 1]
        return i + 1
    
    def quick_sort_recursive(arr: List[int], low: int, high: int) -> None:
        if low < high:
            pi = partition(arr, low, high)
            quick_sort_recursive(arr, low, pi - 1)
            quick_sort_recursive(arr, pi + 1, high)
    
    quick_sort_recursive(array, 0, len(array) - 1)


def merge_sort(array: List[int]) -> None:
    """Merge sort implementation"""
    if len(array) < 2:
        return
    
    def merge(arr: List[int], left: int, mid: int, right: int) -> None:
        n1 = mid - left + 1
        n2 = right - mid
        
        L = arr[left:mid + 1]
        R = arr[mid + 1:right + 1]
        
        i = j = 0
        k = left
        
        while i < n1 and j < n2:
            if L[i] <= R[j]:
                arr[k] = L[i]
                i += 1
            else:
                arr[k] = R[j]
                j += 1
            k += 1
        
        while i < n1:
            arr[k] = L[i]
            i += 1
            k += 1
        
        while j < n2:
            arr[k] = R[j]
            j += 1
            k += 1
    
    def merge_sort_recursive(arr: List[int], left: int, right: int) -> None:
        if left < right:
            mid = left + (right - left) // 2
            merge_sort_recursive(arr, left, mid)
            merge_sort_recursive(arr, mid + 1, right)
            merge(arr, left, mid, right)
    
    merge_sort_recursive(array, 0, len(array) - 1)


def heap_sort(array: List[int]) -> None:
    """Heap sort implementation"""
    size = len(array)
    
    if size < 2:
        return
    
    def heapify(arr: List[int], n: int, i: int) -> None:
        largest = i
        left = 2 * i + 1
        right = 2 * i + 2
        
        if left < n and arr[left] > arr[largest]:
            largest = left
        
        if right < n and arr[right] > arr[largest]:
            largest = right
        
        if largest != i:
            arr[i], arr[largest] = arr[largest], arr[i]
            heapify(arr, n, largest)
    
    # Build max heap
    for i in range(size // 2 - 1, -1, -1):
        heapify(array, size, i)
    
    # Extract elements from heap one by one
    for i in range(size - 1, 0, -1):
        array[0], array[i] = array[i], array[0]
        heapify(array, i, 0)


def counting_sort(array: List[int]) -> None:
    """Counting sort implementation"""
    if len(array) < 2:
        return
    
    max_value = max(array)
    min_value = min(array)
    range_val = max_value - min_value + 1
    count = [0] * range_val
    
    for num in array:
        count[num - min_value] += 1
    
    index = 0
    for i in range(range_val):
        while count[i] > 0:
            array[index] = i + min_value
            index += 1
            count[i] -= 1


def radix_sort(array: List[int]) -> None:
    """Radix sort implementation"""
    if len(array) < 2:
        return
    
    max_value = max(array)
    exp = 1
    
    while max_value // exp > 0:
        output = [0] * len(array)
        count = [0] * 10
        
        for num in array:
            count[(num // exp) % 10] += 1
        
        for i in range(1, 10):
            count[i] += count[i - 1]
        
        for i in range(len(array) - 1, -1, -1):
            output[count[(array[i] // exp) % 10] - 1] = array[i]
            count[(array[i] // exp) % 10] -= 1
        
        for i in range(len(array)):
            array[i] = output[i]
        
        exp *= 10


def bucket_sort(array: List[int]) -> None:
    """Bucket sort implementation"""
    if len(array) < 2:
        return
    
    max_value = max(array)
    bucket_count = int(math.sqrt(len(array)))
    buckets = [[] for _ in range(bucket_count)]
    
    for num in array:
        bucket_index = min(int((num / (max_value + 1)) * bucket_count), bucket_count - 1)
        buckets[bucket_index].append(num)
    
    array.clear()
    
    for bucket in buckets:
        if len(bucket) < 2:
            array.extend(bucket)
        else:
            bucket.sort()
            array.extend(bucket)


# --- Utility functions ---

def read_file(file_path: str) -> List[int]:
    """Read integers from a file"""
    try:
        with open(file_path, 'r') as file:
            content = file.read().strip()
            if not content:
                return []
            return [int(x) for x in content.split()]
    except FileNotFoundError:
        raise FileNotFoundError(f"Could not open file: {file_path}")
    except ValueError as e:
        raise ValueError(f"Invalid data in file: {e}")


def run_sort_multiple(algorithm: str, sort_function: Callable[[List[int]], None], 
                     data: List[int], runs: int = 10) -> Tuple[List[float], str]:
    """Run a sorting algorithm multiple times and return timing results"""
    times = []
    
    for _ in range(runs):
        data_copy = data.copy()
        start_time = time.perf_counter()
        sort_function(data_copy)
        end_time = time.perf_counter()
        times.append(end_time - start_time)
    
    return times, algorithm


def calculate_statistics(times: List[float]) -> Dict[str, float]:
    """Calculate statistical measures for timing results"""
    return {
        'average_time': statistics.mean(times),
        'min_time': min(times),
        'max_time': max(times),
        'std_deviation': statistics.stdev(times) if len(times) > 1 else 0.0
    }


def process_algorithm(algorithm: str, sort_function: Callable[[List[int]], None], 
                     data: List[int], num_runs: int, results: List[Dict]) -> None:
    """Process a single algorithm with multiple runs"""
    times, algo_name = run_sort_multiple(algorithm, sort_function, data, num_runs)
    stats = calculate_statistics(times)
    
    result = {
        'algorithm': algo_name,
        'runs': num_runs,
        'times': times,
        **stats
    }
    
    with results_lock:
        results.append(result)


def main():
    """Main function"""
    parser = argparse.ArgumentParser(
        description='Sorting algorithms performance measurement',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog='''
Examples:
  %(prog)s --file data.txt --algorithms quick_sort,merge_sort
  %(prog)s --file data.txt --algorithms bubble_sort --runs 15
  %(prog)s --file data.txt --algorithms quick_sort,merge_sort,heap_sort --runs 5
        '''
    )
    
    parser.add_argument('--file', required=True, help='Input file containing integers')
    parser.add_argument('--algorithms', required=True, 
                       help='Comma-separated list of algorithms to run')
    parser.add_argument('--runs', type=int, default=10, 
                       help='Number of runs for each algorithm (default: 10)')
    
    args = parser.parse_args()
    
    # Validate runs parameter
    if args.runs < 1:
        print("Error: Number of runs must be at least 1.", file=sys.stderr)
        return 1
    
    # Available algorithms
    algorithms = {
        'bubble_sort': bubble_sort,
        'selection_sort': selection_sort,
        'insertion_sort': insertion_sort,
        'quick_sort': quick_sort,
        'merge_sort': merge_sort,
        'heap_sort': heap_sort,
        'counting_sort': counting_sort,
        'radix_sort': radix_sort,
        'bucket_sort': bucket_sort
    }
    
    # Parse chosen algorithms
    chosen_algorithms = [algo.strip() for algo in args.algorithms.split(',')]
    
    # Validate algorithms
    for algorithm in chosen_algorithms:
        if algorithm not in algorithms:
            print(f"Error: Unknown algorithm: {algorithm}", file=sys.stderr)
            print(f"Available algorithms: {', '.join(algorithms.keys())}", file=sys.stderr)
            return 1
    
    # Read data
    try:
        data = read_file(args.file)
    except (FileNotFoundError, ValueError) as e:
        print(f"Error reading file: {e}", file=sys.stderr)
        return 1
    
    if not data:
        print("Error: No data to sort.", file=sys.stderr)
        return 1
    
    # Run algorithms concurrently
    results = []
    
    with ThreadPoolExecutor(max_workers=len(chosen_algorithms)) as executor:
        futures = []
        
        for algorithm in chosen_algorithms:
            sort_function = algorithms[algorithm]
            future = executor.submit(
                process_algorithm, algorithm, sort_function, data, args.runs, results
            )
            futures.append(future)
        
        # Wait for all threads to complete
        for future in futures:
            future.result()
    
    # Sort results by algorithm name for consistent output
    results.sort(key=lambda x: x['algorithm'])
    
    # Create results directory
    results_dir = "../../resources/results/"
    results_file = os.path.join(results_dir, "results_python.json")
    
    os.makedirs(results_dir, exist_ok=True)
    
    # Write results to file
    try:
        with open(results_file, 'w') as outfile:
            json.dump(results, outfile, indent=4)
        
        # Print results to console
        print(json.dumps(results, indent=4))
        print(f"Sorting completed. Results saved to {results_file}")
        
    except IOError as e:
        print(f"Error: Could not create results file at {results_file}: {e}", file=sys.stderr)
        # Fallback to current directory
        fallback_file = "results_python.json"
        try:
            with open(fallback_file, 'w') as outfile:
                json.dump(results, outfile, indent=4)
            print(json.dumps(results, indent=4))
            print(f"Sorting completed. Results saved to {fallback_file}")
        except IOError as e2:
            print(f"Error: Could not write results file: {e2}", file=sys.stderr)
            return 1
    
    return 0


if __name__ == "__main__":
    sys.exit(main())
