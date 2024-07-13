resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform_igw"
  }
}
resource "aws_route_table" "terraform_rt" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_igw.id
  }

  tags = {
    Name = "terraform_rt"
  }
}

resource "aws_route_table_association" "public_1_rt" {
  subnet_id      = aws_subnet.public_sub.id
  route_table_id = aws_route_table.terraform_rt.id

}