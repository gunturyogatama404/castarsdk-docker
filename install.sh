#!/bin/bash

IMAGE="ghcr.io/gunturyogatama404/castarsdk:latest"
CONTAINER_NAME="castarsdk"

# Stop dan hapus container lama jika ada
docker rm -f $CONTAINER_NAME 2>/dev/null

# Tarik image dari GHCR
docker pull $IMAGE

# Jalankan container
docker run -d \
  --name $CONTAINER_NAME \
  --restart always \
  --network host \
  --cap-add=NET_ADMIN \
  $IMAGE

echo "✅ CastarSDK container is running as '$CONTAINER_NAME'"
