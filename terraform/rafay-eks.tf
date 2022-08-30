resource "rafay_eks_cluster" "km-eks-demo1" {
  cluster {
    kind = "Cluster"
    metadata {
      name    = var.cluster_name
      project = var.project_name
    }
    spec {
      type           = "eks"
      blueprint      = var.blueprint
      blueprint_version = var.blueprint_version
      cloud_provider = var.cloud_credential
      cni_provider   = "aws-cni"
      proxy_config   = {}
    }
  }
  cluster_config {
    apiversion = "rafay.io/v1alpha5"
    kind       = "ClusterConfig"
    metadata {
      name    = var.cluster_name
      region  = var.aws_region
      version = var.k8s_version
    }
    vpc {
      subnets {
        private {
          name = "private-2a"
          id   = aws_subnet.km-tf-subnet-private-2a.id
        }
        private {
          name = "private-2b"
          id   = aws_subnet.km-tf-subnet-private-2b.id
        }
        public {
          name = "public-2a"
          id   =  aws_subnet.km-tf-subnet-public-2a.id
        }
        public {
          name = "public-2b"
          id   = aws_subnet.km-tf-subnet-public-2b.id
        }
      }
      cluster_endpoints {
        private_access = true
        public_access  = false
      }
    }
    managed_nodegroups {
      name       = "managed-ng-1"
      ami_family = "AmazonLinux2"
      instance_type    = var.instance_type
      desired_capacity = 1
      min_size         = 1
      max_size         = 2
      subnets = [aws_subnet.km-tf-subnet-int-2a.id, aws_subnet.km-tf-subnet-int-2b.id]
      version          = var.k8s_version
      volume_size      = 80
      volume_type      = "gp3"
      volume_iops      = 3000
      volume_throughput = 125
      private_networking = true
    }
  }
}
