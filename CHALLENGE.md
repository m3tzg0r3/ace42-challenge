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
 7. Read documentation about MinIO chart configuration options to integrate.
 8. Extend tf module to setup the MinIO tenant so the gif is downloaded and put into the tenant bucket.
 9. Create simple s3www helm chart and tf module to deploy it
10. Lots of stupid mistakes like using {} instead of ()
11. Fiddling with randomized k8s secrets and other bells and whistles
 
## Issues
 
 - Managing the minikube cluster together with the other resources induces dependency hell where the kubectl context is not available to track the k8s resources if the minikube cluster is destroyed completely
 
- s3www seems to persistently fail to connect to minio (403) - tried randomly generated keys as well as default user/pw - apparently this happens when connecting via https.

- I lost way too much time trying too hard - implementing random secrets and "best practices" out of the box made it hard to debug especially when not at the top of my game (I did the last stretch late at night, >> many typos and wrong parantheses{})

- This is missing a proper production ready configuration, so my todo list would look somewhat like this:

##### TODO

  - [ ] Add tf module for ingress controller deployment
  - [ ] Add (and use) unprivileged minio user
  - [ ] Add service accounts
  - [ ] Add proper ssl configuration
  - [ ] Restructure so the main tf module can be used in multiple environments

## Final notes

This was a lot of fun and a good opportunity for me to dig back into terraform, even though i kind of overengineered parts of this and as such ran out of time which was already pretty limited this week. I hope we can discuss the many areas of improvement.
