
output "instance_id" {
  description = "The ID of the created instance"
  value       = aws_instance.example.id
}
