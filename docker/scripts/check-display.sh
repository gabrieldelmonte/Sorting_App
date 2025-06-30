#!/bin/bash
# check-display.sh - Helper script to check display server type

echo "🔍 Display Server Detection"
echo "=========================="

if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
    echo "🌊 Session type: Wayland (detected via XDG_SESSION_TYPE)"
elif [[ -n "$WAYLAND_DISPLAY" ]]; then
    echo "🌊 Session type: Wayland (detected via WAYLAND_DISPLAY: $WAYLAND_DISPLAY)"
elif [[ -n "$DISPLAY" ]]; then
    echo "🖼️  Session type: X11 (detected via DISPLAY: $DISPLAY)"
else
    echo "❓ Session type: Unknown (no display environment variables found)"
fi

echo ""
echo "Environment variables:"
echo "  XDG_SESSION_TYPE: ${XDG_SESSION_TYPE:-<not set>}"
echo "  WAYLAND_DISPLAY: ${WAYLAND_DISPLAY:-<not set>}"
echo "  DISPLAY: ${DISPLAY:-<not set>}"

echo ""
if command -v loginctl &> /dev/null; then
    echo "Session info (loginctl):"
    loginctl show-session $(loginctl | grep $(whoami) | awk '{print $1}') -p Type 2>/dev/null || echo "  Could not get session info"
fi

echo ""
echo "Recommended approach:"
if [[ "$XDG_SESSION_TYPE" == "wayland" ]] || [[ -n "$WAYLAND_DISPLAY" ]]; then
    echo "  ✅ Use VNC/web interface (run-linux.sh will auto-detect)"
    echo "  🌐 Access GUI at: http://localhost:6080"
else
    echo "  ✅ Use X11 forwarding (run-linux.sh will auto-detect)"
fi
