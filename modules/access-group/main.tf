#####################################################
# IAM Access group
# Copyright 2020 IBM
#####################################################

resource "ibm_iam_access_group" "accgroup" {
  count       = var.provision ? 1 : 0
  name        = var.name
  description = var.description
  tags        = var.tags
}

data "ibm_iam_access_group" "accgroupdata" {
  count             = var.provision ? 0 : 1
  access_group_name = var.name
}

resource "ibm_iam_access_group_members" "accgroupmem" {
  access_group_id = var.provision ? ibm_iam_access_group.accgroup[0].id : data.ibm_iam_access_group.accgroupdata[0].groups[0].id
  ibm_ids         = var.ibm_ids
  iam_service_ids = var.service_ids
}

resource "ibm_iam_access_group_policy" "policies" {
  for_each = var.policies

  access_group_id = var.provision ? ibm_iam_access_group.accgroup[0].id : data.ibm_iam_access_group.accgroupdata[0].groups[0].id

  roles              = lookup(each.value, "roles", [])
  tags               = lookup(each.value, "tags", null)
  account_management = lookup(each.value, "account_management", false)

  dynamic "resources" {
    for_each = lookup(each.value, "resources", {})
    content {
      region               = lookup(resources.value, "region", null)
      attributes           = lookup(resources.value, "attributes", null)
      service              = lookup(resources.value, "service", null)
      resource_instance_id = lookup(resources.value, "resource_instance_id", null)
      resource_type        = lookup(resources.value, "resource_type", null)
      resource             = lookup(resources.value, "resource", null)
      resource_group_id    = lookup(resources.value, "resource_group_id", null)
    }
  }

  dynamic "resource_attributes" {
    for_each = lookup(each.value, "resource_attributes", {})
    content {
      name     = resource_attributes.value.name
      value    = resource_attributes.value.value
      operator = lookup(resource_attributes.value, "operator", null) # The provider will set a stringEquals as default if null
    }
  }

}

resource "ibm_iam_access_group_dynamic_rule" "accgroup" {
  access_group_id = var.provision ? ibm_iam_access_group.accgroup[0].id : data.ibm_iam_access_group.accgroupdata[0].groups[0].id

  for_each = var.dynamic_rules

  name              = each.key
  expiration        = each.value["expiration"]
  identity_provider = each.value["identity_provider"]

  dynamic "conditions" {
    for_each = lookup(each.value, "rule_conditions", [])
    content {
      claim    = conditions.value.claim
      operator = conditions.value.operator
      value    = conditions.value.value
    }
  }
}


