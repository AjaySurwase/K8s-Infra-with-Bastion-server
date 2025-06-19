resource "aws_security_group" "bastion_sg" {
  name   = "${var.env}-bastion-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "SSH from allowed IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-bastion-sg"
  }
}

resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "${var.env}-bastion"
  }
}

resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion.id
}
