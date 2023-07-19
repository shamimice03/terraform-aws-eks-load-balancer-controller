### LoadBalancer Policy
- https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

### Image registries
- https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html

### AWS Load Balancer Chart 
- https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller
- https://github.com/aws/eks-charts/tree/master/stable/aws-load-balancer-controller


cluster_name      = "eks-cluster"
irsa_role_name    = "ClusterAutoscalerIRSA"
role_policies     = {
   arn1
}
create_namespace  = false
namespace         = "kube-system"
serviceaccount    = "cluster-autoscaler-sa"
chart_repo        = "https://kubernetes.github.io/autoscaler"
chart_name        = "cluster-autoscaler"
release_name      = "cluster-autoscaler"
chart_version     = "9.29.1"

set = [
  {
    name  = "autoDiscovery.clusterName"
    value = "eks-cluster"
  },
  {
    name  = "awsRegion"
    value = "ap-northeast-1"
  },
  {
    name  = "rbac.serviceAccount.name"
    value = "cluster-autoscaler-sa"
  }
]


### create policy

```hcl
cluster_name   = "eks-cluster"
irsa_role_name = "AWSLoadBalancerControllerRole"
create_policy  = true

# iam_policy_arn    = "arn:aws:iam::391178969547:policy/AWS-LoadBalancer-Controller-Policy" 

namespace = {
  create_new = false,
  name       = "kube-system"
}

serviceaccount = {
  create_new = true,
  name       = "aws-lb-controller-sa"
}

```

### provide existing policy arn
```hcl
cluster_name   = "eks-cluster"
irsa_role_name = "AWSLoadBalancerControllerRole"
create_policy  = false

# Provide policy arn of aws managed or manually create policy for aws load balancer controller
iam_policy_arn    = "arn:aws:iam::391178969547:policy/AWS-LoadBalancer-Controller-Policy" 

namespace = {
  create_new = false,
  name       = "kube-system"
}

serviceaccount = {
  create_new = true,
  name       = "aws-lb-controller-sa"
}

```

```
with_deep_merge_yaml = {
  "append_list" = false
  "deep_copy_list" = false
  "id" = "09f4588d17b25f1300f8f38de43654e2742c0c5d"
  "input" = tolist([
    <<-EOT
    "clusterName": "eks-cluster"
    "region": "ap-northeast-1"
    "serviceAccount":
      "create": false
      "name": "cluster-autoscaler-sa"
    "vpcId": "vpc-0925410d256a3ab11"
    
    EOT,
  ])
  "output" = <<-EOT
  clusterName: eks-cluster
  region: ap-northeast-1
  serviceAccount:
    create: false
    name: cluster-autoscaler-sa
  vpcId: vpc-0925410d256a3ab11
  
  EOT
}

without_deep_merge_yaml = <<EOT
"clusterName": "eks-cluster"
"region": "ap-northeast-1"
"serviceAccount":
  "create": false
  "name": "cluster-autoscaler-sa"
"vpcId": "vpc-0925410d256a3ab11"

EOT
```

### Last time: success
```
cluster_name   = "eks-cluster"
irsa_role_name = "AWSLoadBalancerControllerRole"
create_policy  = true
policy_name    = "aws-lbc-policy"

# Provide policy arn of aws managed or manually create policy for aws load balancer controller
# iam_policy_arn    = "arn:aws:iam::391178969547:policy/AWS-LoadBalancer-Controller-Policy" 

create_namespace = false
namespace        = "kube-system"
serviceaccount   = "cluster-autoscaler-sa"

chart_repo    = "https://aws.github.io/eks-charts"
chart_name    = "aws-load-balancer-controller"
release_name  = "aws-load-balancer-controller"
chart_version = "1.5.5"

```