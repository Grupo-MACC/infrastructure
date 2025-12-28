output "instances_info" {
  description = "Information about the created EC2 instances"
  value = {
    for k, inst in aws_instance.services : k => {
      id = inst.id
      private_ip = inst.private_ip
    }
  }
}