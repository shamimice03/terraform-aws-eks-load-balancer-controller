locals {
  // 442472969547
  account_id = data.aws_caller_identity.current.account_id

  // https://oidc.eks.ap-northeast-1.amazonaws.com/id/B7AF2E49EC3KK282KAFAFT55B21CA053
  oidc_provider_url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer

  // idc.eks.ap-northeast-1.amazonaws.com/id/B7AF2E49EC3KK282KAFAFT55B21CA053
  oidc_provider = replace(local.oidc_provider_url, "https://", "")

  // arn:aws:iam::442472969547:oidc-provider/oidc.eks.ap-northeast-1.amazonaws.com/id/B7AF2E49EC3KK282KAFAFT55B21CA053
  oidc_provider_arn = "arn:aws:iam::${local.account_id}:oidc-provider/${local.oidc_provider}"

  policy_arn = var.create_policy ? aws_iam_policy.aws_lbc_policy[0].arn : var.iam_policy_arn

}


output "identity-oidc-arn" {
  value = local.oidc_provider_arn
}

module "irsa" {
  source = "shamimice03/eks-irsa/aws"

  create            = true
  cluster_name      = var.cluster_name
  oidc_provider_arn = local.oidc_provider_arn
  irsa_role_name    = var.irsa_role_name
  iam_policy_arn    = local.policy_arn

  namespace = {
    create_new = var.create_namespace,
    name       = var.namespace
  }
  serviceaccount = {
    create_new = var.create_serviceaccount,
    name       = var.serviceaccount
  }
}



# #     name = "image.repository"
#     value = "602401143452.dkr.ecr.us-east-1.amazonaws.com/amazon/aws-load-balancer-controller" 


######################################################
#  Install AWS Load Balancer Controller using HELM   #
######################################################

locals {
  helm_service_account = false
  helm_namespace       = false

  vpc_id = data.aws_eks_cluster.cluster.vpc_config[0].vpc_id

  # arn:aws:eks:ap-northeast-1:391178969547:cluster/eks-cluster
  region = split(":", data.aws_eks_cluster.cluster.arn)[3]

  values = yamlencode({
    clusterName : var.cluster_name
    serviceAccount : {
      create : local.helm_service_account
      name : var.serviceaccount
    }
    region : local.region
    vpcId : local.vpc_id
  })
}

# The deep_merge_yaml data source accepts a list of YAML strings as input 
# and deep merges into a single YAML string as output.
data "utils_deep_merge_yaml" "values" {
  input = [local.values]
}

# output "check" {
#   value = data.utils_deep_merge_yaml.values.output
# }

resource "helm_release" "aws_loadbalancer_controller" {

  count = var.enable_lbc ? 1 : 0

  name             = coalesce(var.release_name, var.chart_name)
  repository       = var.chart_repo
  chart            = var.chart_name
  #version          = var.chart_version
  create_namespace = local.helm_namespace
  namespace        = var.namespace
  values           = [ data.utils_deep_merge_yaml.values.output ]

  # set {
  #   name  = "serviceAccount.create"
  #   value = local.helm_service_account
  # }

  # set {
  #   name  = "serviceAccount.name"
  #   value = var.serviceAccount
  # }

  # set {
  #   name  = "vpcId"
  #   value = local.vpc_id
  # }  

  # set {
  #   name  = "region"
  #   value = local.region
  # }    

  # set {
  #   name  = "clusterName"
  #   value = var.cluster_name
  # }  


  dynamic "set" {

    for_each = var.set

    content {
      name  = set.value.name
      value = set.value.value
    }

  }

  depends_on = [module.irsa]
}

output "helm_output" {
  value = helm_release.aws_loadbalancer_controller
  sensitive = true
}