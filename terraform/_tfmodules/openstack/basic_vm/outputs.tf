output "floating_ips" {
  value = openstack_compute_floatingip_associate_v2.fip_assoc.*.floating_ip
}
