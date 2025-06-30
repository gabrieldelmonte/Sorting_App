# Dockerfile for Sorting Algorithms Comparison GUI
# Multi-stage build for optimized container size

# Build stage
FROM ubuntu:22.04 AS builder

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    g++ \
    openjdk-17-jdk \
    python3 \
    python3-pip \
    python3-dev \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Copy source code for compilation
COPY algorithms/ /app/algorithms/
COPY resources/ /app/resources/

WORKDIR /app

# Compile C++ algorithms
RUN cd algorithms/cpp && \
    g++ -std=c++17 -O2 algorithms.cpp -o algorithms

# Compile Java algorithms
RUN cd algorithms/java && \
    javac -cp lib/gson-2.10.1.jar -d bin src/SortingAlgorithms.java

# Compile dataset creator
RUN cd resources/sets && \
    g++ -std=c++17 -O2 creator.cpp -o creator

# Runtime stage
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV DISPLAY=:0
ENV PYTHONUNBUFFERED=1

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-tk \
    openjdk-17-jre \
    x11-apps \
    x11-utils \
    xauth \
    xvfb \
    fonts-dejavu-core \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    libfontconfig1 \
    libice6 \
    && rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME for runtime
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Create app directory
WORKDIR /app

# Copy compiled binaries and all project files from builder stage
COPY --from=builder /app/ /app/

# Copy UI code and requirements
COPY ui/ /app/ui/

# Install Python dependencies
RUN cd ui && pip3 install --no-cache-dir -r requirements.txt

# Create a non-root user for security
#RUN useradd -m -s /bin/bash appuser && \
#    chown -R appuser:appuser /app

# Switch to non-root user
#USER appuser

# Set working directory to UI
WORKDIR /app/ui

# Create startup script that handles both GUI and headless modes
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
# Function to check if DISPLAY is available\n\
check_display() {\n\
    if [ -n "$DISPLAY" ]; then\n\
        echo "🖥️  Display variable set: $DISPLAY"\n\
        # Try to connect to X server\n\
        if timeout 5 xset q >/dev/null 2>&1; then\n\
            echo "✅ X11 display available: $DISPLAY"\n\
            return 0\n\
        elif [ "$DISPLAY" != ":99" ]; then\n\
            echo "⚠️  Display set but X server not responding, but trying anyway: $DISPLAY"\n\
            return 0\n\
        fi\n\
    fi\n\
    echo "❌ No X11 display available"\n\
    return 1\n\
}\n\
\n\
# Function to start virtual display\n\
start_virtual_display() {\n\
    echo "🖥️  Starting virtual display..."\n\
    Xvfb :99 -screen 0 1024x768x24 -ac +extension GLX +render -noreset &\n\
    export DISPLAY=:99\n\
    sleep 2\n\
    echo "✅ Virtual display started: $DISPLAY"\n\
}\n\
\n\
echo "🚀 Starting Sorting Algorithms Comparison GUI..."\n\
echo "=========================================="\n\
\n\
# Check if we can use host display, otherwise start virtual display\n\
if ! check_display; then\n\
    start_virtual_display\n\
fi\n\
\n\
echo "🐍 Python version: $(python3 --version)"\n\
echo "☕ Java version: $(java -version 2>&1 | head -n1)"\n\
echo "🔨 GCC version: $(gcc --version | head -n1)"\n\
echo\n\
\n\
# Run the GUI\n\
echo "🎯 Launching GUI application..."\n\
python3 sorting_gui.py "$@"\n\
' > /app/start.sh && chmod +x /app/start.sh

# Expose any ports if needed (none for this GUI app)
# EXPOSE 8080

# Health check to verify the application can start
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD python3 -c "import tkinter; import matplotlib.pyplot; print('GUI dependencies OK')" || exit 1

# Set the entrypoint
ENTRYPOINT ["/app/start.sh"]

# Default command
CMD []

# Add labels for documentation
LABEL org.opencontainers.image.title="Sorting Algorithms Comparison GUI"
LABEL org.opencontainers.image.description="A comprehensive GUI for comparing sorting algorithm performance across C++, Python, and Java"
LABEL org.opencontainers.image.version="1.0"
LABEL org.opencontainers.image.authors="Gabriel Del Monte && Gabrielle Gomes && Leonardo Marinho"
