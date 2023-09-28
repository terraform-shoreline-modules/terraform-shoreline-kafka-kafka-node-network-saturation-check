resource "shoreline_notebook" "kafka_node_network_saturation_check" {
  name       = "kafka_node_network_saturation_check"
  data       = file("${path.module}/data/kafka_node_network_saturation_check.json")
  depends_on = [shoreline_action.invoke_set_bandwidth_limit]
}

resource "shoreline_file" "set_bandwidth_limit" {
  name             = "set_bandwidth_limit"
  input_file       = "${path.module}/data/set_bandwidth_limit.sh"
  md5              = filemd5("${path.module}/data/set_bandwidth_limit.sh")
  description      = "Increase the network bandwidth of the affected Kafka node to handle the increased traffic."
  destination_path = "/agent/scripts/set_bandwidth_limit.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_set_bandwidth_limit" {
  name        = "invoke_set_bandwidth_limit"
  description = "Increase the network bandwidth of the affected Kafka node to handle the increased traffic."
  command     = "`chmod +x /agent/scripts/set_bandwidth_limit.sh && /agent/scripts/set_bandwidth_limit.sh`"
  params      = ["NEW_BANDWIDTH_LIMIT","INTERFACE_NAME"]
  file_deps   = ["set_bandwidth_limit"]
  enabled     = true
  depends_on  = [shoreline_file.set_bandwidth_limit]
}

