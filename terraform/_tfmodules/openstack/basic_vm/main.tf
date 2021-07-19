resource "openstack_compute_instance_v2" "instance" {
  count = var.counter

  name              = "${var.project}-${count.index}"
  flavor_name       = var.flavor
  image_name        = var.image
  key_pair          = var.pubkey
  availability_zone = var.zone
  security_groups   = var.secgroups

  network {
    name = var.network
  }
}

resource "openstack_networking_floatingip_v2" "fip" {
  count = var.counter

  pool = var.fip_pool
}

resource "openstack_compute_floatingip_associate_v2" "fip_assoc" {
  count = var.counter

  instance_id = element(openstack_compute_instance_v2.instance.*.id, count.index)
  floating_ip = element(openstack_networking_floatingip_v2.fip.*.address, count.index)
}
