#!/bin/bash
# vnc-start.sh - VNC startup script

set -e

echo "🌐 Starting VNC virtual display server..."

# Start Xvfb virtual display
Xvfb :1 -screen 0 1280x1024x24 -ac +extension GLX +render -noreset &
XVFB_PID=$!

# Set display
export DISPLAY=:1

# Wait for display to start
sleep 3

echo "✅ Virtual display started on :1"

# Check if GUI dependencies are available
echo "🔍 Checking GUI dependencies..."
python3 -c "
import tkinter
import matplotlib.pyplot
print('✅ GUI dependencies OK')
"

# Start the GUI application
echo "🎯 Launching Sorting GUI..."
cd /app/ui
exec python3 sorting_gui.py "$@"
