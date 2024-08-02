# ace42-challenge
This repo contains terraform configuration, helm charts and documentation to successfully start a rundown car.

## Purpose & Description

This is a collection of terraform modules and helm charts to deploy a simple MinIO tenant backend with a s3www frontent on k8s.

## Deployment

### Requirements

To deploy and test the contents of this repo you first need to make sure you have the following tools installed in your system:

- terraform
- helm
- kubectl
- minikube (if you want to deploy to a local development cluster)

### Deploy cluster (optional)

If you do not already havea a minikube profile running in which to deploy the application, you can use the provided module:

``` sh
cd terraform/environments/local/cluster
terraform init
terraform plan
terraform apply
```

This will create a new minikube profile `ace42-local`.

### Deploy application

#### locally

If you have a local cluster ready, you can deploy the application like so: 

``` sh
cd terraform/environments/local/app
terraform init
terraform plan
terraform apply
```

It takes about a minute for the minio tenant endpoint to become ready and setup to complete (patience :)).

### Testing

1. Port-forward the s3www service to your localhost:

``` sh
kubectl port-forward svc/s3www 8080:80 -n minio-tenant
```

2. Then open your browser at http://localhost:8080/
