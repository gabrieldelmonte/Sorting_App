@echo off
REM run-windows.bat - Run the Sorting GUI on Windows with VNC

echo 🪟 Starting Sorting Algorithms GUI on Windows
echo ============================================

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not installed. Please install Docker Desktop for Windows first.
    pause
    exit /b 1
)

REM Check if Docker Compose is available
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    docker compose version >nul 2>&1
    if %errorlevel% neq 0 (
        echo ❌ Docker Compose is not available. Please install Docker Compose.
        pause
        exit /b 1
    )
    set COMPOSE_CMD=docker compose
) else (
    set COMPOSE_CMD=docker-compose
)

REM Navigate to compose directory
cd /d "%~dp0\..\compose"

REM Create results output directory
if not exist "..\..\..\results-output" mkdir "..\..\..\results-output"

echo 🚀 Building and starting the container with VNC...
echo.
echo The GUI will be available via:
echo   - VNC viewer: localhost:5901 (password: will be displayed)
echo   - Web browser: http://localhost:6080
echo.

REM Build and run the container with VNC profile
%COMPOSE_CMD% --profile vnc build
%COMPOSE_CMD% --profile vnc up sorting-gui-vnc

echo.
echo ✅ GUI session ended.
pause
