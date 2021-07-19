module "publickey" {
  source = "./_tfmodules/openstack/public_key"

  project = var.project
}

module "secgroup_yorc" {
  source = "./_tfmodules/openstack/security_group"

  project   = "${var.project}-ssh"
  from_port = 22
  to_port   = 22
}

module "secgroup_consul" {
  source = "./_tfmodules/openstack/security_group"

  project   = "${var.project}-web"
  from_port = 5600
  to_port   = 5600
}

module "yorc" {
  source = "./_tfmodules/openstack/basic_vm"

  project   = "${var.project}-controller"
  pubkey    = module.publickey.public_key
  secgroups = [
    module.secgroup_yorc.secgroup,
    module.secgroup_consul.secgroup
  ]
  flavor    = "4C-4GB-10GB"
  image     = "Ubuntu 20.04"
  fip_pool  = "external"
  network   = "net-to-external-testbed"
}
