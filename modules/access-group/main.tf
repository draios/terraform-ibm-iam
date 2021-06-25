#####################################################
# IAM Access group
# Copyright 2020 IBM
#####################################################

resource "ibm_iam_access_group" "accgroup" {
  count       = var.provision ? 1 : 0
  name        = var.name
  description = (var.description != null ? var.description : null)
  tags        = (var.tags != null ? var.tags : null)
}

data "ibm_iam_access_group" "accgroupdata" {
  count             = var.provision ? 0 : 1
  access_group_name = var.name
}

resource "ibm_iam_access_group_members" "accgroupmem" {
  access_group_id = var.provision ? ibm_iam_access_group.accgroup[0].id : data.ibm_iam_access_group.accgroupdata[0].groups[0].id
  ibm_ids         = (var.ibm_ids != null ? var.ibm_ids : null)
  iam_service_ids = (var.service_ids != null ? var.service_ids : null)
}

resource "ibm_iam_access_group_policy" "policy" {
  access_group_id = var.provision ? ibm_iam_access_group.accgroup[0].id : data.ibm_iam_access_group.accgroupdata[0].groups[0].id

  for_each = var.policies

  roles              = each.value["roles"]
  account_management = (each.value["account_management"] != null ? each.value["account_management"] : null)
  tags               = (each.value["tags"] != null ? each.value["tags"] : null)

  dynamic "resources" {
    for_each = lookup(each.value["resources"], [])
    content {
      region               = (resources.value.region != null ? resources.value.region : null)
      attributes           = (resources.value.attributes != null ? resources.value.attributes : null)
      service              = (resources.value.service != null ? resources.value.service : null)
      resource_instance_id = (resources.value.resource_instance_id != null ? resources.value.resource_instance_id : null)
      resource_type        = (resources.value.resource_type != null ? resources.value.resource_type : null)
      resource             = (resources.value.resource != null ? resources.value.resource : null)
      resource_group_id    = (resources.value.resource_group_id != null ? resources.value.resource_group_id : null)
    }
  }

  dynamic "resource_attributes" {
    for_each = lookup(each.value, "resource_attributes", [])
    content {
      name     = resource_attributes.value.name
      value    = resource_attributes.value.value
      operator = (resource_attributes.value.operator != null ? resource_attributes.value.operator : null)
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


