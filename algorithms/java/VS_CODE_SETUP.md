# VS Code Java Project Configuration

This directory is configured as a proper Java project for VS Code with the following structure:

## Directory Structure
- `src/` - Java source files
- `lib/` - External JAR dependencies (GSON)
- `bin/` - Compiled class files
- `.vscode/settings.json` - VS Code project configuration

## VS Code Integration

The `.vscode/settings.json` file tells VS Code:
- Source files are in `src/`
- Compiled files go to `bin/`
- JAR dependencies are in `lib/`

This should resolve the GSON import issues you were experiencing.

## Usage

1. **Open the Java directory in VS Code** (this directory: `/algorithms/java/`)
2. **The Java extension should automatically detect** the project structure
3. **GSON imports should now work** without red underlines
4. **Use the run script** for easy compilation and execution: `./run.sh --help`

## If Issues Persist

1. **Reload VS Code window**: Ctrl+Shift+P → "Developer: Reload Window"
2. **Clean workspace**: Ctrl+Shift+P → "Java: Reload Project"
3. **Check Java extension**: Make sure "Extension Pack for Java" is installed

## Alternative: Manual Compilation

If VS Code still has issues, you can always compile manually:
```bash
javac -cp lib/gson-2.10.1.jar -d bin src/SortingAlgorithms.java
java -cp bin:lib/gson-2.10.1.jar SortingAlgorithms --help
```
