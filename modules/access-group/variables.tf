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

# TODO: perform a proper validation of the policies
variable "policies" {
  description = "list of policies"
  type = map(object({
    roles                = list(string),
    account_management   = bool,
    tags                 = list(string),
    resources_attributes = list(any),
    resources            = list(any)
  }))
  # validation {
  #   condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
  #   error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  # }

}

########## access group rule ######################

# TODO: perform a proper validation of the dynamic_rules
variable "dynamic_rules" {
  description = "list of dynamic rules"
  type        = map(any)
}
