/*
 * @title   Exoscale Demo
 * @author  Taii Shayma
 * @version 1.0
 */

resource "exoscale_anti_affinity_group" "afg-sh" {
  name        = "my-anti-affinity-group"
  description = "Prevent compute instances to run on the same host"
}

 resource "exoscale_sks_cluster" "sks_sh" {
  zone = var.zone
  name = "my-sks-cluster"
  description = "my-sks-cluster"
  auto_upgrade = "true"
  exoscale_ccm = "true"
  metrics_server = "true"
  service_level = "pro"
  version = var.sks_version
  labels = var.labels
}

resource "exoscale_sks_kubeconfig" "sks_sh_kubeconfig" {
  cluster_id = exoscale_sks_cluster.sks_sh.id
  zone       = exoscale_sks_cluster.sks_sh.zone

  user   = var.sks_user
  groups = ["system:masters"]
}

resource "exoscale_sks_nodepool" "nodepool_sh" {
  cluster_id         = exoscale_sks_cluster.sks_sh.id
  zone               = exoscale_sks_cluster.sks_sh.zone
  name               = "my-sks-nodepool"
  instance_type      = var.instance_type
  size               = var.np_size
  description = "my-sks-nodepool"
  instance_prefix = var.prefix
  disk_size = var.disk_size
  labels = var.labels
  anti_affinity_group_ids = [exoscale_anti_affinity_group.afg-sh.id]
  security_group_ids = [exoscale_security_group.sg-sh.id]
}

resource "null_resource" "kubeconfig_file" {
  provisioner "local-exec" {
    command = "exo compute sks kubeconfig ${exoscale_sks_cluster.sks_sh.name} ${var.sks_user} -z ${var.zone} --group system:masters > ~/.kube/config"
    interpreter = ["bash", "-c"]
  }
  
  triggers = {
    always_run = "${timestamp()}"
  }
}

# resource "null_resource" "deploy_monitoring_stack" {
#   provisioner "local-exec" {
#     command = "./deploy_monitoring_stack.sh"
#     interpreter = ["bash", "-c"]
#   }
  
#   triggers = {
#     always_run = "${timestamp()}"
#   }
# }