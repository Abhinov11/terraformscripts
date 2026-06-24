resource "aws_ec2_client_vpn_endpoint" "this" {

  description = var.description

  server_certificate_arn = var.server_certificate_arn

  client_cidr_block = var.client_cidr

  authentication_options {

    type = "certificate-authentication"

    root_certificate_chain_arn = var.root_certificate_arn
  }

  connection_log_options {
    enabled = false
  }
}