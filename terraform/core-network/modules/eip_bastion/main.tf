resource "aws_eip" "bastion_eip" {
    domain = "vpc"

    tags = {
        Name = "bastion-eip"
    }
}