# Challenge Notes

This file contains notes, considerations, ramblings, justifications and excuses.

## Setup phase

To prepare for the implementation, the following steps were neccessary:

 1. Fix my Emacs config to support LSP and Tree-Sitter for terraform etc.
 2. Make sure terraform, helm, minikube, docker desktop, kubectl and editor dependencies are installed.
 3. Initialize git repo on GitHub, then clone
 4. Make sure gitconfig is updated... after the first commit ofc :E

## Implementation

This section serves as kind of a step by step log of what i did to make this work:

 1. Set up a folder structure in the repo to organize files into.
 2. Think about how i want to structure the terraform manifest files, end up creating a `environments` and `modules` folder.
 3. Create minikube terraform module and local env terraform manifest to create the minikube cluster for the local dev env.
 4. Switch to helm charts, start with MinIO.
 5. Read Documentation about MinIO, find helm chart to deploy MinIO operator - follow that. (https://min.io/docs/minio/kubernetes/upstream/operations/install-deploy-manage/deploy-operator-helm.html#)
 6. Build terraform module to install MinIO operator.
 7. 

