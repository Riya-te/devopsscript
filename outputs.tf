# output "ec2_public_ip" {
#   value = aws_instance.my_instace.public_ip
# }

# output "ec2_public_dns" {
#   value = aws_instance.my_instace.public_dns
# }

//output for meta parameter

output "ec2_public_ip" {
  value = [
    for key in aws_aws_instance.my_instace : key.public_ip
  ]
}