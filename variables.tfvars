access_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXX"

secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXX"

project_id = "XXXXXXXXXXXXXXXXXXXXXXXXXXXX"

vpc_cidr = "10.0.0.0/8"

subnet_1 = {
  cidr = "10.0.0.0/16"
  gateway = "10.0.0.1"
}

subnet_2 = {
  cidr = "10.1.0.0/16"
  gateway = "10.1.0.1"
}

password = "Huawei@1234!123123123"

obs-name = "obs-poc-test"

autoscaler_param = {
  limits_cpu = "1000m"
  limits_mem = "500Mi"
  requests_cpu = "500m"
  requests_mem = "250Mi"
}