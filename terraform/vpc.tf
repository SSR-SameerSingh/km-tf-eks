resource "aws_vpc" "km-tf-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = "true" #gives you an internal domain name
    enable_dns_hostnames = "true" #gives you an internal host name
    instance_tenancy = "default"

    tags = {
        Name = "km-tf-vpc"
    }
}

resource "aws_subnet" "km-tf-subnet-public-2a" {
    vpc_id = aws_vpc.km-tf-vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "us-west-2a"
    tags = {
        Name = "km-tf-subnet-public-2a"
    }
}

resource "aws_subnet" "km-tf-subnet-public-2b" {
    vpc_id = aws_vpc.km-tf-vpc.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "us-west-2b"
    tags = {
        Name = "km-tf-subnet-public-2b"
    }
}

resource "aws_subnet" "km-tf-subnet-private-2a" {
    vpc_id = aws_vpc.km-tf-vpc.id
    cidr_block = "10.0.3.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-west-2a"
    tags = {
        Name = "km-tf-subnet-private-2a"
    }
}

resource "aws_subnet" "km-tf-subnet-private-2b" {
    vpc_id = aws_vpc.km-tf-vpc.id
    cidr_block = "10.0.4.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-west-2b"
    tags = {
        Name = "km-tf-subnet-private-2b"
    }
}

resource "aws_subnet" "km-tf-subnet-int-2a" {
    vpc_id = aws_vpc.km-tf-vpc.id
    cidr_block = "10.0.5.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-west-2a"
    tags = {
        Name = "km-tf-subnet-int-2a"
    }
}

resource "aws_subnet" "km-tf-subnet-int-2b" {
    vpc_id = aws_vpc.km-tf-vpc.id
    cidr_block = "10.0.6.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-west-2b"
    tags = {
        Name = "km-tf-subnet-int-2b"
    }
}

resource "aws_subnet" "km-tf-subnet-ext-2a" {
    vpc_id = aws_vpc.km-tf-vpc.id
    cidr_block = "10.0.7.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-west-2a"
    tags = {
        Name = "km-tf-subnet-ext-2a"
    }
}

resource "aws_subnet" "km-tf-subnet-ext-2b" {
    vpc_id = aws_vpc.km-tf-vpc.id
    cidr_block = "10.0.8.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-west-2b"
    tags = {
        Name = "km-tf-subnet-ext-2b"
    }
}

resource "aws_internet_gateway" "km-tf-igw" {
    vpc_id = aws_vpc.km-tf-vpc.id
    tags = {
        Name = "km-tf-vpc-igw"
    }
}

resource "aws_route_table" "km-tf-public-rt" {
    vpc_id = aws_vpc.km-tf-vpc.id

    route {
        cidr_block = "0.0.0.0/0"         
        gateway_id = aws_internet_gateway.km-tf-igw.id
    }

    tags = {
        Name = "km-tf-public-rt"
    }
}

resource "aws_route_table_association" "km-tf-rta-public-subnet-2a"{
    subnet_id = aws_subnet.km-tf-subnet-public-2a.id
    route_table_id = "${aws_route_table.km-tf-public-rt.id}"
}

resource "aws_route_table_association" "km-tf-rta-public-subnet-2b"{
    subnet_id = aws_subnet.km-tf-subnet-public-2b.id
    route_table_id = "${aws_route_table.km-tf-public-rt.id}"
}

resource "aws_eip" "nat_gateway" {
  vpc = true
}

resource "aws_nat_gateway" "km_nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id = aws_subnet.km-tf-subnet-public-2a.id
  tags = {
    "Name" = "km-tf-nat-gateway"
  }
}

resource "aws_route_table" "km-tf-private-rt" {
  vpc_id = aws_vpc.km-tf-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.km_nat_gateway.id
  }
}

resource "aws_route_table_association" "km-tf-subnet-private-2a" {
  subnet_id = aws_subnet.km-tf-subnet-private-2a.id
  route_table_id = aws_route_table.km-tf-private-rt.id
}

resource "aws_route_table_association" "km-tf-subnet-private-2b" {
  subnet_id = aws_subnet.km-tf-subnet-private-2b.id
  route_table_id = aws_route_table.km-tf-private-rt.id
}

resource "aws_route_table_association" "km-tf-subnet-int-2a" {
  subnet_id = aws_subnet.km-tf-subnet-int-2a.id
  route_table_id = aws_route_table.km-tf-private-rt.id
}

resource "aws_route_table_association" "km-tf-subnet-int-2b" {
  subnet_id = aws_subnet.km-tf-subnet-int-2b.id
  route_table_id = aws_route_table.km-tf-private-rt.id
}

resource "aws_route_table_association" "km-tf-subnet-ext-2a" {
  subnet_id = aws_subnet.km-tf-subnet-ext-2a.id
  route_table_id = aws_route_table.km-tf-private-rt.id
}

resource "aws_route_table_association" "km-tf-subnet-ext-2b" {
  subnet_id = aws_subnet.km-tf-subnet-ext-2b.id
  route_table_id = aws_route_table.km-tf-private-rt.id
}
