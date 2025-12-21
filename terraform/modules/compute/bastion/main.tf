resource "aws_instance" "bastion" {
    ami                    = var.ami
    instance_type          = var.instance_type
    subnet_id              = var.subnet_id
    vpc_security_group_ids = [var.bastion_sg_id]
    associate_public_ip_address = false
    key_name              = var.key_name

    tags = {
        Name = "bastion"
    }
}

resource "aws_eip_association" "this" {
  instance_id = aws_instance.bastion.id
  allocation_id = var.eip_allocation_id
  depends_on = [ aws_instance.bastion ]
}