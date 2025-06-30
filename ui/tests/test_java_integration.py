#!/usr/bin/env python3
"""
Test script to verify Java integration in the GUI
"""
import os
import subprocess
import tempfile

def test_java_execution():
    """Test if Java algorithms can be executed correctly"""
    
    # Paths
    base_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(base_dir)
    java_dir = os.path.join(project_root, "algorithms", "java")
    creator_path = os.path.join(project_root, "resources", "sets", "creator")
    
    print("Testing Java Integration...")
    print(f"Java directory: {java_dir}")
    
    # Check if Java directory exists
    if not os.path.exists(java_dir):
        print("❌ Java directory not found!")
        return False
    
    # Check if compiled classes exist
    bin_dir = os.path.join(java_dir, "bin")
    if not os.path.exists(bin_dir):
        print("❌ Java bin directory not found!")
        return False
    
    # Check if GSON library exists
    lib_dir = os.path.join(java_dir, "lib")
    gson_jar = os.path.join(lib_dir, "gson-2.10.1.jar")
    if not os.path.exists(gson_jar):
        print("❌ GSON library not found!")
        return False
    
    # Create a temporary dataset
    with tempfile.NamedTemporaryFile(mode='w', suffix='.txt', delete=False) as f:
        temp_dataset = f.name
        
    try:
        # Generate test dataset using creator
        if os.path.exists(creator_path):
            print("Generating test dataset...")
            result = subprocess.run([
                creator_path, "--size", "500", "--perturbation", "0.5", 
                "--distribution", "uniform", "--output", temp_dataset
            ], capture_output=True, text=True)
            
            if result.returncode != 0:
                print(f"❌ Dataset creation failed: {result.stderr}")
                return False
        else:
            print("⚠️  Creator not found, using simple dataset")
            with open(temp_dataset, 'w') as f:
                f.write(" ".join(map(str, range(500, 0, -1))))  # Reverse sorted
        
        # Test Java execution with correct classpath
        print("Testing Java execution...")
        classpath = f"bin{os.pathsep}lib/gson-2.10.1.jar"
        cmd = [
            "java", "-cp", classpath, "SortingAlgorithms",
            "--file", temp_dataset,
            "--algorithms", "quick_sort,merge_sort",
            "--runs", "2"
        ]
        
        result = subprocess.run(cmd, capture_output=True, text=True, cwd=java_dir)
        
        if result.returncode == 0:
            print("✅ Java execution successful!")
            print("Sample output:", result.stdout[:200] + "..." if len(result.stdout) > 200 else result.stdout)
            return True
        else:
            print(f"❌ Java execution failed!")
            print(f"Error: {result.stderr}")
            print(f"Stdout: {result.stdout}")
            return False
    
    finally:
        # Clean up temporary file
        if os.path.exists(temp_dataset):
            os.remove(temp_dataset)

if __name__ == "__main__":
    success = test_java_execution()
    if success:
        print("\n🎉 Java integration test PASSED!")
        print("The GUI should now be able to run Java algorithms successfully.")
    else:
        print("\n💥 Java integration test FAILED!")
        print("Please check the Java setup and try again.")
