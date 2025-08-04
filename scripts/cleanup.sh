#!/bin/bash

ENVIRONMENT=${1:-development}
CLEANUP_OBSERVABILITY=${2:-false}

echo "Cleaning up $ENVIRONMENT environment..."

kustomize build k8s/overlays/$ENVIRONMENT | kubectl delete -f -

if [ $? -eq 0 ]; then
    echo "✅ Application cleanup completed!"
else
    echo "❌ Application cleanup failed!"
fi

echo "Cleaning up observability stack..."
kustomize build k8s/observability | kubectl delete -f -
    
if [ $? -eq 0 ]; then
    echo "✅ Observability stack cleanup completed!"
else
    echo "❌ Observability stack cleanup failed!"
fi

echo "Cleanup completed."