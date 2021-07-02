#####################################################
# IAM Access group
# Copyright 2020 IBM
#####################################################

########### access group ############################

variable "name" {
  description = "Name of the access group"
  type        = string
}

variable "provision" {
  type        = bool
  description = "Would you like to provision a new access group (true/false)"
  default     = true
}

variable "description" {
  description = "Description to access group"
  type        = string
  default     = null
}

variable "tags" {
  type        = list(string)
  description = "Tags that should be applied to the service"
  default     = []
}

########## access group memebers ######################

variable "ibm_ids" {
  description = "A list of IBM IDs that you want to add to the access group."
  type        = list(string)
  default     = []
}

variable "service_ids" {
  type        = list(string)
  description = "A list of service IDS that you want to add to the access group."
  default     = []
}

########## access group policy ######################

# TODO: this fight is for another day

# variable "policies" {
#   description = "list of policies"
#   type = map(object({
#     roles              = list(string)
#     tags               = list(string)
#     account_management = bool
#     resources = list(object({
#       service              = string
#       resource_instance_id = string
#       region               = string
#       resource_type        = string
#       resource             = string
#       resource_group_id    = string
#       attributes           = map(string)
#     })),
#     resource_attributes = list(object({
#       name     = string
#       value    = string
#       operator = string
#     }))
#   }))
#   validation {
#     condition     = length([for policy in var.policies : policy if policy.account_management == true && (length(policy.resource_attributes) > 0 || length(policy.resources) > 0)]) == 0
#     error_message = "You can't specify account_management as true with a list of resources or resource_attributes."
#   }
#   validation {
#     condition     = length([for policy in var.policies : policy if(length(policy.resource_attributes) > 0) && (length(policy.resources) > 0)]) == 0
#     error_message = "You can't specify both a list of resources and a list of resource_attributes."
#   }
# }

variable "policies" {
  description = "list of policies"
  type        = map(any)
}

########## access group rule ######################

# TODO: perform a proper validation of the dynamic_rules
variable "dynamic_rules" {
  description = "list of dynamic rules"
  type        = map(any)
}
