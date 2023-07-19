variable "create_policy" {
  description = "Determine whether to create a new policy"
  type        = bool
  default     = true
}

variable "enable_lbc" {
  description = "Enable or disable Load Balancer Controller"
  type        = bool
  default     = true
}

variable "policy_name_prefix" {
  description = "Name of the irsa role"
  type        = string
  default     = "aws-lbc-policy"
}

variable "iam_policy_arn" {
  description = "Provide existing policy arn"
  type        = string
  default     = null
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "irsa_role_name" {
  description = "Name of the irsa role"
  type        = string
  default     = ""
}

variable "create_serviceaccount" {
  description = "Determine whether to create a new serviceaccount"
  type        = bool
  default     = true
}

variable "serviceaccount" {
  description = "Provide service account name"
  type        = string
  default     = ""
}

variable "chart_name" {
  type        = string
  default     = "load-balancer-controller"
  description = "Name of the Helm Chart"
}

variable "release_name" {
  type        = string
  default     = "load-balancer-controller"
  description = "Helm Chart release name"
}

variable "chart_version" {
  type        = string
  default     = "2.5.4"
  description = "Helm chart version."
}

variable "chart_repo" {
  type        = string
  default     = "https://aws.github.io/eks-charts"
  description = "Chart repository name."
}

variable "create_namespace" {
  type        = bool
  default     = false
  description = "Whether to create Kubernetes namespace with name defined by `namespace`."
}

variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "Kubernetes namespace to deploy  Helm chart."
}

variable "set" {
  description = "Value block with custom values to be merged with the values yaml"
  type        = any
  default     = []
}

# variable "set_annotations" {
#   description = "Value annotations name where IRSA role ARN created by module will be assigned to the `value`"
#   type        = list(string)
#   default     = []
# }