resource "huaweicloud_obs_bucket" "obs-bucket" {
    bucket = var.obs-name
    acl = "private"
    storage_class = "STANDARD"
}

resource "huaweicloud_rds_instance" "rds-postgresql" {
  name = "rds-postgresql"
  flavor = "rds.pg.n1.large.2" // Use rds.pg.n1.2xlarge.4 8vcpu 32ram
  vpc_id = huaweicloud_vpc.vpc-production.id
  subnet_id = huaweicloud_vpc_subnet.subnet-middlewares.id
  security_group_id = huaweicloud_networking_secgroup.sec-group-postgresql.id
  availability_zone = [var.AZ]
  
  db {
    type = "PostgreSQL"
    version = "15"
    password = var.password
  }

  volume {
    type = "CLOUDSSD"
    size = var.data_disk_size
  }

  backup_strategy {
    start_time = "06:00-07:00" // (UTC) 3am - 4am Brazil time
    keep_days = 7
  }

  maintain_begin = "05:00" // 2am Brazil time
  maintain_end = "07:00" // 4am Brazil time
  time_zone = "UTC-03:00"
}

resource "huaweicloud_dds_instance" "dds-mongodb" {
  name = "dds-mongodb"
  datastore {
    type = "DDS-Community"
    version = "4.4"
    storage_engine = "rocksDB"
  }

  availability_zone = var.AZ
  vpc_id = huaweicloud_vpc.vpc-production.id
  subnet_id = huaweicloud_vpc_subnet.subnet-middlewares.id
  security_group_id = huaweicloud_networking_secgroup.sec-group-mongodb.id
  password = var.password
  mode = "ReplicaSet"

  flavor {
    type = "replica"
    num = "3"
    storage = "ULTRAHIGH"
    size = var.data_disk_size
    spec_code = "dds.mongodb.s6.large.2.repset" // Use 2vcpu 8ram dds.mongodb.s6.large.4.repset
  }

  backup_strategy {
    start_time = "06:00-07:00" // (UTC) 3am - 4am Brazil time
    keep_days = 7
  }

  maintain_begin = "05:00" // 2am Brazil time
  maintain_end = "07:00" // 4am Brazil time
}