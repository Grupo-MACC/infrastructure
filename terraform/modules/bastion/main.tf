resource "aws_instance" "bastion" {
    ami                    = var.ami
    instance_type          = var.instance_type
    subnet_id              = var.subnet_id
    vpc_security_group_ids = [var.bastion_sg_id]
    associate_public_ip_address = true
    key_name              = var.key_name

    tags = {
        Name = "bastion"
    }
}