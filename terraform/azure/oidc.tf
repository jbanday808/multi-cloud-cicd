# Azure Federated Credential placeholders:
#
# GitHub OIDC for Azure requires an Azure AD application or user-assigned
# managed identity, plus a federated identity credential that trusts the GitHub
# repository subject.
#
# This file intentionally does not create Azure identity resources yet. Use
# these placeholders after the Azure identity strategy is finalized.
#
# Placeholder subject format for the main branch:
# repo:OWNER/REPO:ref:refs/heads/main
#
# Placeholder issuer:
# https://token.actions.githubusercontent.com
#
# Placeholder audiences:
# ["api://AzureADTokenExchange"]
#
# Example Terraform shape for a user-assigned managed identity:
#
# resource "azurerm_user_assigned_identity" "github_actions" {
#   name                = "${var.project_name}-github-actions-identity"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#
#   tags = merge(local.default_tags, {
#     Name = "${var.project_name}-github-actions-identity"
#   })
# }
#
# resource "azurerm_federated_identity_credential" "github_actions_main" {
#   name                = "${var.project_name}-github-actions-main"
#   resource_group_name = azurerm_resource_group.main.name
#   parent_id           = azurerm_user_assigned_identity.github_actions.id
#   issuer              = "https://token.actions.githubusercontent.com"
#   subject             = "repo:OWNER/REPO:ref:refs/heads/main"
#   audience            = ["api://AzureADTokenExchange"]
# }
#
# After creating the identity and federated credential, grant the identity only
# the Azure roles required for the workflow, such as ACR push or AKS deployment.
