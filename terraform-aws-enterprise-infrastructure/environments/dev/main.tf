#Root Module Usage

module "security_groups" {

  source = "../../modules/security-groups"

  project_name = "terraform-demo"

  environment = "dev"

  vpc_id = module.vpc.vpc_id

  admin_ip = "YOUR_PUBLIC_IP/32"
}