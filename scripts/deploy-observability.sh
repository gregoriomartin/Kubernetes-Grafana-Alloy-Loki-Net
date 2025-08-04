#!/bin/bash

echo "Deploying Observability Stack (Grafana, Loki, Alloy)..."

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed or not in PATH"
    exit 1
fi

# Check if kustomize is available
if ! command -v kustomize &> /dev/null; then
    echo "❌ kustomize is not installed or not in PATH"
    exit 1
fi

# Deploy observability stack
echo "Creating observability namespace and deploying stack..."
kustomize build k8s/observability | kubectl apply -f -

if [ $? -eq 0 ]; then
    echo "✅ Observability stack deployment initiated!"
    
    echo "Waiting for Loki to be ready..."
    kubectl wait --for=condition=ready pod -l app=loki -n observability --timeout=300s
    
    echo "Waiting for Grafana to be ready..."
    kubectl wait --for=condition=ready pod -l app=grafana -n observability --timeout=300s
    
    echo "Waiting for Alloy to be ready..."
    kubectl wait --for=condition=ready pod -l app=alloy -n observability --timeout=300s
    
    echo ""
    echo "📊 Observability Stack Status:"
    kubectl get pods -n observability
    kubectl get services -n observability
    
    echo ""
    echo "🌐 Access URLs:"
    echo "  - Grafana: http://localhost:30300 (admin/admin)"
    echo "  - Loki API: http://localhost:30100 (if exposed)"
    
    echo ""
    echo "📋 Default Grafana Credentials:"
    echo "  Username: admin"
    echo "  Password: admin"
    
    echo ""
    echo "🔍 Pre-configured Dashboard:"
    echo "  - '.NET Core Application Logs' dashboard is available"
    echo "  - Loki datasource is pre-configured"
    
else
    echo "❌ Observability stack deployment failed!"
    exit 1
fi