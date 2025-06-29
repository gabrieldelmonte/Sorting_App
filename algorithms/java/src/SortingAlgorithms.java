// This file is part of the Java Algorithms project.

import java.io.*;
import java.nio.file.*;
import java.util.*;
import java.util.concurrent.*;
import java.util.function.Consumer;
import com.google.gson.*;

/**
 * Java Sorting Algorithms Benchmark Tool
 * Implements 9 sorting algorithms with multi-threaded benchmarking and JSON output
 */
public class SortingAlgorithms {
    
    private static final Object outputLock = new Object();
    
    // --- Sorting Algorithms ---
    
    /**
     * Bubble Sort - O(n²)
     */
    public static void bubbleSort(int[] array) {
        int n = array.length;
        if (n < 2)
            return;
        
        boolean swapped;
        do {
            swapped = false;
            for (int i = 1; i < n; i++)
                if (array[i - 1] > array[i]) {
                    swap(array, i - 1, i);
                    swapped = true;
                }
            n--;
        } while (swapped);
    }
    
    /**
     * Selection Sort - O(n²)
     */
    public static void selectionSort(int[] array) {
        int n = array.length;
        if (n < 2)
            return;
        
        for (int i = 0; i < n - 1; i++) {
            int minIndex = i;
            for (int j = i + 1; j < n; j++)
                if (array[j] < array[minIndex])
                    minIndex = j;
            swap(array, i, minIndex);
        }
    }
    
    /**
     * Insertion Sort - O(n²)
     */
    public static void insertionSort(int[] array) {
        int n = array.length;
        if (n < 2)
            return;
        
        for (int i = 1; i < n; i++) {
            int key = array[i];
            int j = i - 1;
            
            while (j >= 0 && array[j] > key) {
                array[j + 1] = array[j];
                j--;
            }
            array[j + 1] = key;
        }
    }
    
    /**
     * Quick Sort - O(n log n) average
     */
    public static void quickSort(int[] array) {
        if (array.length < 2)
            return;
        quickSortRecursive(array, 0, array.length - 1);
    }
    
    private static void quickSortRecursive(int[] array, int low, int high) {
        if (low < high) {
            int pi = partition(array, low, high);
            quickSortRecursive(array, low, pi - 1);
            quickSortRecursive(array, pi + 1, high);
        }
    }
    
    private static int partition(int[] array, int low, int high) {
        int pivot = array[high];
        int i = low - 1;
        
        for (int j = low; j < high; j++)
            if (array[j] < pivot) {
                i++;
                swap(array, i, j);
            }
        swap(array, i + 1, high);
        return i + 1;
    }
    
    /**
     * Merge Sort - O(n log n)
     */
    public static void mergeSort(int[] array) {
        if (array.length < 2)
            return;
        mergeSortRecursive(array, 0, array.length - 1);
    }
    
    private static void mergeSortRecursive(int[] array, int left, int right) {
        if (left < right) {
            int mid = left + (right - left) / 2;
            mergeSortRecursive(array, left, mid);
            mergeSortRecursive(array, mid + 1, right);
            merge(array, left, mid, right);
        }
    }
    
    private static void merge(int[] array, int left, int mid, int right) {
        int n1 = mid - left + 1;
        int n2 = right - mid;
        
        int[] leftArray = new int[n1];
        int[] rightArray = new int[n2];
        
        System.arraycopy(array, left, leftArray, 0, n1);
        System.arraycopy(array, mid + 1, rightArray, 0, n2);
        
        int i = 0, j = 0, k = left;
        
        while (i < n1 && j < n2) {
            if (leftArray[i] <= rightArray[j])
                array[k++] = leftArray[i++];
            else
                array[k++] = rightArray[j++];
        }
        
        while (i < n1)
            array[k++] = leftArray[i++];
        while (j < n2)
            array[k++] = rightArray[j++];
    }
    
    /**
     * Heap Sort - O(n log n)
     */
    public static void heapSort(int[] array) {
        int n = array.length;
        if (n < 2)
            return;
        
        // Build heap
        for (int i = n / 2 - 1; i >= 0; i--)
            heapify(array, n, i);
        
        // Extract elements from heap
        for (int i = n - 1; i > 0; i--) {
            swap(array, 0, i);
            heapify(array, i, 0);
        }
    }
    
    private static void heapify(int[] array, int n, int i) {
        int largest = i;
        int left = 2 * i + 1;
        int right = 2 * i + 2;
        
        if (left < n && array[left] > array[largest])
            largest = left;
        
        if (right < n && array[right] > array[largest])
            largest = right;
        
        if (largest != i) {
            swap(array, i, largest);
            heapify(array, n, largest);
        }
    }
    
    /**
     * Counting Sort - O(n + k)
     */
    public static void countingSort(int[] array) {
        if (array.length < 2)
            return;
        
        int max = Arrays.stream(array).max().orElse(0);
        int min = Arrays.stream(array).min().orElse(0);
        int range = max - min + 1;
        
        int[] count = new int[range];
        
        // Count occurrences
        for (int num : array)
            count[num - min]++;
        
        // Reconstruct array
        int index = 0;
        for (int i = 0; i < range; i++)
            while (count[i]-- > 0)
                array[index++] = i + min;
    }
    
    /**
     * Radix Sort - O(d × (n + k))
     */
    public static void radixSort(int[] array) {
        if (array.length < 2)
            return;
        
        int max = Arrays.stream(array).max().orElse(0);
        
        for (int exp = 1; max / exp > 0; exp *= 10)
            countingSortByDigit(array, exp);
    }
    
    private static void countingSortByDigit(int[] array, int exp) {
        int n = array.length;
        int[] output = new int[n];
        int[] count = new int[10];
        
        // Count occurrences of digits
        for (int num : array)
            count[(num / exp) % 10]++;
        
        // Change count[i] to actual position
        for (int i = 1; i < 10; i++)
            count[i] += count[i - 1];
        
        // Build output array
        for (int i = n - 1; i >= 0; i--) {
            output[count[(array[i] / exp) % 10] - 1] = array[i];
            count[(array[i] / exp) % 10]--;
        }
        
        System.arraycopy(output, 0, array, 0, n);
    }
    
    /**
     * Bucket Sort - O(n + k)
     */
    public static void bucketSort(int[] array) {
        if (array.length < 2)
            return;
        
        int max = Arrays.stream(array).max().orElse(0);
        int bucketCount = (int) Math.sqrt(array.length);
        
        @SuppressWarnings("unchecked")
        List<Integer>[] buckets = new List[bucketCount];
        for (int i = 0; i < bucketCount; i++)
            buckets[i] = new ArrayList<>();
        
        // Distribute elements into buckets
        for (int num : array) {
            int bucketIndex = (int) ((double) num / (max + 1) * bucketCount);
            if (bucketIndex >= bucketCount) bucketIndex = bucketCount - 1;
            buckets[bucketIndex].add(num);
        }
        
        // Sort individual buckets and concatenate
        int index = 0;
        for (List<Integer> bucket : buckets) {
            Collections.sort(bucket);
            for (int num : bucket)
                array[index++] = num;
        }
    }
    
    // --- Utility Methods ---
    
    private static void swap(int[] array, int i, int j) {
        int temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
    
    /**
     * Read integers from file
     */
    private static int[] readFile(String filePath) throws IOException {
        List<Integer> numbers = new ArrayList<>();
        try (Scanner scanner = new Scanner(new File(filePath))) {
            while (scanner.hasNextInt())
                numbers.add(scanner.nextInt());
        }
        return numbers.stream().mapToInt(Integer::intValue).toArray();
    }
    
    /**
     * Benchmark result container
     */
    private static class BenchmarkResult {
        String algorithm;
        int runs;
        double[] times;
        double averageTime;
        double minTime;
        double maxTime;
        double stdDeviation;
        
        BenchmarkResult(String algorithm, int runs, double[] times) {
            this.algorithm = algorithm;
            this.runs = runs;
            this.times = times.clone();
            
            // Calculate statistics
            this.averageTime = Arrays.stream(times).average().orElse(0.0);
            this.minTime = Arrays.stream(times).min().orElse(0.0);
            this.maxTime = Arrays.stream(times).max().orElse(0.0);
            
            // Calculate standard deviation
            double sumSquaredDiffs = Arrays.stream(times)
                .map(time -> Math.pow(time - averageTime, 2))
                .sum();
            this.stdDeviation = Math.sqrt(sumSquaredDiffs / times.length);
        }
    }
    
    /**
     * Run sorting algorithm multiple times and measure performance
     */
    private static BenchmarkResult runSortMultiple(String algorithmName, 
                                                   Consumer<int[]> sortFunction, 
                                                   int[] data, 
                                                   int runs) {
        double[] times = new double[runs];
        
        for (int i = 0; i < runs; i++) {
            int[] copy = data.clone();
            long startTime = System.nanoTime();
            sortFunction.accept(copy);
            long endTime = System.nanoTime();
            times[i] = (endTime - startTime) / 1_000_000_000.0; // Convert to seconds
        }
        
        return new BenchmarkResult(algorithmName, runs, times);
    }
    
    /**
     * Show help information
     */
    private static void showHelp(String programName) {
        System.out.println("Java Sorting Algorithms Benchmark Tool\n");
        System.out.println("Usage: java " + programName + " --file <input_file> --algorithms <algorithm_list> [--runs <number>]\n");
        System.out.println("Required Arguments:");
        System.out.println("  --file <path>           Input file containing space-separated integers");
        System.out.println("  --algorithms <list>     Comma-separated list of algorithms to run\n");
        System.out.println("Optional Arguments:");
        System.out.println("  --runs <number>         Number of runs per algorithm (default: 10)");
        System.out.println("  --help, -h              Show this help message\n");
        System.out.println("Available Algorithms:");
        System.out.println("  bubble_sort             Bubble Sort (O(n²))");
        System.out.println("  selection_sort          Selection Sort (O(n²))");
        System.out.println("  insertion_sort          Insertion Sort (O(n²))");
        System.out.println("  quick_sort              Quick Sort (O(n log n) average)");
        System.out.println("  merge_sort              Merge Sort (O(n log n))");
        System.out.println("  heap_sort               Heap Sort (O(n log n))");
        System.out.println("  counting_sort           Counting Sort (O(n + k))");
        System.out.println("  radix_sort              Radix Sort (O(d × (n + k)))");
        System.out.println("  bucket_sort             Bucket Sort (O(n + k))\n");
        System.out.println("Examples:");
        System.out.println("  java " + programName + " --file data.txt --algorithms quick_sort,merge_sort");
        System.out.println("  java " + programName + " --file data.txt --algorithms bubble_sort --runs 15");
        System.out.println("  java " + programName + " --file data.txt --algorithms quick_sort,merge_sort,heap_sort --runs 5\n");
        System.out.println("Output:");
        System.out.println("  Results are saved to: ../../resources/results/results_java.json");
    }
    
    /**
     * Main method
     */
    public static void main(String[] args) {
        String filePath = null;
        List<String> chosenAlgorithms = new ArrayList<>();
        int numRuns = 10; // Default number of runs
        
        // Check for help first
        if (args.length == 0 || 
            (args.length == 1 && (args[0].equals("--help") || args[0].equals("-h")))) {
            showHelp("SortingAlgorithms");
            return;
        }
        
        // Parse command line arguments
        for (int i = 0; i < args.length; i++)
            switch (args[i]) {
                case "--file":
                    if (i + 1 < args.length)
                        filePath = args[++i];
                    break;
                case "--algorithms":
                    if (i + 1 < args.length) {
                        String algorithms = args[++i];
                        chosenAlgorithms.addAll(Arrays.asList(algorithms.split(",")));
                    }
                    break;
                case "--runs":
                    if (i + 1 < args.length) {
                        try {
                            numRuns = Integer.parseInt(args[++i]);
                            if (numRuns < 1) {
                                System.err.println("Number of runs must be at least 1.");
                                System.exit(1);
                            }
                        }
                        catch (NumberFormatException e) {
                            System.err.println("Invalid number of runs: " + args[i]);
                            System.exit(1);
                        }
                    }
                    break;
                case "--help":
                case "-h":
                    showHelp("SortingAlgorithms");
                    return;
                default:
                    System.err.println("Unknown argument: " + args[i]);
                    System.err.println("Use --help for usage information.");
                    System.exit(1);
            }
        
        // Validate required arguments
        if (filePath == null || chosenAlgorithms.isEmpty()) {
            System.err.println("Error: Missing required arguments.");
            System.err.println("Usage: java SortingAlgorithms --file <path> --algorithms <alg1,alg2,...> [--runs <number>]");
            System.err.println("Use --help for detailed usage information.");
            System.exit(1);
        }
        
        // Algorithm map
        Map<String, Consumer<int[]>> algorithms = new HashMap<>();
        algorithms.put("bubble_sort", SortingAlgorithms::bubbleSort);
        algorithms.put("selection_sort", SortingAlgorithms::selectionSort);
        algorithms.put("insertion_sort", SortingAlgorithms::insertionSort);
        algorithms.put("quick_sort", SortingAlgorithms::quickSort);
        algorithms.put("merge_sort", SortingAlgorithms::mergeSort);
        algorithms.put("heap_sort", SortingAlgorithms::heapSort);
        algorithms.put("counting_sort", SortingAlgorithms::countingSort);
        algorithms.put("radix_sort", SortingAlgorithms::radixSort);
        algorithms.put("bucket_sort", SortingAlgorithms::bucketSort);
        
        // Read data
        int[] data;
        try {
            data = readFile(filePath);
        }
        catch (IOException e) {
            System.err.println("Error reading file: " + e.getMessage());
            System.exit(1);
            return;
        }
        
        if (data.length == 0) {
            System.err.println("No data to sort.");
            System.exit(1);
        }
        
        // Run benchmarks using thread pool
        List<BenchmarkResult> results = Collections.synchronizedList(new ArrayList<>());
        ExecutorService executor = Executors.newFixedThreadPool(chosenAlgorithms.size());
        List<Future<?>> futures = new ArrayList<>();
        
        final int finalNumRuns = numRuns; // Make effectively final for lambda
        final int[] finalData = data; // Make effectively final for lambda
        
        for (String algorithm : chosenAlgorithms) {
            Consumer<int[]> sortFunction = algorithms.get(algorithm);
            if (sortFunction != null) {
                Future<?> future = executor.submit(() -> {
                    BenchmarkResult result = runSortMultiple(algorithm, sortFunction, finalData, finalNumRuns);
                    synchronized (outputLock) {
                        results.add(result);
                    }
                });
                futures.add(future);
            }
            else {
                System.err.println("Unknown algorithm: " + algorithm);
                executor.shutdown();
                System.exit(1);
            }
        }
        
        // Wait for all tasks to complete
        for (Future<?> future : futures) {
            try {
                future.get();
            }
            catch (InterruptedException | ExecutionException e) {
                System.err.println("Error during execution: " + e.getMessage());
                executor.shutdown();
                System.exit(1);
            }
        }
        executor.shutdown();
        
        // Create JSON output
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        JsonArray jsonResults = new JsonArray();
        
        for (BenchmarkResult result : results) {
            JsonObject jsonResult = new JsonObject();
            jsonResult.addProperty("algorithm", result.algorithm);
            jsonResult.addProperty("runs", result.runs);
            
            JsonArray timesArray = new JsonArray();
            for (double time : result.times) {
                timesArray.add(time);
            }
            jsonResult.add("times", timesArray);
            
            jsonResult.addProperty("average_time", result.averageTime);
            jsonResult.addProperty("min_time", result.minTime);
            jsonResult.addProperty("max_time", result.maxTime);
            jsonResult.addProperty("std_deviation", result.stdDeviation);
            
            jsonResults.add(jsonResult);
        }
        
        // Print results to console
        System.out.println(gson.toJson(jsonResults));
        
        // Save results to file
        String resultsDir = "../../../resources/results/";
        String resultsFile = resultsDir + "results_java.json";
        
        try {
            // Create directory if it doesn't exist
            Files.createDirectories(Paths.get(resultsDir));
            
            try (FileWriter writer = new FileWriter(resultsFile)) {
                gson.toJson(jsonResults, writer);
            }
            System.out.println("Sorting completed. Results saved to " + resultsFile);
        }
        catch (IOException e) {
            System.err.println("Error: Could not create results file at " + resultsFile);
            // Fallback to current directory
            resultsFile = "results_java.json";
            try (FileWriter writer = new FileWriter(resultsFile)) {
                gson.toJson(jsonResults, writer);
                System.out.println("Results saved to " + resultsFile + " (fallback location)");
            }
            catch (IOException e2) {
                System.err.println("Error saving results: " + e2.getMessage());
            }
        }
    }
}
