# Module access-group

This module is used to create an acess group, adding members to access group, defining the acces group policy and adding dynamic rules to access group. Access groups can be used to define a set of permissions that you want to grant to a group of users.

## Example Usage
```
provider "ibm" {
}

module "access_group" {
  // Uncomment following line to point the source to registry level module
  //source = "terraform-ibm-modules/iam/ibm//modules/access-group"

  source = "../../modules/access-group"

  ######### access group ######################
  name        = var.name
  tags        = var.tags
  description = var.description
  provision   = var.provision

  ######### access group members ##############
  ibm_ids     = var.ibm_ids
  service_ids = var.service_ids

  ######### access group policy ###############
  policies = var.policies

  ######### access group dynamic rule #########
  dynamic_rules = var.dynamic_rules
}

```

## NOTE:

If we want to make use of a particular version of module, then set the argument "version" to respective module version.

## Inputs

| Name          | Description                                                      | Type         | Default | Required |
| ------------- | ---------------------------------------------------------------- | :----------- | :------ | :------- |
| name          | A descriptive name used to identify the access group             | string       | n/a     | yes      |
| provision     | Used to decide whether to create a new access group or not       | bool         | true    | no       |
| description   | The description of the access group.                             | string       | n/a     | no       |
| tags          | Tags that should be applied to the service                       | list(string) | n/a     | no       |
| service_ids   | List of service IDS add to  access group.                        | string       | n/a     | no       |
| ibm_ids       | IBM IDs that you want to add to or remove from the access group. | list(string) | n/a     | no       |
| policies      | List of access groupolicies.                                     | list(any)    | n/a     | yes      |
| dynamic_rules | List of dynamic rules to add to access group.                    | list(any)    | n/a     | yes      |


## policies inputs

| Name                | Description                                                    | Type         | Default | Required |
| ------------------- | -------------------------------------------------------------- | :----------- | :------ | :------- |
| roles               | list of roles.                                                 | list(string) | n/a     | yes      |
| tags                | list of tags that you want to add to the access group policy.  | list(string) | n/a     | no       |
| account_management  | Gives access to all account management services if set to true | bool         | false   | no       |
| resources           | A nested block describes the resource of this policy           | list(object) | n/a     | no       |
| resource_attributes | A nested block describes the resource attributes of the policy | list(object) | n/a     | no       |


## resources inputs

| Name                 | Description                                                     | Type        | Default | Required |
| -------------------- | --------------------------------------------------------------- | :---------- | :------ | :------- |
| service              | service name that you want to include in your policy definition | string      | n/a     | no       |
| resource_instance_id | ID of resource instance of the policy definition.               | string      | n/a     | no       |
| region               | Region of the policy definition                                 | string      | n/a     | no       |
| resource_type        | Resource type of the policy definition.                         | string      | n/a     | no       |
| resource             | Resource of the policy definition.                              | string      | n/a     | no       |
| resource_group_id    | ID of the resource group                                        | string      | n/a     | no       |
| attributes           | Set resource attributes in the form of name=value,name=value    | map(string) | n/a     | no       |

## resource_attributes inputs

| Name     | Description               | Type   | Default      | Required |
| -------- | ------------------------- | :----- | :----------- | :------- |
| name     | Name of the Attribute.    | string | n/a          | yes      |
| value    | Value of the Attribute.   | string | n/a          | yes      |
| operator | Operator of the Attribute | string | stringEquals | no       |

## dynamic_rules inputs

| Name              | Description                                                            | Type      | Default | Required |
| ----------------- | ---------------------------------------------------------------------- | :-------- | :------ | :------- |
| name              | Key of a map taken as name of the rule                                 | string    | n/a     | yes      |
| expiration        | The expiration in hours.                                               | number    | n/a     | yes      |
| identity_provider | URI for your identity provider..                                       | string    | n/a     | yes      |
| conditions        | A nested block containes list of conditions that the rule must satisfy | list(map) | n/a     | yes      |

## conditions Inputs

| Name     | Description                                                       | Type   | Default | Required |
| -------- | ----------------------------------------------------------------- | ------ | ------- | -------- |
| claim    | The key value to evaluate the condition against.                  | String | n/a     | yes      |
| operator | The operation to perform on the claim.                            | String | n/a     | yes      |
| value    | Value that the claim is compared by using the conditions.operator | String | n/a     | yes      |

Note: For more information on input varaibles refer https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_access_group_policy


## Outputs

| Name             | Description                                   |
| ---------------- | --------------------------------------------- |
| id               | ID of the access group                        |
| dynamic_rule_ids | List of access group dynamic rule IDs         |
| member_id        | Unique identifier of the access group members |
| policy_ids       | List of access group policy IDs               |

## Usage

To create access group run the following command

  `terraform apply -var-file="input.tfvars"`

Similarly to to remove the access group run the command

   `terraform destroy -var-file="input.tfvars"`

