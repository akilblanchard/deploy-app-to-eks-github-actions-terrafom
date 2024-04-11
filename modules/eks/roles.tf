#---------------
#EKS Cluster Role
#---------------
resource "aws_iam_role" "ClusterRole" {
  name = "eks_cluster_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "eks-cluster-role"
  }
}

#Cluster Role Policy Attachment 
//This provies k8s with the permission to manage resources
resource "aws_iam_role_policy_attachment" "EKSClusterPolicy" {
  role       = aws_iam_role.ClusterRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

#---------------
#Node Group Role
#---------------
resource "aws_iam_role" "NodeRole" {
  name = "eks_node_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "node-group-role"
  }
}

#Worker Node Policy Attachment
resource "aws_iam_role_policy_attachment" "NodePolicy"{
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.NodeRole.name
}

//Provides read-only access to ec2 container registry repository
resource "aws_iam_role_policy_attachment" "ContainerRegistryReadOnly"{
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.NodeRole.name
}

//Provides AWS VPC CNI Plugin to modify IP aadress configuration on Worker Nodes
resource "aws_iam_role_policy_attachment" "CniPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.NodeRole.name
}
