# 🚀 Image Uploader

A cloud-native **image uploading service** built with modern **DevOps workflow** and deployed on **Kubernetes**.  
Demonstrates **backend microservices**, containerization, and **CI/CD automation**.

---

## 📋 Table of Contents

- [Project Overview](#project-overview)  
- [Tech Stack](#tech-stack)  
- [Features](#features)  
- [Architecture](#architecture)  
- [Challenges & Solutions](#challenges--solutions)  
- [Setup & Deployment](#setup--deployment)  
- [Contributing](#contributing)  
- [License](#license)  

---

## 🖼️ Project Overview

This project is an **image uploader service** that allows users to upload images to a backend, which stores them securely and makes them accessible via an API.  

- Built for **scalability** and **maintainability**  
- Uses **containerization** and **Kubernetes orchestration**  
- Deployed on **Minikube** locally, compatible with **AWS EKS**

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|------------|
| **Backend** | Python Flask, Go (optional microservices) |
| **Frontend** | HTML/CSS |
| **Containerization** | Docker |
| **Orchestration** | Kubernetes, Minikube (local), compatible with AWS EKS |
| **CI/CD** | Jenkins (pipeline), Docker Hub, Helm |
| **Database** | AWS s3 |

---

## ✨ Features

- Upload images via **REST API**  
- Secure storage in **containerized backend**  
- Automated **CI/CD pipeline** using Jenkins & Docker Hub  
- **Kubernetes deployment** with Helm charts  
- Scalable **microservices architecture**

---

## 🏗️ Architecture

[Client] --> [Flask API] --> [Database / Storage]

--> [Docker Container] --> [Kubernetes Pod]

yaml
Copy code

- Docker ensures **consistent environments**  
- Helm provides **templated Kubernetes deployment**  
- Jenkins automates **build, push, and deploy processes**

---

## ⚡ Challenges & Solutions

| Challenge | Solution |
|-----------|---------|
| Running Minikube inside Jenkins container | Resolved host networking & certificate issues using `host.docker.internal` and updated kubeconfig |
| TLS certificate errors (`x509`) | Used `--insecure-skip-tls-verify` locally; proper CA needed for production |
| Helm chart errors (`Chart.yaml missing`) | Reorganized project structure to match Helm’s expected chart format |
| CI/CD automation with Jenkins | Configured Jenkins pipelines for Docker build, push, and Helm deployment |
| File permission issues in Jenkins container | Fixed `.kube` folder ownership & adjusted permissions (`chmod -R 755 ~/.kube`) |

---

## ⚙️ Setup & Deployment

### Prerequisites

- Docker  
- Kubernetes (Minikube for local)  
- Helm  
- Jenkins (CI/CD automation)  

### Steps

**1️⃣ Clone repository**

```bash
git clone https://github.com/tsheri/image-uploader.git
cd image-uploader
2️⃣ Build Docker image

bash
Copy code
docker build -t tsheri/image-uploader:latest .
docker push tsheri/image-uploader:latest
3️⃣ Deploy with Helm

bash
Copy code
helm upgrade --install image-uploader ./helm-chart \
    --namespace dev \
    --set image.repository=tsheri/image-uploader \
    --set image.tag=latest
4️⃣ Verify deployment


kubectl get pods -n dev
kubectl get svc -n dev
