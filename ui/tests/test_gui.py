#!/usr/bin/env python3
"""
Test script for the Sorting Algorithms Comparison GUI
Validates data loading and basic functionality without opening the GUI.
"""

import sys
import os
import json

def test_data_loading():
    """Test if result files can be loaded successfully"""
    print("Testing data loading...")
    print("=" * 40)
    
    # Get the results directory path
    results_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 
                              "resources", "results")
    
    print(f"Looking for results in: {results_path}")
    
    if not os.path.exists(results_path):
        print(f"❌ Results directory not found: {results_path}")
        return False
    
    languages = ["cpp", "python", "java"]
    loaded_data = {}
    
    for lang in languages:
        file_path = os.path.join(results_path, f"results_{lang}.json")
        
        if os.path.exists(file_path):
            try:
                with open(file_path, 'r') as f:
                    data = json.load(f)
                    loaded_data[lang] = data
                    
                print(f"✅ {lang}: {len(data)} algorithms loaded")
                
                # Print available algorithms
                algorithms = [item.get('algorithm', 'Unknown') for item in data]
                print(f"   Algorithms: {', '.join(algorithms)}")
                
                # Check data structure
                if data:
                    first_item = data[0]
                    required_fields = ['algorithm', 'average_time', 'min_time', 'max_time', 'std_deviation']
                    missing_fields = [field for field in required_fields if field not in first_item]
                    
                    if missing_fields:
                        print(f"   ⚠️  Missing fields: {', '.join(missing_fields)}")
                    else:
                        print(f"   ✅ All required fields present")
                        
            except json.JSONDecodeError as e:
                print(f"❌ {lang}: Invalid JSON format - {str(e)}")
                return False
            except Exception as e:
                print(f"❌ {lang}: Error loading file - {str(e)}")
                return False
        else:
            print(f"❌ {lang}: File not found - {file_path}")
    
    if not loaded_data:
        print("\n❌ No valid result files found!")
        return False
    
    print(f"\n✅ Successfully loaded data for {len(loaded_data)} languages")
    return True

def test_gui_imports():
    """Test if all required modules can be imported"""
    print("\nTesting GUI dependencies...")
    print("=" * 40)
    
    try:
        import tkinter
        print("✅ tkinter: Available")
    except ImportError:
        print("❌ tkinter: Not available")
        return False
    
    try:
        import matplotlib
        print(f"✅ matplotlib: Version {matplotlib.__version__}")
    except ImportError:
        print("❌ matplotlib: Not available")
        return False
    
    try:
        import numpy
        print(f"✅ numpy: Version {numpy.__version__}")
    except ImportError:
        print("❌ numpy: Not available")
        return False
    
    try:
        from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
        print("✅ matplotlib-tkinter integration: Available")
    except ImportError:
        print("❌ matplotlib-tkinter integration: Not available")
        return False
    
    return True

def main():
    """Main test function"""
    print("Sorting Algorithms GUI - Test Suite")
    print("=" * 50)
    
    # Test dependencies
    deps_ok = test_gui_imports()
    
    # Test data loading
    data_ok = test_data_loading()
    
    print("\nTest Summary")
    print("=" * 40)
    
    if deps_ok and data_ok:
        print("✅ All tests passed! The GUI should work correctly.")
        print("\nTo launch the GUI, run:")
        print("  python3 sorting_gui.py")
        print("  or")
        print("  ./launch_gui.sh")
        return 0
    else:
        print("❌ Some tests failed. Please check the issues above.")
        if not deps_ok:
            print("\nTo install missing dependencies:")
            print("  pip install matplotlib numpy")
        if not data_ok:
            print("\nMake sure the result files exist in ../resources/results/")
        return 1

if __name__ == "__main__":
    sys.exit(main())
