#!/bin/bash

echo "Building Logging Application..."

cd src/LoggingApp
docker build -t logging-app:latest .

if [ $? -eq 0 ]; then
    echo "✅ Docker image built successfully!"
    echo "Image: logging-app:latest"
else
    echo "❌ Docker build failed!"
    exit 1
fi

echo "Build completed!"