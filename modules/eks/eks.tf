resource "aws_eks_cluster" "EksCluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.ClusterRole.arn

 vpc_config {
    subnet_ids = concat(var.private_subnet_ids, var.public_subnet_ids)

  }

  depends_on = [aws_iam_role_policy_attachment.EKSClusterPolicy]
}



resource "aws_eks_node_group" "PrivateNodes" {
  cluster_name    = aws_eks_cluster.EksCluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.NodeRole.arn

  subnet_ids = var.private_subnet_ids

  capacity_type  = "ON_DEMAND"
  instance_types = var.instance_type

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }
}
