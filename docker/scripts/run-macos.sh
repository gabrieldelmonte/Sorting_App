#!/bin/bash
# run-macos.sh - Run the Sorting GUI on macOS with XQuartz

set -e

echo "🍎 Starting Sorting Algorithms GUI on macOS"
echo "============================================"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker Desktop for Mac first."
    exit 1
fi

# Check if XQuartz is running
if ! pgrep -f "XQuartz\|X11" > /dev/null; then
    echo "❌ XQuartz is not running. Please start XQuartz first:"
    echo "   1. Install XQuartz: brew install --cask xquartz"
    echo "   2. Start XQuartz: open -a XQuartz"
    echo "   3. In XQuartz preferences, enable 'Allow connections from network clients'"
    exit 1
fi

# Get IP address for X11 forwarding
IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}' | head -n1)
if [ -z "$IP" ]; then
    IP="host.docker.internal"
fi

echo "🔓 Allowing X11 connections from $IP..."
xhost + $IP

# Set DISPLAY for Docker container
export DISPLAY=$IP:0

# Navigate to compose directory
cd "$(dirname "$0")/../compose"

# Create results output directory
mkdir -p ../../../results-output

echo "🚀 Building and starting the container..."

# Use docker compose (newer) or docker-compose (older)
if docker compose version &> /dev/null 2>&1; then
    COMPOSE_CMD="docker compose"
else
    COMPOSE_CMD="docker-compose"
fi

# Build and run the container
$COMPOSE_CMD build
$COMPOSE_CMD up sorting-gui

# Clean up X11 permissions when done
echo "🔒 Restoring X11 permissions..."
xhost - $IP

echo "✅ GUI session ended."
