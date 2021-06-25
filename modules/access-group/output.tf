#####################################################
# IAM Access group
# Copyright 2020 IBM
#####################################################

output "id" {
  description = "The ID of the access group"
  value       = var.provision ? ibm_iam_access_group.accgroup[0].id : data.ibm_iam_access_group.accgroupdata[0].groups[0].id
}

output "dynamic_rule_ids" {
  description = "List of access group dynamic rule IDs"
  value = toset([
    for rule in ibm_iam_access_group_dynamic_rule.accgroup : rule.id
  ])
}

output "member_id" {
  description = "The unique identifier of the access group members."
  value       = ibm_iam_access_group_members.accgroupmem.id
}

output "policy_ids" {
  description = "List of access group policy IDs"
  value = toset([
    for policy in merge(ibm_iam_access_group_policy.policy_resource, ibm_iam_access_group_policy.policy_resource_attributes, ibm_iam_access_group_policy.policy_account_management) : policy.id
  ])
}
