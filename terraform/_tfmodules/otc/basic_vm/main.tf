data "openstack_images_image_v2" "image" {
  name        = var.image
  most_recent = true
}

resource "openstack_compute_instance_v2" "instance" {
  count = var.counter

  name              = "${var.project}-${count.index}"
  flavor_name       = var.flavor
  image_name        = data.openstack_images_image_v2.image.id
  key_pair          = var.pubkey
  availability_zone = var.zone
  security_groups   = var.secgroups

  network {
    uuid = var.network
  }

  block_device {
    boot_index            = 0
    delete_on_termination = true
    destination_type      = "volume"
    volume_size           = var.disk_size
    source_type           = "image"
    uuid                  = data.openstack_images_image_v2.image.id
  }
}

resource "openstack_networking_floatingip_v2" "fip" {
  count = var.counter

  pool = var.fip_pool
}

resource "opentelekomcloud_compute_floatingip_associate_v2" "fip_assoc" {
  count = var.counter

  instance_id = element(openstack_compute_instance_v2.instance.*.id, count.index)
  floating_ip = element(openstack_networking_floatingip_v2.fip.*.address, count.index)
}
