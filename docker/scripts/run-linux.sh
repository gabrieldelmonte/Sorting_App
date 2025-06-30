#!/bin/bash
# run-linux.sh - Run the Sorting GUI on Linux with X11 forwarding or VNC (Wayland)

set -e

echo "🐧 Starting Sorting Algorithms GUI on Linux"
echo "============================================"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not available. Please install Docker Compose."
    exit 1
fi

# Detect display server type and Docker environment
USE_VNC=false
FORCE_VNC=false

# TEMPORARY: Force X11 mode to see GUI on screen
echo "🖼️  Forcing X11 mode to display GUI on your screen"
USE_VNC=false
FORCE_VNC=false

# Check if X11 socket is accessible
if [[ -n "$DISPLAY" ]] && [[ ! -S "/tmp/.X11-unix/X${DISPLAY#*:}" ]]; then
    echo "⚠️  X11 socket not accessible - this might be Docker Desktop"
    FORCE_VNC=true
fi

# Check if we're running in Docker Desktop environment
if docker info 2>/dev/null | grep -q "Docker Desktop"; then
    echo "🐳 Docker Desktop detected - but trying X11 anyway"
    # FORCE_VNC=true  # Commented out to force X11 attempt
fi

if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
    echo "🌊 Wayland detected - using VNC virtual display"
    USE_VNC=true
elif [[ -n "$WAYLAND_DISPLAY" ]]; then
    echo "🌊 Wayland detected via WAYLAND_DISPLAY - using VNC virtual display"
    USE_VNC=true
elif [[ -z "$DISPLAY" ]]; then
    echo "🖥️  No display detected - using VNC virtual display"
    USE_VNC=true
elif [[ "$FORCE_VNC" == "true" ]]; then
    echo "🐳 Using VNC due to Docker environment limitations"
    USE_VNC=true
else
    echo "🖼️  X11 detected - attempting direct X11 forwarding"
    # Allow X11 connections from Docker container
    echo "🔓 Allowing X11 connections..."
    if ! xhost +local:docker 2>/dev/null; then
        echo "⚠️  Failed to configure X11 access - falling back to VNC"
        USE_VNC=true
    fi
fi

# Navigate to compose directory
cd "$(dirname "$0")/../compose"

# Create results output directory
mkdir -p ../../../results-output

echo "🚀 Building and starting the container..."

# Use docker compose (newer) or docker-compose (older)
if docker compose version &> /dev/null; then
    COMPOSE_CMD="docker compose"
else
    COMPOSE_CMD="docker-compose"
fi

# Build the container
$COMPOSE_CMD build

if [[ "$USE_VNC" == "true" ]]; then
    echo "🌐 Starting virtual display service..."
    echo "📋 This mode uses a virtual display (headless) - perfect for Docker Desktop and Wayland"
    echo "� The GUI will run inside the container with a virtual display"
    echo "� Results will be saved to: results-output/"
    echo ""
    echo "🔄 Starting container with virtual display..."
    $COMPOSE_CMD up sorting-gui-vnc
else
    echo "🖼️  Starting container with X11 forwarding..."
    
    # Try the standard X11 service first
    echo "🔄 Attempting standard X11 forwarding..."
    if ! $COMPOSE_CMD up sorting-gui 2>/dev/null; then
        echo "⚠️  Standard X11 forwarding failed (likely Docker Desktop)"
        echo "🔄 Trying simplified X11 mode..."
        
        # Clean up failed container
        $COMPOSE_CMD down sorting-gui 2>/dev/null || true
        
        # Try the simplified X11 service
        if ! $COMPOSE_CMD up sorting-gui-x11-simple 2>/dev/null; then
            echo "❌ X11 forwarding not working, switching to VNC mode..."
            echo "🌐 Starting VNC service instead..."
            echo "📋 Access GUI at: http://localhost:6080 (password: sorting123)"
            
            # Clean up and start VNC
            $COMPOSE_CMD down 2>/dev/null || true
            $COMPOSE_CMD up sorting-gui-vnc
        fi
    fi
    
    # Clean up X11 permissions when done (if we used X11)
    if [[ "$FORCE_VNC" != "true" ]]; then
        echo "🔒 Restoring X11 permissions..."
        xhost -local:docker 2>/dev/null || true
    fi
fi

echo "✅ GUI session ended."

# Provide helpful information
echo ""
echo "💡 Tips:"
if [[ "$USE_VNC" == "true" ]]; then
    echo "   • Virtual display mode used (perfect for Docker Desktop/Wayland)"
    echo "   • GUI runs headless inside container"
    echo "   • Results saved to: results-output/"
    echo "   • If you need to see the GUI visually, consider using X11 forwarding"
else
    echo "   • If you have display issues, try running: docker/check-display.sh"
    echo "   • Results are saved to: results-output/"
fi
