variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}


# variable for subnet for eks-cluster
variable "subnet_cidr_blocks" {
  description = "List of subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# variable for cluster name
variable "cluster_name" {
    description = "name of the eks cluster"
    type = string
    default = "dev-eks-cluster"
}

# variable for cluster name
variable "cluster_version" {
    description = "version of the eks cluster"
    type = string
    default = "1.31"
}

variable "node-group_name" {
  description = "name of the eks node group name"
  type = string
  default = "dev-eks-cluster-node-group"
  
}

variable "desired-state" {
  description = "no. of desired state"
  type = number
  default = 1
  
}

variable "maximum-state" {
  description = "no. of maximum state"
  type = number
  default = 2
  
}
variable "minimum-state" {
  description = "no. of minimum state"
  type = number
  default = 1
  
}

variable "instance_types" {
  description = "type of node instances"
  type = list(string)
  default = ["t2.large"]
  
}
