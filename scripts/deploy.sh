#!/bin/bash

ENVIRONMENT=${1:-development}

echo "Deploying to $ENVIRONMENT environment..."

if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed or not in PATH"
    exit 1
fi

if ! command -v kustomize &> /dev/null; then
    echo "❌ kustomize is not installed or not in PATH"
    echo "You can install it with: curl -s https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh | bash"
    exit 1
fi

echo "Applying Kubernetes manifests for $ENVIRONMENT..."
kustomize build k8s/overlays/$ENVIRONMENT | kubectl apply -f -

if [ $? -eq 0 ]; then
    echo "✅ Application deployment successful!"
    echo "Waiting for pods to be ready..."
    kubectl wait --for=condition=ready pod -l app=logging-app --timeout=300s
    
    echo ""
    echo "📊 Deployment Status:"
    kubectl get pods -l app=logging-app
    kubectl get services -l app=logging-app
    
    echo ""
    echo "🌐 Access the application:"
    echo "  - Swagger UI: http://localhost:30080/swagger"
    echo "  - Health Check: http://localhost:30080/health"
    echo "  - Generate Logs: POST http://localhost:30080/api/log/generate/50"
    
else
    echo "❌ Deployment failed!"
    exit 1
fi