# Use a lightweight base image
FROM alpine:latest

# Install required packages (wget and unzip)
RUN apk add --no-cache wget unzip

# Download and unzip the CastarSDK
RUN wget https://download.castarsdk.com/linux.zip -O /tmp/linux.zip && \
    unzip /tmp/linux.zip -d /usr/local/bin && \
    rm /tmp/linux.zip

# Ensure the binaries are executable
RUN chmod +x /usr/local/bin/CastarSdk_386 /usr/local/bin/CastarSdk_amd64 /usr/local/bin/CastarSdk_arm

# Create the runner script with architecture detection
RUN cat << 'EOF' > /usr/local/bin/run_castarsdk.sh
#!/bin/sh
if [ -z "$KEY" ]; then
  echo "Error: KEY environment variable is required"
  exit 1
fi

ARCH=$(uname -m)
case "$ARCH" in
  x86_64) BINARY=CastarSdk_amd64 ;;
  aarch64|arm64) BINARY=CastarSdk_arm ;;
  i386|i686) BINARY=CastarSdk_386 ;;
  *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

echo "Starting CastarSDK. Check your earnings after 24 hours in dashboard"
exec /usr/local/bin/"$BINARY" -key="$KEY"
EOF

# Make script executable
RUN chmod +x /usr/local/bin/run_castarsdk.sh

# Default command
CMD ["/usr/local/bin/run_castarsdk.sh"]
