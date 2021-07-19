output "floating_ips" {
  value = opentelekomcloud_compute_floatingip_associate_v2.fip_assoc.*.floating_ip
}
