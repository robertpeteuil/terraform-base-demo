# DISPLAY PUBLIC IP ADDRESS
output "instance_ip_address" {
  description = "Instance IP Address"
  value       = "${aws_instance.aws_vm.public_ip}"
}
