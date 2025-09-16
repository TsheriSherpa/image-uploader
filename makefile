# Variables
APP_NAME := image-uploader
IMAGE := image-uploader:latest
HELM_RELEASE := uploader
HELM_CHART := ./image-uploader
CONTAINER_PORT := 5000
SERVICE_NAME := $(HELM_RELEASE)-$(APP_NAME)

# Use bash with error/trace flags
SHELL := /bin/bash
.SHELLFLAGS := -xeuo pipefail -c

# Switch Docker CLI to Minikube
minikube-docker:
	@echo "Starting Minikube..."
	minikube start --driver=docker --memory=3909 --cpus=2

add-ingress:
	@echo "Adding Ingress Addon..."
	minikube addons enable ingress

# Build Docker image inside Minikube
build: minikube-docker add-ingress
	@echo "Switching Docker to Minikube..."
	@echo "Building Docker image..."
	eval $$(minikube docker-env) && docker build -t $(IMAGE) . 2>&1 | tee build.log

# Delete old Helm release
helm-uninstall:
	@echo "Uninstalling Helm release if exists..."
	-helm uninstall $(HELM_RELEASE) || true

# Install or upgrade Helm chart
helm-deploy: build helm-uninstall
	@echo "Deploying Helm chart..."
	helm upgrade --install $(HELM_RELEASE) $(HELM_CHART) 2>&1 | tee helm.log

# Show pods
pods:
	kubectl get pods

# Show logs of the pod
logs:
	kubectl logs -l app=$(APP_NAME) --tail=50 -f

# Full deploy (build + helm)
deploy: build helm-deploy pods

# Clean Minikube cluster
minikube-clean:
	@echo "Deleting Minikube cluster..."
	kubectl delete all --all
	minikube stop
	minikube delete

# Show Docker images in Minikube
images: minikube-docker
	docker images

.PHONY: minikube-docker build helm-uninstall helm-deploy pods logs deploy minikube-clean images add-ingress