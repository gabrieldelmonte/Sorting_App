# Wayland Support for Sorting Algorithms GUI

This document explains how the containerized GUI handles different display servers on Linux.

## Display Server Detection

The `run-linux.sh` script automatically detects your display server type:

- **X11**: Uses direct X11 forwarding for native performance
- **Wayland**: Uses VNC with web interface for compatibility
- **No Display**: Falls back to VNC with virtual display

## Detection Logic

The script checks these environment variables in order:

1. `$XDG_SESSION_TYPE` - Modern standard for session type
2. `$WAYLAND_DISPLAY` - Wayland-specific display variable
3. `$DISPLAY` - X11 display variable

## Usage

### Automatic (Recommended)
```bash
# Simply run the script - it will auto-detect your display server
./docker/run-linux.sh
```

### Manual Check
```bash
# Check what display server you're using
./docker/check-display.sh
```

## Access Methods

### X11 (Traditional)
- GUI opens directly on your desktop
- Native performance
- Requires X11 forwarding permissions

### Wayland/VNC (Modern)
- GUI accessible via web browser
- Compatible with any display server
- Access at: http://localhost:6080
- VNC password: `sorting123`

## Troubleshooting

### Wayland Issues
If you're on Wayland and have issues:
1. Use the VNC interface (automatic with `run-linux.sh`)
2. Access via: http://localhost:6080
3. Password: `sorting123`

### X11 Issues
If X11 forwarding doesn't work:
1. Check if X11 is properly configured
2. Try: `xhost +local:docker`
3. Or force VNC mode by setting: `export XDG_SESSION_TYPE=wayland`

### Container Issues
```bash
# Check container status
docker ps

# View logs
docker logs sorting-gui-vnc

# Clean restart
docker-compose down && docker-compose up
```

## Security Notes

- VNC server uses password: `sorting123`
- X11 forwarding temporarily allows local Docker access
- Both methods are cleaned up when container stops
- Results are saved to local `results-output/` directory

## Technical Details

### X11 Mode
- Mounts `/tmp/.X11-unix` and `~/.Xauthority`
- Uses host networking for display access
- Requires `xhost +local:docker` permission

### VNC Mode
- Runs Xvfb virtual display (`:1`)
- TightVNC server on port 5901
- noVNC web interface on port 6080
- Fluxbox window manager for GUI support

## Customization

You can force a specific mode by setting environment variables before running:

```bash
# Force VNC mode
export XDG_SESSION_TYPE=wayland
./docker/run-linux.sh

# Force X11 mode (if you have X11 but want to test VNC)
unset XDG_SESSION_TYPE WAYLAND_DISPLAY
export DISPLAY=:0
./docker/run-linux.sh
```
