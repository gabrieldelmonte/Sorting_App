#!/usr/bin/env python3
"""
Sorting Algorithms Comparison GUI
A comprehensive Tkinter application for visualizing sorting algorithm performance comparisons.
"""

import tkinter as tk
from tkinter import ttk, messagebox, filedialog
import json
import os
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from matplotlib.figure import Figure
import numpy as np
from typing import Dict, List, Any
import sys

class SortingComparisonGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("Sorting Algorithms Performance Comparison")
        self.root.geometry("1400x800")
        self.root.configure(bg='#f0f0f0')
        
        # Data storage
        self.results_data = {}
        self.available_algorithms = [
            "bubble_sort",
            "bucket_sort",
            "counting_sort",
            "heap_sort", 
            "insertion_sort", 
            "merge_sort",
            "quick_sort",
            "radix_sort",
            "selection_sort"
        ]
        
        # Setup UI
        self.setup_ui()
        
        # Clean up old results on startup
        self.cleanup_old_results()
        
        self.load_results_data()
        
    def setup_ui(self):
        """Setup the user interface"""
        # Main container
        main_frame = ttk.Frame(self.root, padding="10")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Configure grid weights
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        main_frame.columnconfigure(1, weight=1)
        main_frame.rowconfigure(0, weight=1)
        
        # Left panel for controls
        self.setup_control_panel(main_frame)
        
        # Right panel for plots
        self.setup_plot_panel(main_frame)
        
    def setup_control_panel(self, parent):
        """Setup the left control panel"""
        control_frame = ttk.LabelFrame(parent, text="Controls", padding="10")
        control_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S), padx=(0, 10))
        control_frame.configure(width=350)
        
        row = 0
        
        # Language selection
        lang_frame = ttk.LabelFrame(control_frame, text="Select Languages", padding="5")
        lang_frame.grid(row=row, column=0, sticky=(tk.W, tk.E), pady=(0, 10))
        row += 1
        
        self.language_vars = {}
        languages = [("C++", "cpp"), ("Python", "python"), ("Java", "java")]
        
        for i, (display_name, lang_key) in enumerate(languages):
            var = tk.BooleanVar(value=True)
            self.language_vars[lang_key] = var
            chk = ttk.Checkbutton(lang_frame, text=display_name, variable=var,
                                command=self.update_plots)
            chk.grid(row=i, column=0, sticky=tk.W, padx=5, pady=2)
        
        # Algorithm selection
        algo_frame = ttk.LabelFrame(control_frame, text="Select Algorithms", padding="5")
        algo_frame.grid(row=row, column=0, sticky=(tk.W, tk.E), pady=(0, 10))
        row += 1
        
        self.algorithm_vars = {}
        
        # Select All / Deselect All buttons
        button_frame = ttk.Frame(algo_frame)
        button_frame.grid(row=0, column=0, columnspan=2, sticky=(tk.W, tk.E), pady=(0, 5))
        
        ttk.Button(button_frame, text="Select All", 
                  command=self.select_all_algorithms).pack(side=tk.LEFT, padx=(0, 5))
        ttk.Button(button_frame, text="Deselect All", 
                  command=self.deselect_all_algorithms).pack(side=tk.LEFT)
        
        # Algorithm checkboxes
        for i, algorithm in enumerate(self.available_algorithms):
            var = tk.BooleanVar(value=True)  # Default: all algorithms selected
            self.algorithm_vars[algorithm] = var
            
            # Format algorithm name for display
            display_name = algorithm.replace('_', ' ').title()
            chk = ttk.Checkbutton(algo_frame, text=display_name, variable=var,
                                command=self.update_plots)
            
            chk.grid(row=(i//2)+1, column=i%2, sticky=tk.W, padx=5, pady=2)
        
        # Number of runs slider
        runs_frame = ttk.LabelFrame(control_frame, text="Number of Runs", padding="5")
        runs_frame.grid(row=row, column=0, sticky=(tk.W, tk.E), pady=(0, 10))
        row += 1
        
        # Runs input container
        runs_container = ttk.Frame(runs_frame)
        runs_container.pack(fill=tk.X)
        
        self.runs_var = tk.IntVar(value=2)  # Default: 2 runs
        self.runs_label = ttk.Label(runs_container, text="Runs:")
        self.runs_label.pack(side=tk.LEFT, anchor=tk.W)
        
        # Entry box for runs
        self.runs_entry = ttk.Entry(runs_container, textvariable=self.runs_var, width=8)
        self.runs_entry.pack(side=tk.RIGHT, padx=(5, 0))
        self.runs_entry.bind('<Return>', self.validate_runs_entry)
        self.runs_entry.bind('<FocusOut>', self.validate_runs_entry)
        
        self.runs_scale = ttk.Scale(runs_frame, from_=1, to=15, orient=tk.HORIZONTAL,
                                   variable=self.runs_var, command=self.update_runs_from_scale)
        self.runs_scale.pack(fill=tk.X, pady=5)
        
        # Number of elements slider
        elements_frame = ttk.LabelFrame(control_frame, text="Number of Elements", padding="5")
        elements_frame.grid(row=row, column=0, sticky=(tk.W, tk.E), pady=(0, 10))
        row += 1
        
        # Elements input container
        elements_container = ttk.Frame(elements_frame)
        elements_container.pack(fill=tk.X)
        
        self.elements_var = tk.IntVar(value=1000)  # Default: 1000 elements
        self.elements_label = ttk.Label(elements_container, text="Elements:")
        self.elements_label.pack(side=tk.LEFT, anchor=tk.W)
        
        # Entry box for elements
        self.elements_entry = ttk.Entry(elements_container, textvariable=self.elements_var, width=8)
        self.elements_entry.pack(side=tk.RIGHT, padx=(5, 0))
        self.elements_entry.bind('<Return>', self.validate_elements_entry)
        self.elements_entry.bind('<FocusOut>', self.validate_elements_entry)
        
        self.elements_scale = ttk.Scale(elements_frame, from_=100, to=500000, orient=tk.HORIZONTAL,
                                      variable=self.elements_var, command=self.update_elements_from_scale)
        self.elements_scale.pack(fill=tk.X, pady=5)
        
        # Perturbation level slider
        perturbation_frame = ttk.LabelFrame(control_frame, text="Perturbation Level", padding="5")
        perturbation_frame.grid(row=row, column=0, sticky=(tk.W, tk.E), pady=(0, 10))
        row += 1
        
        # Perturbation input container
        perturbation_container = ttk.Frame(perturbation_frame)
        perturbation_container.pack(fill=tk.X)
        
        self.perturbation_var = tk.DoubleVar(value=1.0)  # Default: 1.0 (fully random)
        self.perturbation_label = ttk.Label(perturbation_container, text="Level:")
        self.perturbation_label.pack(side=tk.LEFT, anchor=tk.W)
        
        # Entry box for perturbation
        self.perturbation_entry = ttk.Entry(perturbation_container, textvariable=self.perturbation_var, width=8)
        self.perturbation_entry.pack(side=tk.RIGHT, padx=(5, 0))
        self.perturbation_entry.bind('<Return>', self.validate_perturbation_entry)
        self.perturbation_entry.bind('<FocusOut>', self.validate_perturbation_entry)
        
        self.perturbation_scale = ttk.Scale(perturbation_frame, from_=0.0, to=1.0, orient=tk.HORIZONTAL,
                                          variable=self.perturbation_var, command=self.update_perturbation_from_scale)
        self.perturbation_scale.pack(fill=tk.X, pady=5)
        
        # Add help text for perturbation
        help_text = ttk.Label(perturbation_frame, text="0.0 = fully sorted, 1.0 = fully random", 
                             font=("Arial", 8), foreground="gray")
        help_text.pack(anchor=tk.W, pady=(0, 5))
        
        # Plot type selection
        plot_frame = ttk.LabelFrame(control_frame, text="Plot Type", padding="5")
        plot_frame.grid(row=row, column=0, sticky=(tk.W, tk.E), pady=(0, 10))
        row += 1
        
        self.plot_type_var = tk.StringVar(value="average_time")
        plot_types = [
            ("Average Time", "average_time"),
            ("Min Time", "min_time"),
            ("Max Time", "max_time"),
            ("Standard Deviation", "std_deviation")
        ]
        
        for display_name, value in plot_types:
            rb = ttk.Radiobutton(plot_frame, text=display_name, value=value,
                               variable=self.plot_type_var, command=self.update_plots)
            rb.pack(anchor=tk.W, pady=2)
        
        # Action buttons
        button_frame = ttk.Frame(control_frame)
        button_frame.grid(row=row, column=0, sticky=(tk.W, tk.E), pady=10)
        row += 1
        
        # Run Algorithms button (prominent)
        self.run_button = ttk.Button(button_frame, text="🚀 Run Algorithms", 
                                   command=self.run_algorithms)
        self.run_button.pack(fill=tk.X, pady=(0, 10))
        
        # Other action buttons
        ttk.Button(button_frame, text="Update Plots", 
                  command=self.update_plots).pack(fill=tk.X, pady=(0, 5))
        ttk.Button(button_frame, text="Export Plot", 
                  command=self.export_plot).pack(fill=tk.X, pady=(0, 5))
        ttk.Button(button_frame, text="Reload Data", 
                  command=self.load_results_data).pack(fill=tk.X)
        
        # Status label
        self.status_label = ttk.Label(control_frame, text="Ready", 
                                    foreground="green", font=("Arial", 9, "italic"))
        self.status_label.grid(row=row, column=0, sticky=(tk.W, tk.E), pady=5)
        
    def setup_plot_panel(self, parent):
        """Setup the right panel for plots"""
        plot_frame = ttk.LabelFrame(parent, text="Performance Comparison", padding="10")
        plot_frame.grid(row=0, column=1, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Create matplotlib figure
        self.fig = Figure(figsize=(10, 8), dpi=100)
        self.canvas = FigureCanvasTkAgg(self.fig, plot_frame)
        self.canvas.get_tk_widget().pack(fill=tk.BOTH, expand=True)
        
        # Add toolbar
        toolbar_frame = ttk.Frame(plot_frame)
        toolbar_frame.pack(fill=tk.X, pady=(5, 0))
        
        from matplotlib.backends.backend_tkagg import NavigationToolbar2Tk
        self.toolbar = NavigationToolbar2Tk(self.canvas, toolbar_frame)
        self.toolbar.update()
        
    def load_results_data(self):
        """Load results data from JSON files"""
        self.results_data = {}
        results_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 
                                  "resources", "results")
        
        languages = ["cpp", "python", "java"]
        loaded_count = 0
        
        for lang in languages:
            file_path = os.path.join(results_path, f"results_{lang}.json")
            try:
                if os.path.exists(file_path):
                    with open(file_path, 'r') as f:
                        data = json.load(f)
                        self.results_data[lang] = data
                        loaded_count += 1
                    
                    # Extract available algorithms from this language's data
                    available_algos = [item.get('algorithm') for item in data if item.get('algorithm')]
                    self.update_status(f"Loaded {lang}: {len(available_algos)} algorithms", "green")
                else:
                    self.update_status(f"Warning: {file_path} not found", "orange")
            except Exception as e:
                self.update_status(f"Error loading {lang} data: {str(e)}", "red")
        
        if loaded_count == 0:
            self.update_status("No result files found! Please check the results directory.", "red")
        else:
            # Update available algorithms based on loaded data
            self.update_available_algorithms()
            self.update_status(f"Successfully loaded {loaded_count} language(s)", "green")
                
        self.update_plots()
        
    def update_available_algorithms(self):
        """Update the list of available algorithms based on loaded data"""
        algorithms_in_data = set()
        
        for lang_data in self.results_data.values():
            for item in lang_data:
                if 'algorithm' in item:
                    algorithms_in_data.add(item['algorithm'])
        
        # If we found algorithms in the data, update our checkboxes
        if algorithms_in_data:
            #print(f"Found algorithms in data: {sorted(algorithms_in_data)}")
            # Keep only algorithms that exist in the data
            available_algos = [algo for algo in self.available_algorithms if algo in algorithms_in_data]
            # Add any new algorithms found in data that we don't have
            for algo in algorithms_in_data:
                if algo not in self.available_algorithms:
                    available_algos.append(algo)
            
            self.available_algorithms = sorted(available_algos)
        
    def validate_runs_entry(self, event=None):
        """Validate runs entry input"""
        try:
            value = self.runs_var.get()
            if value < 1:
                self.runs_var.set(1)
            elif value > 15:
                self.runs_var.set(15)
        except tk.TclError:
            self.runs_var.set(2)  # Reset to default
        
    def validate_elements_entry(self, event=None):
        """Validate elements entry input"""
        try:
            value = self.elements_var.get()
            if value < 100:
                self.elements_var.set(100)
            elif value > 500000:
                self.elements_var.set(500000)
        except tk.TclError:
            self.elements_var.set(1000)  # Reset to default
        
    def update_runs_from_scale(self, value):
        """Update runs when slider changes"""
        runs = int(float(value))
        self.runs_var.set(runs)
        
    def update_elements_from_scale(self, value):
        """Update elements when slider changes"""
        elements = int(float(value))
        self.elements_var.set(elements)
        
    def validate_perturbation_entry(self, event=None):
        """Validate perturbation entry input"""
        try:
            value = self.perturbation_var.get()
            if value < 0.0:
                self.perturbation_var.set(0.0)
            elif value > 1.0:
                self.perturbation_var.set(1.0)
        except tk.TclError:
            self.perturbation_var.set(1.0)  # Reset to default
        
    def update_perturbation_from_scale(self, value):
        """Update perturbation when slider changes"""
        perturbation = round(float(value), 2)
        self.perturbation_var.set(perturbation)
        
    def run_algorithms(self):
        """Run the sorting algorithms with current settings"""
        selected_languages = self.get_selected_languages()
        selected_algorithms = self.get_selected_algorithms()
        num_runs = self.runs_var.get()
        num_elements = self.elements_var.get()
        perturbation_level = self.perturbation_var.get()
        
        if not selected_languages:
            messagebox.showwarning("No Languages", "Please select at least one programming language.")
            return
            
        if not selected_algorithms:
            messagebox.showwarning("No Algorithms", "Please select at least one sorting algorithm.")
            return
        
        # Validate inputs
        self.validate_runs_entry()
        self.validate_elements_entry()
        self.validate_perturbation_entry()
        
        # Show confirmation dialog
        msg = f"""Run algorithms with the following settings?

Languages: {', '.join(lang.upper() for lang in selected_languages)}
Algorithms: {len(selected_algorithms)} selected
Runs: {num_runs}
Elements: {num_elements:,}
Perturbation: {perturbation_level:.2f} (0.0=sorted, 1.0=random)

This will execute the benchmark scripts and may take some time.
"""
        
        if not messagebox.askyesno("Confirm Run", msg):
            return
        
        # Disable the run button to prevent multiple runs
        self.run_button.config(state='disabled', text="Running...")
        
        # Clean up old results before running new algorithms
        self.cleanup_old_results()
        
        self.update_status("Preparing to run algorithms...", "orange")
        self.root.update()
        
        try:
            # Run algorithms for each selected language
            success_count = 0
            for lang in selected_languages:
                self.update_status(f"Running {lang.upper()} algorithms...", "orange")
                self.root.update()
                
                if self.run_language_algorithms(lang, selected_algorithms, num_runs, num_elements, perturbation_level):
                    success_count += 1
                    self.update_status(f"Completed {lang.upper()} algorithms", "green")
                else:
                    self.update_status(f"Failed to run {lang.upper()} algorithms", "red")
                self.root.update()
            
            if success_count > 0:
                self.update_status(f"Successfully ran {success_count}/{len(selected_languages)} languages", "green")
                # Reload data and update plots
                self.load_results_data()
            else:
                self.update_status("Failed to run any algorithms", "red")
                
        except Exception as e:
            self.update_status(f"Error running algorithms: {str(e)}", "red")
            messagebox.showerror("Error", f"Failed to run algorithms:\n{str(e)}")
        finally:
            # Re-enable the run button
            self.run_button.config(state='normal', text="🚀 Run Algorithms")
    
    def run_language_algorithms(self, language, algorithms, runs, elements, perturbation_level):
        """Run algorithms for a specific language"""
        import subprocess
        import tempfile
        
        # Create dataset file using the creator
        dataset_path = self.create_dataset_with_creator(elements, perturbation_level)
        if not dataset_path:
            return False
        
        try:
            # Determine the algorithm script path
            algo_dir = os.path.join(os.path.dirname(os.path.dirname(__file__)), 
                                  "algorithms", language)
            
            # Join algorithms into comma-separated string
            algorithms_str = ','.join(algorithms)
            
            if language == "python":
                script_path = os.path.join(algo_dir, "algorithms.py")
                if not os.path.exists(script_path):
                    self.update_status(f"Python script not found: {script_path}", "red")
                    return False
                
                # Run Python algorithms with correct arguments
                cmd = [
                    "python3", script_path,
                    "--file", dataset_path,
                    "--algorithms", algorithms_str,
                    "--runs", str(runs)
                ]
                
                result = subprocess.run(cmd, capture_output=True, text=True, cwd=algo_dir)
                if result.returncode != 0:
                    print(f"Error running {language}: {result.stderr}")
                    return False
                        
            elif language == "cpp":
                # For C++ - check if source needs recompilation
                executable_path = os.path.join(algo_dir, "algorithms")
                cpp_source = os.path.join(algo_dir, "algorithms.cpp")
                
                # Check if C++ source needs recompilation
                if (os.path.exists(cpp_source) and 
                    (not os.path.exists(executable_path) or 
                     os.path.getmtime(cpp_source) > os.path.getmtime(executable_path))):
                    
                    self.update_status("C++ source is newer than executable, recompiling...", "orange")
                    
                    # Compile C++ source
                    compile_cmd = ["g++", "-std=c++17", "-O2", "algorithms.cpp", "-o", "algorithms"]
                    
                    result = subprocess.run(compile_cmd, capture_output=True, text=True, cwd=algo_dir)
                    
                    if result.returncode != 0:
                        self.update_status(f"C++ compilation failed: {result.stderr}", "red")
                        return False
                    
                    self.update_status("C++ compilation successful", "green")
                
                # Check if executable exists after potential compilation
                if not os.path.exists(executable_path):
                    self.update_status(f"C++ executable not found: {executable_path}", "red")
                    return False
                
                # Run C++ algorithms with correct arguments
                cmd = [
                    executable_path,
                    "--file", dataset_path,
                    "--algorithms", algorithms_str,
                    "--runs", str(runs)
                ]
                
                result = subprocess.run(cmd, capture_output=True, text=True, cwd=algo_dir)
                if result.returncode != 0:
                    print(f"Error running {language}: {result.stderr}")
                    return False
                        
            elif language == "java":
                # For Java - run from the java directory with proper classpath
                java_main_dir = algo_dir  # This is already the java directory
                bin_dir = os.path.join(java_main_dir, "bin")
                lib_dir = os.path.join(java_main_dir, "lib")
                src_dir = os.path.join(java_main_dir, "src")
                
                if not os.path.exists(bin_dir):
                    self.update_status(f"Java bin directory not found: {bin_dir}", "red")
                    return False
                
                if not os.path.exists(lib_dir):
                    self.update_status(f"Java lib directory not found: {lib_dir}", "red")
                    return False
                
                # Check if Java source needs recompilation
                src_file = os.path.join(src_dir, "SortingAlgorithms.java")
                class_file = os.path.join(bin_dir, "SortingAlgorithms.class")
                
                if (os.path.exists(src_file) and 
                    (not os.path.exists(class_file) or 
                     os.path.getmtime(src_file) > os.path.getmtime(class_file))):
                    
                    self.update_status("Java source is newer than compiled class, recompiling...", "orange")
                    
                    # Compile Java source
                    compile_cmd = [
                        "javac", "-cp", "lib/gson-2.10.1.jar", "-d", "bin", 
                        "src/SortingAlgorithms.java"
                    ]
                    
                    result = subprocess.run(compile_cmd, capture_output=True, text=True, cwd=java_main_dir)
                    
                    if result.returncode != 0:
                        self.update_status(f"Java compilation failed: {result.stderr}", "red")
                        return False
                    
                    self.update_status("Java compilation successful", "green")
                
                # Run Java algorithms with correct classpath (bin:lib/gson-2.10.1.jar)
                classpath = f"bin{os.pathsep}lib/gson-2.10.1.jar"
                cmd = [
                    "java", "-cp", classpath, "SortingAlgorithms",
                    "--file", dataset_path,
                    "--algorithms", algorithms_str,
                    "--runs", str(runs)
                ]
                
                result = subprocess.run(cmd, capture_output=True, text=True, cwd=java_main_dir)
                if result.returncode != 0:
                    print(f"Error running {language}: {result.stderr}")
                    return False
            
            return True
            
        finally:
            # Clean up temporary dataset file
            if os.path.exists(dataset_path):
                os.remove(dataset_path)
    
    def create_dataset_with_creator(self, num_elements, perturbation_level):
        """Create a dataset using the creator.cpp program"""
        import subprocess
        import tempfile
        import os
        
        try:
            # Path to the creator executable
            creator_dir = os.path.join(os.path.dirname(os.path.dirname(__file__)), 
                                     "resources", "sets")
            creator_path = os.path.join(creator_dir, "creator")
            
            # Check if creator executable exists, if not try to compile it
            if not os.path.exists(creator_path):
                self.update_status("Compiling dataset creator...", "orange")
                cpp_file = os.path.join(creator_dir, "creator.cpp")
                
                if not os.path.exists(cpp_file):
                    self.update_status("Creator source not found", "red")
                    return None
                
                # Compile the creator
                compile_cmd = ["g++", "-std=c++17", "-O2", "creator.cpp", "-o", "creator"]
                result = subprocess.run(compile_cmd, capture_output=True, text=True, cwd=creator_dir)
                
                if result.returncode != 0:
                    self.update_status(f"Failed to compile creator: {result.stderr}", "red")
                    return None
            
            # Create temporary output file
            with tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.txt') as f:
                output_path = f.name
            
            # Run the creator
            cmd = [
                creator_path,
                "--size", str(num_elements),
                "--distribution", "uniform",
                "--perturbation", str(perturbation_level),
                "--output", output_path
            ]
            
            result = subprocess.run(cmd, capture_output=True, text=True, cwd=creator_dir)
            
            if result.returncode != 0:
                self.update_status(f"Failed to create dataset: {result.stderr}", "red")
                if os.path.exists(output_path):
                    os.remove(output_path)
                return None
            
            return output_path
            
        except Exception as e:
            self.update_status(f"Error creating dataset: {str(e)}", "red")
            return None
        
    def cleanup_old_results(self):
        """Clean up old result files"""
        results_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 
                                  "resources", "results")
        
        if not os.path.exists(results_path):
            return
        
        languages = ["cpp", "python", "java"]
        cleaned_files = []
        
        for lang in languages:
            file_path = os.path.join(results_path, f"results_{lang}.json")
            if os.path.exists(file_path):
                try:
                    os.remove(file_path)
                    cleaned_files.append(f"results_{lang}.json")
                except Exception as e:
                    print(f"Warning: Could not remove {file_path}: {e}")
        
        if cleaned_files:
            self.update_status(f"Cleaned up old results: {', '.join(cleaned_files)}", "blue")
        else:
            self.update_status("No old results to clean up", "green")
        
    def select_all_algorithms(self):
        """Select all algorithms"""
        for var in self.algorithm_vars.values():
            var.set(True)
        self.update_plots()
        
    def deselect_all_algorithms(self):
        """Deselect all algorithms"""
        for var in self.algorithm_vars.values():
            var.set(False)
        self.update_plots()
        
    def update_status(self, message, color="black"):
        """Update status label"""
        self.status_label.config(text=message, foreground=color)
        self.root.update_idletasks()
        
    def get_selected_languages(self):
        """Get list of selected languages"""
        return [lang for lang, var in self.language_vars.items() if var.get()]
        
    def get_selected_algorithms(self):
        """Get list of selected algorithms"""
        return [algo for algo, var in self.algorithm_vars.items() if var.get()]
        
    def update_plots(self):
        """Update the plots based on current selections"""
        self.fig.clear()
        
        selected_languages = self.get_selected_languages()
        selected_algorithms = self.get_selected_algorithms()
        plot_type = self.plot_type_var.get()
        
        # Create subplots first
        ax1 = self.fig.add_subplot(2, 1, 1)
        ax2 = self.fig.add_subplot(2, 1, 2)
        
        if not selected_languages or not selected_algorithms:
            # Clear plots and show message
            ax1.text(0.5, 0.5, 'Please select at least one language\nand one algorithm', 
                    horizontalalignment='center', verticalalignment='center',
                    transform=ax1.transAxes, fontsize=14, color='red')
            ax2.text(0.5, 0.5, 'No data to display', 
                    horizontalalignment='center', verticalalignment='center',
                    transform=ax2.transAxes, fontsize=14, color='red')
            self.update_status("Please select at least one language and algorithm", "red")
            self.canvas.draw()
            return
        
        # Plot 1: Bar chart comparison
        self.plot_bar_comparison(ax1, selected_languages, selected_algorithms, plot_type)
        
        # Plot 2: Detailed algorithm comparison
        self.plot_algorithm_details(ax2, selected_languages, selected_algorithms, plot_type)
        
        self.fig.tight_layout()
        self.canvas.draw()
        self.update_status("Plots updated successfully", "green")
        
    def plot_bar_comparison(self, ax, languages, algorithms, metric):
        """Create bar chart comparison"""
        # First, find which algorithms actually have data in at least one language
        available_algorithms = []
        data_to_plot = {}
        
        for lang in languages:
            if lang not in self.results_data:
                continue
            data_to_plot[lang] = []
        
        # Check each algorithm to see if it has data in any language
        for algo in algorithms:
            has_data = False
            for lang in languages:
                if lang not in self.results_data:
                    continue
                    
                # Find algorithm data
                algo_data = None
                for item in self.results_data[lang]:
                    if item.get('algorithm') == algo:
                        algo_data = item
                        break
                
                if algo_data and metric in algo_data:
                    has_data = True
                    break
            
            if has_data:
                available_algorithms.append(algo)
        
        if not available_algorithms:
            ax.text(0.5, 0.5, f'No data available for selected algorithms\nand metric: {metric}', 
                   horizontalalignment='center', verticalalignment='center',
                   transform=ax.transAxes, fontsize=12, color='red')
            return
        
        # Now collect the data for available algorithms
        labels = []
        for lang in languages:
            if lang not in self.results_data:
                continue
            data_to_plot[lang] = []
            
        for algo in available_algorithms:
            labels.append(algo.replace('_', ' ').title())
            
            for lang in languages:
                if lang not in self.results_data:
                    continue
                    
                # Find algorithm data
                algo_data = None
                for item in self.results_data[lang]:
                    if item.get('algorithm') == algo:
                        algo_data = item
                        break
                
                if algo_data and metric in algo_data:
                    data_to_plot[lang].append(algo_data[metric])
                else:
                    data_to_plot[lang].append(0)
        
        # Filter out languages with no data
        data_to_plot = {lang: values for lang, values in data_to_plot.items() if any(values)}
        
        if not data_to_plot or not labels:
            ax.text(0.5, 0.5, 'No valid data to display', 
                   horizontalalignment='center', verticalalignment='center',
                   transform=ax.transAxes, fontsize=12, color='red')
            return
        
        # Create grouped bar chart
        x = np.arange(len(labels))
        width = 0.8 / len(data_to_plot)  # Adjust width based on number of languages
        colors = ['#ff7f0e', '#1f77b4', '#2ca02c', '#d62728', '#9467bd', '#8c564b']
        
        for i, (lang, values) in enumerate(data_to_plot.items()):
            offset = (i - len(data_to_plot)/2 + 0.5) * width
            ax.bar(x + offset, values, width, label=lang.upper(), 
                  color=colors[i % len(colors)], alpha=0.8)
        
        ax.set_xlabel('Algorithms')
        ax.set_ylabel(f'{metric.replace("_", " ").title()} (seconds)')
        ax.set_title(f'{metric.replace("_", " ").title()} Comparison by Algorithm')
        ax.set_xticks(x)
        ax.set_xticklabels(labels, rotation=45, ha='right')
        ax.legend()
        ax.grid(True, alpha=0.3)
        
    def plot_algorithm_details(self, ax, languages, algorithms, metric):
        """Create detailed line plot for algorithms"""
        # Find algorithms that have data
        available_algorithms = []
        for algo in algorithms:
            for lang in languages:
                if lang not in self.results_data:
                    continue
                    
                # Find algorithm data
                algo_data = None
                for item in self.results_data[lang]:
                    if item.get('algorithm') == algo:
                        algo_data = item
                        break
                
                if algo_data and metric in algo_data:
                    available_algorithms.append(algo)
                    break
        
        if not available_algorithms:
            ax.text(0.5, 0.5, f'No data available for\nselected algorithms and metric', 
                   horizontalalignment='center', verticalalignment='center',
                   transform=ax.transAxes, fontsize=12, color='red')
            return
        
        colors = ['#ff7f0e', '#1f77b4', '#2ca02c', '#d62728', '#9467bd']
        
        for lang_idx, lang in enumerate(languages):
            if lang not in self.results_data:
                continue
                
            x_values = []
            y_values = []
            
            for i, algo in enumerate(available_algorithms):
                # Find algorithm data
                algo_data = None
                for item in self.results_data[lang]:
                    if item.get('algorithm') == algo:
                        algo_data = item
                        break
                
                if algo_data and metric in algo_data:
                    x_values.append(i)
                    y_values.append(algo_data[metric])
            
            if x_values and y_values:
                ax.plot(x_values, y_values, marker='o', linewidth=2, 
                       markersize=6, label=f'{lang.upper()}', 
                       color=colors[lang_idx % len(colors)], alpha=0.8)
        
        if available_algorithms:
            ax.set_xlabel('Algorithm Index')
            ax.set_ylabel(f'{metric.replace("_", " ").title()} (seconds)')
            ax.set_title(f'{metric.replace("_", " ").title()} Trends')
            ax.set_xticks(range(len(available_algorithms)))
            ax.set_xticklabels([algo.replace('_', ' ').title() for algo in available_algorithms], 
                              rotation=45, ha='right')
            ax.legend()
            ax.grid(True, alpha=0.3)
        else:
            ax.text(0.5, 0.5, 'No data to display', 
                   horizontalalignment='center', verticalalignment='center',
                   transform=ax.transAxes, fontsize=12, color='red')
        
    def export_plot(self):
        """Export current plot to file"""
        file_path = filedialog.asksaveasfilename(
            defaultextension=".png",
            filetypes=[("PNG files", "*.png"), ("PDF files", "*.pdf"), 
                      ("SVG files", "*.svg"), ("All files", "*.*")]
        )
        
        if file_path:
            try:
                self.fig.savefig(file_path, dpi=300, bbox_inches='tight')
                self.update_status(f"Plot exported to {file_path}", "green")
            except Exception as e:
                self.update_status(f"Error exporting plot: {str(e)}", "red")
                messagebox.showerror("Export Error", f"Failed to export plot:\n{str(e)}")

def main():
    """Main function to run the GUI"""
    root = tk.Tk()
    
    # Configure styles
    style = ttk.Style()
    try:
        # Try to create an accent style for the run button
        style.configure("Accent.TButton", 
                       font=("Arial", 10, "bold"),
                       foreground="white",
                       background="#007ACC")
    except:
        # If accent style fails, just use default
        pass
    
    app = SortingComparisonGUI(root)
    
    # Center the window
    root.update_idletasks()
    x = (root.winfo_screenwidth() // 2) - (root.winfo_width() // 2)
    y = (root.winfo_screenheight() // 2) - (root.winfo_height() // 2)
    root.geometry(f"+{x}+{y}")
    
    root.mainloop()

if __name__ == "__main__":
    main()
