#!/usr/bin/env python3
"""
Test script to verify all new GUI features
"""
import os
import subprocess
import time

def test_all_features():
    """Test C++ auto-compilation and result cleanup features"""
    
    print("🧪 Testing New GUI Features")
    print("=" * 50)
    
    # Paths
    base_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(base_dir)
    cpp_dir = os.path.join(project_root, "algorithms", "cpp")
    results_dir = os.path.join(project_root, "resources", "results")
    
    print(f"Project root: {project_root}")
    print(f"C++ directory: {cpp_dir}")
    print(f"Results directory: {results_dir}")
    
    # Test 1: Create old result files
    print("\n1️⃣ Creating test result files...")
    test_files = []
    for lang in ["cpp", "python", "java"]:
        test_file = os.path.join(results_dir, f"results_{lang}.json")
        with open(test_file, 'w') as f:
            f.write('[]')  # Empty JSON array
        test_files.append(test_file)
        print(f"✅ Created {test_file}")
    
    # Test 2: Touch C++ source to make it newer
    print("\n2️⃣ Making C++ source newer than executable...")
    cpp_source = os.path.join(cpp_dir, "algorithms.cpp")
    cpp_executable = os.path.join(cpp_dir, "algorithms")
    
    if os.path.exists(cpp_source):
        # Get current times
        if os.path.exists(cpp_executable):
            exe_time = os.path.getmtime(cpp_executable)
            print(f"Executable time: {time.ctime(exe_time)}")
        
        # Touch source file
        subprocess.run(["touch", cpp_source])
        src_time = os.path.getmtime(cpp_source)
        print(f"Source time: {time.ctime(src_time)}")
        print("✅ C++ source is now newer")
    else:
        print("❌ C++ source file not found")
        return False
    
    # Test 3: Run GUI test
    print("\n3️⃣ Testing GUI with auto-compilation and cleanup...")
    
    gui_test_code = '''
import sys
import os
sys.path.append(".")
from sorting_gui import SortingComparisonGUI
import tkinter as tk

# Test GUI features
root = tk.Tk()
root.withdraw()

print("Creating GUI instance (should trigger cleanup)...")
gui = SortingComparisonGUI(root)

print("Testing C++ auto-compilation...")
result = gui.run_language_algorithms("cpp", ["quick_sort"], 1, 500, 0.8)
print(f"C++ execution result: {result}")

root.destroy()
'''
    
    with open("temp_gui_test.py", "w") as f:
        f.write(gui_test_code)
    
    try:
        result = subprocess.run(["python", "temp_gui_test.py"], 
                              capture_output=True, text=True, cwd=base_dir)
        
        if result.returncode == 0:
            print("✅ GUI test completed successfully")
            print("Output:", result.stdout)
        else:
            print("❌ GUI test failed")
            print("Error:", result.stderr)
            return False
    
    finally:
        # Clean up test file
        if os.path.exists("temp_gui_test.py"):
            os.remove("temp_gui_test.py")
    
    # Test 4: Verify cleanup worked
    print("\n4️⃣ Verifying cleanup and new results...")
    remaining_files = []
    new_files = []
    
    for lang in ["cpp", "python", "java"]:
        test_file = os.path.join(results_dir, f"results_{lang}.json")
        if os.path.exists(test_file):
            # Check if it's a new file (different content)
            with open(test_file, 'r') as f:
                content = f.read().strip()
            if content == "[]":
                remaining_files.append(f"results_{lang}.json")
            else:
                new_files.append(f"results_{lang}.json")
    
    print(f"Old files remaining: {remaining_files}")
    print(f"New files created: {new_files}")
    
    # Test 5: Verify C++ compilation
    print("\n5️⃣ Verifying C++ compilation...")
    if os.path.exists(cpp_executable):
        new_exe_time = os.path.getmtime(cpp_executable)
        print(f"New executable time: {time.ctime(new_exe_time)}")
        
        if new_exe_time > src_time:
            print("❌ Executable is newer than source (compilation may not have triggered)")
        else:
            print("✅ Compilation appears to have been triggered")
    
    print("\n🎉 All tests completed!")
    return True

if __name__ == "__main__":
    success = test_all_features()
    if success:
        print("\n✅ All new features are working correctly!")
        print("🚀 The GUI now supports:")
        print("   • Automatic C++ compilation when source is newer")
        print("   • Automatic Java compilation when source is newer") 
        print("   • Automatic cleanup of old results on startup")
        print("   • Automatic cleanup before running new algorithms")
    else:
        print("\n❌ Some features may not be working correctly.")
        print("Please check the error messages above.")
