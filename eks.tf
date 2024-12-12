# IAM Role for Node Group
resource "aws_iam_role" "node_group-iam-profile" {
  name = "eks-node-group-iam-profile"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# attaching IAM 
resource "aws_iam_role_policy_attachment" "node_group_policies" {
  count      = 3
  role       = aws_iam_role.node_group-iam-profile.name
  policy_arn = element([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ], count.index)
}


# eks modules for eks-cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = aws_vpc.eks-cluster-vpc.id
  subnet_ids = aws_subnet.public[*].id

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

# nodegroup for eks-cluster
resource "aws_eks_node_group" "dev-eks-cluster-node-group" {
  cluster_name    = module.eks.cluster_name
  node_group_name = var.node-group_name
  node_role_arn   = aws_iam_role.node_group-iam-profile.arn
  subnet_ids      = aws_subnet.public[*].id

  scaling_config {
    desired_size = var.desired-state
    max_size     = var.maximum-state
    min_size     = var.minimum-state
  }
  
  instance_types = var.instance_types

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
    depends_on = [
    aws_iam_role_policy_attachment.node_group_policies[0],
    aws_iam_role_policy_attachment.node_group_policies[1],
    aws_iam_role_policy_attachment.node_group_policies[2],
  ]
}