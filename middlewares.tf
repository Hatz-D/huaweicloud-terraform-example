resource "huaweicloud_dms_rabbitmq_instance" "rabbitmq" {
  name = "rabbitmq"
  flavor_id = "rabbitmq.2u4g.single" // Use 8vcpu 16ram rabbitmq.8u16g.single
  storage_space = var.data_disk_size
  engine_version = "3.8.35"
  storage_spec_code = "dms.physical.storage.high.v2"

  vpc_id = huaweicloud_vpc.vpc-production.id
  network_id = huaweicloud_vpc_subnet.subnet-middlewares.id
  security_group_id = huaweicloud_networking_secgroup.sec-group-rabbitmq.id
  availability_zones = [var.AZ]

  access_user = "root"
  password = var.password

  maintain_begin = "06:00" // 3am Brazil time
  maintain_end = "10:00" // 7am Brazil time
}

resource "huaweicloud_dcs_instance" "redis" {
  name = "redis"
  engine = "Redis"
  engine_version = "6.0"
  capacity = "1" // Use 16
  flavor = "redis.single.xu1.large.1"  // Use 16 ram redis.single.xu1.large.16 
  availability_zones = [var.AZ]
  password = var.password
  vpc_id = huaweicloud_vpc.vpc-production.id
  subnet_id = huaweicloud_vpc_subnet.subnet-middlewares.id
  maintain_begin = "06:00" // 3am Brazil time
  maintain_end = "07:00" // 4am Brazil time
}