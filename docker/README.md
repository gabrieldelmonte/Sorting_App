# Docker Setup for Sorting Algorithms Comparison GUI

This directory contains everything needed to run the Sorting Algorithms Comparison GUI in a Docker container, making it portable across all operating systems.

## 🚀 Quick Start

### Linux
```bash
# Auto-detects X11/Wayland and chooses best method
./scripts/run-linux.sh

# For Wayland users: GUI will be accessible at http://localhost:6080
# For X11 users: GUI opens directly on desktop
```

### Linux (Wayland) - Alternative Methods
```bash
# Check your display server type
./check-display.sh

# Force VNC mode (useful for Wayland)
export XDG_SESSION_TYPE=wayland
./scripts/run-linux.sh
# Then access GUI at: http://localhost:6080 (password: sorting123)
```

### macOS
```bash
# Install and start XQuartz first
brew install --cask xquartz
open -a XQuartz
# Then run the application
./scripts/run-macos.sh
```

### Windows
```batch
# Run the batch file (will use VNC)
run-windows.bat
```

## 📋 Prerequisites

### All Platforms
- [Docker](https://www.docker.com/get-started) installed and running
- [Docker Compose](https://docs.docker.com/compose/install/) (usually included with Docker Desktop)

### Linux Additional Requirements
- **X11 Mode**: X11 server running + `xhost` command available
- **Wayland Mode**: Web browser for VNC access (auto-detected)
- **Note**: The script auto-detects your display server (X11/Wayland) and uses the appropriate method

### macOS Additional Requirements
- [XQuartz](https://www.xquartz.org/) installed and running
- XQuartz configured to "Allow connections from network clients"

### Windows Additional Requirements
- VNC viewer (optional, for better experience)
- Web browser (for web-based VNC access)

## 🐳 Docker Files Explained

### `Dockerfile`
Multi-stage Docker build that:
1. **Build Stage**: Compiles C++ and Java algorithms, dataset creator
2. **Runtime Stage**: Installs Python dependencies and GUI requirements
3. **Security**: Runs as non-root user
4. **Flexibility**: Handles both GUI and headless modes

### `docker-compose.yml`
Defines two services:
- `sorting-gui`: For Linux/macOS with X11 forwarding
- `sorting-gui-vnc`: For Windows/Wayland with VNC access (web-based GUI)

### Platform Scripts
- `run-linux.sh`: Auto-detects X11/Wayland and chooses best method
- `run-macos.sh`: Automated setup for macOS with XQuartz
- `run-windows.bat`: Automated setup for Windows with VNC
- `check-display.sh`: Helper script to check your display server type

## 🖥️ Display Server Compatibility

### X11 (Traditional Linux)
- ✅ Direct GUI forwarding
- ✅ Native performance
- ✅ Seamless integration

### Wayland (Modern Linux)
- ✅ VNC with web interface
- ✅ Access via http://localhost:6080
- ✅ Password: `sorting123`
- ✅ Compatible with any browser

### Auto-Detection
The `run-linux.sh` script automatically detects your display server:
- Checks `$XDG_SESSION_TYPE`
- Checks `$WAYLAND_DISPLAY`
- Falls back to VNC if no display available

## 🔧 Manual Docker Commands

### Build the Image
```bash
docker build -t sorting-algorithms-gui .
```

### Run on Linux (X11)
```bash
# Allow X11 connections
xhost +local:docker

# Run container
docker run -it --rm \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  -v ~/.Xauthority:/home/appuser/.Xauthority:ro \
  -v $(pwd)/results-output:/app/resources/results \
  --network=host \
  sorting-algorithms-gui

# Restore X11 permissions
xhost -local:docker
```

### Run on macOS (XQuartz)
```bash
# Get IP address
IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}' | head -n1)
xhost + $IP

# Run container
docker run -it --rm \
  -e DISPLAY=$IP:0 \
  -v $(pwd)/results-output:/app/resources/results \
  sorting-algorithms-gui

# Clean up
xhost - $IP
```

### Run with VNC (All Platforms)
```bash
# Run with virtual display
docker run -it --rm \
  -p 5901:5901 \
  -p 6080:6080 \
  -v $(pwd)/results-output:/app/resources/results \
  sorting-algorithms-gui

# Then connect via VNC to localhost:5901 or web browser to http://localhost:6080
```

## 📂 Directory Structure

```
Sorting_App/
├── Dockerfile              # Multi-stage Docker build
├── docker-compose.yml      # Container orchestration
├── .dockerignore           # Files to exclude from build
├── run-linux.sh           # Linux launcher script
├── run-macos.sh           # macOS launcher script
├── run-windows.bat        # Windows launcher script
├── algorithms/            # Source code (will be compiled in container)
├── resources/             # Dataset creators and results
├── ui/                    # GUI application and requirements
└── results-output/        # Host-mounted results directory
```

## 🎯 Features

### Cross-Platform Compatibility
- **Linux**: Native X11 forwarding for best performance
- **macOS**: XQuartz integration for seamless experience
- **Windows**: VNC-based access with web interface option

### Automated Compilation
- C++ algorithms compiled with optimizations
- Java algorithms compiled with proper classpath
- Dataset creator tools built and ready

### Persistent Results
- Results directory mounted to host filesystem
- Generated data persists between container runs
- Easy access to benchmark outputs

### Security
- Non-root user execution
- Minimal attack surface
- Clean container shutdown

## 🔍 Troubleshooting

### Linux Issues
```bash
# If X11 permission denied
xhost +local:docker

# If display issues
echo $DISPLAY  # Should show :0 or similar
```

### macOS Issues
```bash
# If XQuartz not working
# 1. Restart XQuartz
# 2. Check XQuartz preferences: "Allow connections from network clients"
# 3. Try: xhost +localhost
```

### Windows Issues
```batch
# If VNC connection fails
# 1. Check if ports 5901/6080 are available
# 2. Try web interface: http://localhost:6080
# 3. Check Docker Desktop is running
```

### General Docker Issues
```bash
# Clean rebuild
docker-compose down
docker system prune -f
docker-compose build --no-cache

# Check container logs
docker-compose logs sorting-gui
```

## 🚀 Performance Tips

1. **Allocate sufficient resources** to Docker (2GB+ RAM recommended)
2. **Use native X11** on Linux for best performance
3. **Close other GUI applications** when running resource-intensive benchmarks
4. **Mount results directory** to save outputs between runs

## 📊 Usage Examples

Once the container is running, you can:

1. **Select algorithms and languages** for comparison
2. **Configure benchmark parameters** (runs, elements, perturbation)
3. **Run new benchmarks** with custom datasets
4. **Export visualizations** for presentations
5. **View results** in the mounted `results-output/` directory

The GUI will automatically handle compilation and execution of algorithms across all three languages (C++, Python, Java) within the container environment.

## 🤝 Contributing

To modify the application:

1. Edit source files in the host filesystem
2. Rebuild the container: `docker-compose build`
3. Run with your changes: `./scripts/run-linux.sh` (or platform equivalent)

The container will automatically compile updated source code and reflect your changes.
