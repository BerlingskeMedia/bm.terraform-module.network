data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_internet_gateway" "selected" {
  internet_gateway_id = var.igw_id
}

data "aws_nat_gateway" "selected" {
  id = var.nat_id
}



locals {
  cidrs      = cidrsubnets(var.app_cidr, 2, 2, 2, 2)
  priv1_cidr = var.priv1_cidr == "" ? local.cidrs[0] : var.priv1_cidr
  priv2_cidr = var.priv2_cidr == "" ? local.cidrs[1] : var.priv2_cidr
  pub1_cidr  = var.pub1_cidr == "" ? local.cidrs[2] : var.pub1_cidr
  pub2_cidr  = var.pub2_cidr == "" ? local.cidrs[3] : var.pub2_cidr
}

module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  namespace  = var.namespace
  name       = var.name
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = var.attributes
  tags       = var.tags
}

resource "aws_subnet" "priv-1" {
  count                   = var.enabled ? 1 : 0
  vpc_id                  = data.aws_vpc.selected.id
  cidr_block              = local.priv1_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false
  tags                    = merge(var.tags, { "Name" = "${module.label.id}-priv-1" })
}
resource "aws_subnet" "priv-2" {
  count                   = var.enabled ? 1 : 0
  vpc_id                  = data.aws_vpc.selected.id
  cidr_block              = local.priv2_cidr
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false
  tags                    = merge(var.tags, { "Name" = "${module.label.id}-piv-2" })
}
resource "aws_subnet" "pub-1" {
  count                   = var.enabled ? 1 : 0
  vpc_id                  = data.aws_vpc.selected.id
  cidr_block              = local.pub1_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, { "Name" = "${module.label.id}-pub-1" })
}
resource "aws_subnet" "pub-2" {
  count                   = var.enabled ? 1 : 0
  vpc_id                  = data.aws_vpc.selected.id
  cidr_block              = local.pub2_cidr
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, { "Name" = "${module.label.id}-pub-2" })
}

resource "aws_route_table" "private_rt" {
  count  = var.enabled ? 1 : 0
  vpc_id = data.aws_vpc.selected.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = data.aws_nat_gateway.selected.id
  }
  tags = merge(var.tags, { "Name" = "${module.label.id}-private" })
}

resource "aws_route_table" "internet_rt" {
  count  = var.enabled ? 1 : 0
  vpc_id = data.aws_vpc.selected.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.selected.id
  }
  tags = merge(var.tags, { "Name" = "${module.label.id}-internet" })
}

resource "aws_route_table_association" "priv_1_to_nat_gw" {
  count          = var.enabled ? 1 : 0
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.priv-1.id
}
resource "aws_route_table_association" "priv_2_to_nat_gw" {
  count          = var.enabled ? 1 : 0
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.priv-2.id
}

resource "aws_route_table_association" "pub_1_to_nat_gw" {
  count          = var.enabled ? 1 : 0
  route_table_id = aws_route_table.internet_rt.id
  subnet_id      = aws_subnet.pub-1.id
}
resource "aws_route_table_association" "pub_2_to_nat_gw" {
  count          = var.enabled ? 1 : 0
  route_table_id = aws_route_table.internet_rt.id
  subnet_id      = aws_subnet.pub-2.id
}
