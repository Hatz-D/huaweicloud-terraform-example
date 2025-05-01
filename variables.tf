variable "access_key" {
  type= string
  description = "AK"
}

variable "secret_key" {
  type = string
  description = "SK"
}

variable "region" {
  type = string
  default = "sa-brazil-1"
  description = "Region to be used"
}

variable "vpc_cidr" {
  type = string
  description = "VPC CIDR block"
}

variable "subnet_1" {
  type = object({
    cidr = string
    gateway = string
  })
  description = "Subnet 1 CIDR block and gateway"
}

variable "subnet_2" {
  type = object({
    cidr = string
    gateway = string
  })
  description = "Subnet 2 CIDR block and gateway"
}

variable "AZ" {
  type = string
  default = "sa-brazil-1b"
  description = "Availability zone of the ECSs"
}

variable "obs-name" {
  type = string
  description = "Name of the OBS bucket"
}

variable "password" {
  type = string
  description = "Password of the instances"
}

variable "system_disk_size" {
  type = number
  default = 40
  description = "Size of the system disk of instances"
}

variable "data_disk_size" {
  type = number
  default = 100
  description = "Size of the data disk of instances"
}

variable "project_id" {
  type = string
  description = "Project ID of the region being used"
}

variable "autoscaler_param" {
  type = object({
    limits_cpu = string
    limits_mem = string
    requests_cpu = string
    requests_mem = string
  })
}