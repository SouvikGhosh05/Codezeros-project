# Codezeros-project

Kubernetes application deployment for the nginx web server, Dockerfile for Node app and Terraform resources

Deploy the Kubernetes project with `kubectl apply -f kube-deployment-nginx/`

Build the nodejs container with `cd nodejsapp/ && sudo docker build -t sample-nodejsapp .`

To deploy the Terraform project with Ansible configuration, you are needed to install Ansible on your local machine, then you need to configure your aws console with the access key & secret key for the authentication to your account.
Then run `terraform -chdir=terraform-aws apply` to build the infra and deploy the nodejs app with Ansible.