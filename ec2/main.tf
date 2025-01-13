resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = "vpc-0f62c1a36464178cb"

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
    Name = "allow_ssh"
  }
}


resource "aws_instance" "web_server" {
  ami = "ami-0e48a8a6b7dc1d30b" # Amazon Linux 2023 singapore
  instance_type = "t2.micro"
  
  subnet_id                   = "subnet-0f25ae65055ef6ce9"
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true

  key_name = "your-key-pair"  # Change this to your key pair name

  tags = {
    Name = "Test"
  }
}

output "public_ip" {
  value = aws_instance.web_server.public_ip
}