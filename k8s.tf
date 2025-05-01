resource "huaweicloud_cce_cluster" "k8s-prod" { 
  name = "k8s-prod"
  flavor_id = "cce.s2.small" // Up to 50 nodes, 3 master nodes
  container_network_type = "overlay_l2" // Tunnel Network - VXLAN
  vpc_id = huaweicloud_vpc.vpc-production.id
  subnet_id = huaweicloud_vpc_subnet.subnet-k8s.id
}

data "huaweicloud_cce_addon_template" "autoscaler" {
  cluster_id = huaweicloud_cce_cluster.k8s-prod.id
  name       = "autoscaler"
  version    = "1.29.17"
}

resource "huaweicloud_cce_addon" "auto_scaling" {
  cluster_id = huaweicloud_cce_cluster.k8s-prod.id
  template_name = "autoscaler"
  version = "1.29.17"

 values {
    basic_json = jsonencode(jsondecode(data.huaweicloud_cce_addon_template.autoscaler.spec).basic)
    custom_json = jsonencode(merge(
      jsondecode(data.huaweicloud_cce_addon_template.autoscaler.spec).parameters.custom,
      {
        cluster_id = huaweicloud_cce_cluster.k8s-prod.id
        tenant_id = var.project_id
      }
    ))
    flavor_json = jsonencode( 
    {resources = [{
            "name" : "metrics-server",
            "limitsCpu" : var.autoscaler_param.limits_cpu,
            "limitsMem" : var.autoscaler_param.limits_mem,
            "requestsCpu" : var.autoscaler_param.requests_cpu,
            "requestsMem" : var.autoscaler_param.requests_mem
          }
        ]
      })
    
  }
}


resource "huaweicloud_cce_node_pool" "nodepool-application" {
  name = "nodepool-application"
  cluster_id = huaweicloud_cce_cluster.k8s-prod.id
  os = "Huawei Cloud EulerOS 2.0"
  initial_node_count = 1
  flavor_id = "s6.xlarge.2" // Use s6.2xlarge.2
  availability_zone = var.AZ
  password = var.password
  scall_enable = true
  min_node_count = 1
  max_node_count = 2
  scale_down_cooldown_time = 100
  priority = 1

  root_volume {
    size = var.system_disk_size
    volumetype = "SAS"
  }

  data_volumes {
    size = var.data_disk_size
    volumetype = "SAS"
  }
}

resource "huaweicloud_cce_node_pool" "nodepool-monitoring" {
  name = "nodepool-monitoring"
  cluster_id = huaweicloud_cce_cluster.k8s-prod.id
  os = "Huawei Cloud EulerOS 2.0"
  initial_node_count = 1
  flavor_id = "s6.xlarge.2" // Use s6.2xlarge.2
  availability_zone = var.AZ
  password = var.password
  scall_enable = true
  min_node_count = 1
  max_node_count = 2
  scale_down_cooldown_time = 100
  priority = 1

  root_volume {
    size = var.system_disk_size
    volumetype = "SAS"
  }

  data_volumes {
    size = var.data_disk_size
    volumetype = "SAS"
  }
}