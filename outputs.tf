# Here we are sending the output to the main.tf file so that they can consume the output
output "dns_name" {
  value = aws_lb.main.name
}

output "listener_arn" {
  value = aws_lb_listener.main.arn
}