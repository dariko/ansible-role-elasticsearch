#!/bin/bash

unset http_proxy
unset https_proxy
unset HTTP_PROXY
unset HTTPS_PROXY

systemctl restart elasticsearch
sleep 1

while ! curl -s localhost:9200/_cluster/health|jq -r '.status' |grep -q green
do
    sleep 5
done 
