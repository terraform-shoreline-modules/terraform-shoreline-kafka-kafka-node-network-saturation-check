
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Kafka node network saturation check.
---

This incident type refers to situations where the network of a Kafka node becomes saturated or overloaded. This can happen due to an increase in traffic or messages being sent to the node, causing the node to slow down or even crash. It is important to monitor and address network saturation issues to ensure the proper functioning of the Kafka cluster and prevent downtime or data loss.

### Parameters
```shell
export KAFKA_NODE_IP="PLACEHOLDER"

export KAFKA_NODE_PID="PLACEHOLDER"

export NETWORK_INTERFACE="PLACEHOLDER"

export ERROR_KEYWORD="PLACEHOLDER"

export INTERFACE_NAME="PLACEHOLDER"

export NEW_BANDWIDTH_LIMIT="PLACEHOLDER"
```

## Debug

### Check the network status of the Kafka node
```shell
sudo netstat -anp | grep ${KAFKA_NODE_IP}
```

### Check the CPU and memory usage of the Kafka node
```shell
sudo top -p ${KAFKA_NODE_PID}
```

### Check the network traffic of the Kafka node
```shell
sudo tcpdump -i ${NETWORK_INTERFACE}
```

### Check the Kafka logs for any errors or warnings related to network saturation
```shell
sudo tail -f /var/log/kafka/kafka.log | grep ${ERROR_KEYWORD}
```

### Check the network bandwidth of the Kafka node
```shell
sudo iftop -n -P -i ${NETWORK_INTERFACE}
```

## Repair

### Increase the network bandwidth of the affected Kafka node to handle the increased traffic.
```shell


#!/bin/bash



# Set the network interface name and bandwidth limit

INTERFACE=${INTERFACE_NAME}

LIMIT=${NEW_BANDWIDTH_LIMIT}



# Check the current bandwidth limit

CURRENT_LIMIT=$(sudo tc qdisc show dev $INTERFACE | awk '{if ($1 == "hfsc") print $6}')



if [ "$CURRENT_LIMIT" == "$LIMIT" ]; then

  echo "Bandwidth limit is already set to $LIMIT"

else

  # Update the bandwidth limit

  sudo tc qdisc replace dev $INTERFACE root handle 1: hfsc default 1

  sudo tc class replace dev $INTERFACE parent 1: classid 1:1 hfsc ls rate $LIMIT ul rate $LIMIT

  echo "Bandwidth limit has been set to $LIMIT"

fi


```