data "aws_vpc" "selected" {
    id = var.vpc_id
}

resource "aws_security_group" "bastion_sg" {
    name   = "${var.name}-bastion-sg"
    description = "Security group for SSH access"
    vpc_id      = data.aws_vpc.selected.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = var.allowed_ssh_cidr
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.name}-bastion-sg"
    }
}

resource "aws_security_group" "micro_sg" {
    name = "${var.name}-micro-sg"
    description = "Security group for microservices"
    vpc_id = data.aws_vpc.selected.id

    ingress {
        description = "SSH from bastion"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        security_groups = [aws_security_group.bastion_sg.id]
    }

    ingress {
        description = "VPC internal (all TCP)"
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = var.internal_cidr
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.name}-micro-sg"
    }
}