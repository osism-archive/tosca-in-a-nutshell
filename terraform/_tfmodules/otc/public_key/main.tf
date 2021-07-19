data "local_file" "pubkey" {
  filename = pathexpand(var.pubkey_location)
}

resource "openstack_compute_keypair_v2" "keypair" {
  name       = var.project
  public_key = data.local_file.pubkey.content
}
