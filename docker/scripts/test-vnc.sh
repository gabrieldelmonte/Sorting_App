#!/bin/bash
# test-vnc.sh - Test the VNC functionality

echo "🧪 Testing VNC Service"
echo "====================="

cd "$(dirname "$0")/../compose"

echo "🚀 Starting VNC container..."
docker compose up -d sorting-gui-vnc

echo "⏳ Waiting for VNC server to start..."
sleep 10

echo "🔍 Checking container status..."
docker ps | grep sorting-gui-vnc

echo "📋 Container logs:"
docker logs sorting-gui-vnc | tail -10

echo ""
echo "🌐 VNC Access Information:"
echo "  URL: http://localhost:6080"
echo "  Password: sorting123"
echo ""
echo "🛑 To stop the container:"
echo "  docker compose down"

echo ""
echo "✅ Test complete. Check the URL above to access the GUI."
