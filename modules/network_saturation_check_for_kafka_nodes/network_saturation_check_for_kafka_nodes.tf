resource "shoreline_notebook" "network_saturation_check_for_kafka_nodes" {
  name       = "network_saturation_check_for_kafka_nodes"
  data       = file("${path.module}/data/network_saturation_check_for_kafka_nodes.json")
  depends_on = [shoreline_action.invoke_optimize_network]
}

resource "shoreline_file" "optimize_network" {
  name             = "optimize_network"
  input_file       = "${path.module}/data/optimize_network.sh"
  md5              = filemd5("${path.module}/data/optimize_network.sh")
  description      = "Optimize network configuration: This could involve tuning network settings on the nodes to better handle the traffic or changing the network topology to reduce congestion."
  destination_path = "/tmp/optimize_network.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_optimize_network" {
  name        = "invoke_optimize_network"
  description = "Optimize network configuration: This could involve tuning network settings on the nodes to better handle the traffic or changing the network topology to reduce congestion."
  command     = "`chmod +x /tmp/optimize_network.sh && /tmp/optimize_network.sh`"
  params      = ["NUM_CONNECTIONS","BACKLOG_SIZE","FIN_TIMEOUT","SYN_BACKLOG_SIZE"]
  file_deps   = ["optimize_network"]
  enabled     = true
  depends_on  = [shoreline_file.optimize_network]
}

