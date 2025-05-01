resource "huaweicloud_vpc" "vpc-production" {
  name = "vpc-production"
  cidr = var.vpc_cidr
}

resource "huaweicloud_vpc_subnet" "subnet-k8s" {
  name = "subnet-k8s"
  cidr = var.subnet_1.cidr
  vpc_id = huaweicloud_vpc.vpc-production.id
  gateway_ip = var.subnet_1.gateway
}

resource "huaweicloud_vpc_subnet" "subnet-middlewares" {
  name = "subnet-middlewares"
  cidr = var.subnet_2.cidr
  vpc_id = huaweicloud_vpc.vpc-production.id
  gateway_ip = var.subnet_2.gateway
}

resource "huaweicloud_networking_secgroup" "sec-group-postgresql" {
  name = "sec-group-postgresql"
}

resource "huaweicloud_networking_secgroup" "sec-group-rabbitmq" {
  name = "sec-group-rabbitmq"
}

resource "huaweicloud_networking_secgroup" "sec-group-mongodb" {
  name = "sec-group-mongodb"
}

resource "huaweicloud_vpc_eip" "nat-gateway-eip" {
  publicip {
    type = "5_bgp"
  }
    bandwidth{
      share_type = "PER"
      name = "nat-gateway-eip"
      size = 300
      charge_mode = "traffic"
    }
}

resource "huaweicloud_nat_gateway" "nat-gateway-poc" {
  name = "nat-gateway-poc"
  vpc_id = huaweicloud_vpc.vpc-production.id
  subnet_id = huaweicloud_vpc_subnet.subnet-k8s.id
  spec = "1" // Small, up to 10.000 connections
}

resource "huaweicloud_nat_snat_rule" "snat-rule-k8s" {
  nat_gateway_id = huaweicloud_nat_gateway.nat-gateway-poc.id
  floating_ip_id = huaweicloud_vpc_eip.nat-gateway-eip.id
  subnet_id = huaweicloud_vpc_subnet.subnet-k8s.id
}

resource "huaweicloud_nat_snat_rule" "snat-rule-middleware" {
  nat_gateway_id = huaweicloud_nat_gateway.nat-gateway-poc.id
  floating_ip_id = huaweicloud_vpc_eip.nat-gateway-eip.id
  subnet_id = huaweicloud_vpc_subnet.subnet-middlewares.id
}