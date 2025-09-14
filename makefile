# Variables
APP_NAME := image-uploader
IMAGE := image-uploader:latest
HELM_RELEASE := uploader
HELM_CHART := ./image-uploader
CONTAINER_PORT := 5000
SERVICE_NAME := $(HELM_RELEASE)-$(APP_NAME)

# Switch Docker CLI to Minikube
minikube-docker:
	@echo "Switching Docker to Minikube..."
	@eval $$(minikube docker-env)

# Build Docker image inside Minikube
build: minikube-docker
	@echo "Building Docker image..."
	@eval $$(minikube docker-env) && docker build -t $(IMAGE) .

# Delete old Helm release
helm-uninstall:
	@echo "Uninstalling Helm release if exists..."
	-helm uninstall $(HELM_RELEASE)

# Install or upgrade Helm chart
helm-deploy: build helm-uninstall
	@echo "Deploying Helm chart..."
	helm upgrade --install $(HELM_RELEASE) $(HELM_CHART)

# Show pods
pods:
	@kubectl get pods

# Show logs of the pod
logs:
	@kubectl logs -l app=$(APP_NAME) --tail=50 -f

# Access the service in browser
service-url:
	@echo "Getting service URL..."
	@minikube service $(SERVICE_NAME) --url

# Full deploy (build + helm)
deploy: build helm-deploy pods service-url

# Clean Minikube cluster
minikube-clean:
	@echo "Deleting Minikube cluster..."
	minikube delete
	minikube start --driver=docker --memory=4096 --cpus=2

# Show Docker images in Minikube
images: minikube-docker
	docker images

.PHONY: minikube-docker build helm-uninstall helm-deploy pods logs service-url deploy minikube-clean images
