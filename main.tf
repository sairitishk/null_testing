

# Resource to create EC2 instance
resource "aws_instance" "example" {
  ami                         = data.aws_ami.ubuntu.id
  key_name                    = "ritishk2"
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = data.aws_subnet.default_subnet_1a.id
  vpc_security_group_ids      = [aws_security_group.allow_3.id]
#   user_data                   = file("jenkins_user_data.sh")
  tags = {
    Name = "Jenkins-Server"
  }
}
