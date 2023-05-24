output "public_ip" {
    value = aws_instance.webserver.public_ip
}

output "private_key" {
    value     = tls_private_key.mykey.private_key_pem
    sensitive = true
}