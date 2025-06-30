#!/bin/bash
# run-linux-dockerdesktop.sh - Run with VNC for Docker Desktop users

set -e

echo "🐳 Starting Sorting GUI for Docker Desktop (VNC Mode)"
echo "===================================================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Navigate to compose directory
cd "$(dirname "$0")/../compose"

# Create results output directory
mkdir -p ../../../results-output

echo "🚀 Building and starting VNC container..."

# Use docker compose (newer) or docker-compose (older)
if docker compose version &> /dev/null; then
    COMPOSE_CMD="docker compose"
else
    COMPOSE_CMD="docker-compose"
fi

# Build and run the VNC container
$COMPOSE_CMD build
$COMPOSE_CMD up sorting-gui-vnc

echo "✅ GUI session ended."

echo ""
echo "💡 Docker Desktop Users:"
echo "   • This script forces VNC mode to avoid mount issues"
echo "   • Access GUI at: http://localhost:6080"
echo "   • Password: sorting123"
echo "   • Results saved to: results-output/"
