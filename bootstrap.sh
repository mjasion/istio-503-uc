#!/bin/bash

echo "Bootstraping Kind"
kind create cluster --config kind-cluster.yaml
echo "Bootstraping ArgoCD"
kubectl --context=kind-kind create namespace argocd > /dev/null 2>&1
kubectl --context=kind-kind apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.3.3/manifests/install.yaml > /dev/null
kubectl --context=kind-kind rollout status -n argocd deployment/argocd-server > /dev/null
kubectl --context=kind-kind rollout status -n argocd deployment/argocd-repo-server > /dev/null
kubectl --context=kind-kind rollout status -n argocd deployment/argocd-redis > /dev/null
kubectl --context=kind-kind rollout status -n argocd deployment/argocd-applicationset-controller > /dev/null
kubectl --context=kind-kind apply -f https://raw.githubusercontent.com/mjasion/istio-upstream-reset/main/k8s/argoapp.yaml
echo "Done."
echo
echo "ArgoCD credentials: "
echo "    Login: admin"
echo "    Passw: `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`"
echo
echo "Port forward to Argo: kubectl port-forward svc/argocd-server -n argocd 8080:443"