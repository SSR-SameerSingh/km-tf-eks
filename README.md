This repo contains an example infra provisioner where 
- AWS VPC and subnets will be created
- EKS cluster using the subnets created above

## Pipeline

Pipeline consists of 3 stages:

- Plan
- Apply
- Destroy

Pipeline is created in a way that commit message (cluster-name) is used as the key to store the state in S3. This is done so that we pick the correct state when modifying/destroying an existing cluster.

Destroy stage will only run if ***delete*** file in the terraform directory is modified. 
