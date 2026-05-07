#Key pair(login)
resource "aws_key_pair" "mu_key" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key.pub")
}

#vpc & security group

resource "aws_default_vpc" "default" {

}

resource "aws_security_group" "my_security_group" {
  name        = "automate-sg"
  description = "this will add a TF generated security group"
  vpc_id      = aws_default_vpc.default.id #interpolation

  #inbound rule
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH open"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP open"
  }
  #outbound rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "all access open outbound"
  }
  tags = {
    Name = "automate-sg"
  }
}

#ec2 instance

resource "aws_instance" "my_instace" {
//count =2 ## meta argument
for_each = tomap(
    {
        aws_automate_micrro= "t2.micro",
        aws_automate_medium="t2.medium"
    }
)
  key_name        = aws_key_pair.mu_key.key_name
  security_groups = [aws_security_group.my_security_group.name]
  //instance_type   = var.aws_instance_type
    instance_type   = each.value
  ami             = var.ec2_ami_id #ubuntu
  user_data       = file("install_nginx.sh")

  root_block_device {
    volume_size = var.aws_root_storage_size
    volume_type = "gp3"
  }

  tags = {
   // Name = "Aws-terraform-launch"
    Name = each.key
  }
}

