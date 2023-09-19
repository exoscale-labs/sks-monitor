/*
 * @title   Exoscale Demo
 * @author  Taii Shayma
 * @version 1.0
 */

output "my_sks_cluster_state" {
  value = exoscale_sks_cluster.sks_sh.state
}

