#!/bin/bash

unset http_proxy
unset https_proxy
unset HTTP_PROXY
unset HTTPS_PROXY

# disable shard allocation
curl -XPUT localhost:9200/_cluster/settings -d '
  {
    "transient": {
      "cluster.routing.allocation.enable": "none"
    }
  }
'
# flush
curl -XPOST localhost:9200/_flush/synced
sleep 2

systemctl restart elasticsearch
sleep 2

# wait for tcp9200
while ! curl localhost:9200
do
    sleep 1
done
sleep 5

# enable shard allocation
curl -XPUT localhost:9200/_cluster/settings -d '
  {
    "transient": {
      "cluster.routing.allocation.enable": "all"
    }
  }
'

while ! curl -s localhost:9200/_cluster/health|jq -r '.status' |grep -q green
do
    sleep 5
done 
