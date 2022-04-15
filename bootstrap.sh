#!/bin/bash
echo "Bootstraping ArgoCD"
kubectl create namespace argocd > /dev/null 2>&1
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.3.3/manifests/install.yaml > /dev/null
kubectl rollout status -n argocd deployment/argocd-server > /dev/null
kubectl apply -f https://raw.githubusercontent.com/mjasion/istio-503-uc/main/k8s/rootapp.yaml
echo "Done."
echo 
echo "ArgoCD credentials: "
echo "    Login: admin"
echo "    Passw: `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`"
echo 
echo "Port forward to Argo: kubectl port-forward svc/argocd-server -n argocd 8080:443"
