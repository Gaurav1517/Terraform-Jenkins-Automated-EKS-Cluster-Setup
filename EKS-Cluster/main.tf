# VPC
# Ref: https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest 
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-vpc"
  cidr = var.vpc_cidr

  azs            = data.aws_availability_zones.azs.names
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets


  enable_dns_hostnames = true
  enable_nat_gateway = true
  single_nat_gateway = true
  
  tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
     "kubernete.io/role/elb" = 1
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
     "kubernete.io/role/internal-elb" = 1
  }
}

# EKS
# Ref: https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.31"

  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets


  eks_managed_node_groups = {
    nodes = {
        min_size = 1
        max_size = 3
        desired_capacity = 2

        instance_types = ["t3.small"]
    }
  }
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
