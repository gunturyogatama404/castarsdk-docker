FROM ubuntu:22.04

ENV TZ=Asia/Jakarta

RUN apt-get update && apt-get install -y \
    curl ca-certificates wget gnupg iputils-ping \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY CastarSdk_amd64 /app/CastarSdk_amd64
RUN chmod +x /app/CastarSdk_amd64

CMD ["./CastarSdk_amd64"]
