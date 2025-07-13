# Use a lightweight base image
FROM alpine:latest

# Install required packages (wget, unzip, libc6-compat for glibc compatibility)
RUN apk add --no-cache wget unzip libc6-compat

# Download and unzip the CastarSDK
RUN wget https://download.castarsdk.com/linux.zip -O /tmp/linux.zip && \
    unzip /tmp/linux.zip -d /usr/local/bin && \
    rm /tmp/linux.zip

# Ensure the binaries are executable
RUN chmod +x /usr/local/bin/CastarSdk_386 /usr/local/bin/CastarSdk_amd64 /usr/local/bin/CastarSdk_arm

# Create the runner script with architecture detection
RUN echo '#!/bin/sh' > /usr/local/bin/run_castarsdk.sh && \
    echo 'if [ -z "$KEY" ]; then' >> /usr/local/bin/run_castarsdk.sh && \
    echo '  echo "Error: KEY environment variable is required"' >> /usr/local/bin/run_castarsdk.sh && \
    echo '  exit 1' >> /usr/local/bin/run_castarsdk.sh && \
    echo 'fi' >> /usr/local/bin/run_castarsdk.sh && \
    echo '' >> /usr/local/bin/run_castarsdk.sh && \
    echo 'ARCH=$(uname -m)' >> /usr/local/bin/run_castarsdk.sh && \
    echo 'case "$ARCH" in' >> /usr/local/bin/run_castarsdk.sh && \
    echo '  x86_64) BINARY=CastarSdk_amd64 ;;' >> /usr/local/bin/run_castarsdk.sh && \
    echo '  aarch64|arm64) BINARY=CastarSdk_arm ;;' >> /usr/local/bin/run_castarsdk.sh && \
    echo '  i386|i686) BINARY=CastarSdk_386 ;;' >> /usr/local/bin/run_castarsdk.sh && \
    echo '  *) echo "Unsupported architecture: $ARCH"; exit 1 ;;' >> /usr/local/bin/run_castarsdk.sh && \
    echo 'esac' >> /usr/local/bin/run_castarsdk.sh && \
    echo '' >> /usr/local/bin/run_castarsdk.sh && \
    echo 'echo "Starting CastarSDK. Check your earnings after 24 hours in dashboard"' >> /usr/local/bin/run_castarsdk.sh && \
    echo 'exec /usr/local/bin/"$BINARY" -key="$KEY"' >> /usr/local/bin/run_castarsdk.sh

# Make script executable
RUN chmod +x /usr/local/bin/run_castarsdk.sh

# Set the entrypoint
CMD ["/usr/local/bin/run_castarsdk.sh"]
