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

resource "aws_security_group" "rds_sg" {
    name   = "${var.name}-rds-sg"
    description = "Security group for RDS access"
    vpc_id      = data.aws_vpc.selected.id

    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        security_groups = [aws_security_group.micro_sg.id, aws_security_group.bastion_sg.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.name}-rds-sg"
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
        description     = "Traffic from internal ALB"
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        security_groups = [aws_security_group.load_balancer_sg.id]
    }

    ingress {
        description     = "Traffic from internal ALB"
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        security_groups = [aws_security_group.external_load_balancer_sg.id]
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

resource "aws_security_group" "external_load_balancer_sg" {
  name        = "${var.name}-external-alb-sg"
  description = "Security group for external ALB"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "load_balancer_sg" {
  name        = "${var.name}-alb-sg"
  description = "Security group for internal ALB"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-alb-sg"
  }
}

resource "aws_security_group" "api_gateway_vpc_link_sg" {
  name        = "${var.name}-api-gateway-vpc-link-sg"
  description = "Security group for API Gateway VPC Link"
  vpc_id      = data.aws_vpc.selected.id

  tags = {
    Name = "${var.name}-api-gateway-vpc-link-sg"
  }
}

resource "aws_security_group_rule" "api_gw_to_alb" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"

  security_group_id        = aws_security_group.api_gateway_vpc_link_sg.id
  source_security_group_id = aws_security_group.load_balancer_sg.id

  description = "API Gateway VPC Link to ALB"
}

resource "aws_security_group_rule" "alb_from_api_gw" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"

  security_group_id        = aws_security_group.load_balancer_sg.id
  source_security_group_id = aws_security_group.api_gateway_vpc_link_sg.id

  description = "ALB from API Gateway VPC Link"
}
