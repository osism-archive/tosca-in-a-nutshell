resource "openstack_compute_secgroup_v2" "secgroup" {
  name        = var.project
  description = var.project

  rule {
    from_port   = var.from_port
    to_port     = var.to_port
    ip_protocol = var.ip_protocol
    cidr        = var.cidr
  }
}
