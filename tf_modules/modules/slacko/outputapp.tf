
output "mongodb-host" {
  value = aws_instance.mongodb.private_ip
}

output "slackapphost" {
  value = aws_instance.slacko-app.public_ip
}

