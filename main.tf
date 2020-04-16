data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}

data "aws_internet_gateway" "selected" {
  internet_gateway_id = "${var.igw_id}"
}



locals {
  cidrs      = cidrsubnets(var.app_cidr, 2, 2, 2, 2)
  priv1_cidr = var.priv1_cidr == "" ? local.cidrs[0] : var.priv1_cidr
  priv2_cidr = var.priv2_cidr == "" ? local.cidrs[1] : var.priv2_cidr
  pub1_cidr  = var.pub1_cidr == "" ? local.cidrs[2] : var.pub1_cidr
  pub2_cidr  = var.pub2_cidr == "" ? local.cidrs[3] : var.pub2_cidr
}


resource "aws_subnet" "priv-1" {
  vpc_id                  = data.aws_vpc.selected.id
  cidr_block              = local.priv1_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false
  tags                    = var.tags
}
resource "aws_subnet" "priv-2" {
  vpc_id                  = data.aws_vpc.selected.id
  cidr_block              = local.priv2_cidr
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false
  tags                    = var.tags
}
resource "aws_subnet" "pub-1" {
  vpc_id                  = data.aws_vpc.selected.id
  cidr_block              = local.pub1_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags                    = var.tags
}
resource "aws_subnet" "pub-2" {
  vpc_id                  = data.aws_vpc.selected.id
  cidr_block              = local.pub2_cidr
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true
  tags                    = var.tags
}

resource "aws_route_table" "nat_gw" {
  vpc_id = data.aws_vpc.selected.id

  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.selected.id
  }
  tags  = var.tags
}

resource "aws_route_table_association" "subnet_1_to_nat_gw" {
  route_table_id = aws_route_table.nat_gw.id
  subnet_id      = aws_subnet.priv-1.id
}
resource "aws_route_table_association" "subnet_2_to_nat_gw" {
  route_table_id = aws_route_table.nat_gw.id
  subnet_id      = aws_subnet.priv-2.id
}