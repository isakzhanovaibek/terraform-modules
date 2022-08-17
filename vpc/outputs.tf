output "public_subnet_a" {
  value = aws_subnet.public_subnet_a.id
}

output "public_subnet_b" {
  value = aws_subnet.public_subnet_b.id
}

output "private_subnet_a" {
  value = aws_subnet.private_subnet_a.id
}

output "private_subnet_b" {
  value = aws_subnet.private_subnet_b.id
}

output "vpc_id" {
  value = aws_vpc.main
}

output "public_subnet_ids" {
  value = [aws_subnet.public_subnet_a.id, 
           aws_subnet.public_subnet_b.id
  ]
}

output "private_subnet_ids" {
  value = [aws_subnet.private_subnet_a.id, 
           aws_subnet.private_subnet_b.id
  ]
}