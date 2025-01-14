resource "aws_security_group" "allow_ssh" {
  name        = "terraform_aws_gh_actions_allow_ssh_sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = "vpc-04665586b4510c781" # singapore main vpc

  ingress {
    description = "SSH from my ip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["49.150.110.197/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform_aws_gh_actions_allow_ssh_sg_tag"
  }
}

# resource "aws_instance" "web_server" {
#   ami           = "ami-0e48a8a6b7dc1d30b" # Amazon Linux 2023 singapore
#   instance_type = "t2.micro"

#   subnet_id                   = "subnet-03ad19ec08051cf51" # Az a
#   vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
#   associate_public_ip_address = true

#   tags = {
#     Name = "Test"
#   }
# }

# output "public_ip" {
#   value = aws_instance.web_server.public_ip
# }