#!/bin/bash
set -x

N=100

NODE_IP=$(kubectl --context=kind-staging --insecure-skip-tls-verify=true get nodes -o jsonpath='{ $.items[0].status.addresses[?(@.type=="InternalIP")].address }')
NODE_PORT=$(kubectl --context=kind-staging --insecure-skip-tls-verify=true get svc hello -o=jsonpath='{.spec.ports[0].nodePort}')
ENDPOINT="${NODE_IP}:${NODE_PORT}"

echo "Downloading hey..."
wget -q -O hey https://hey-release.s3.us-east-2.amazonaws.com/hey_linux_amd64
chmod +x hey

echo "Running load test with hey..."
./hey -n 1000 -c 50 http://${ENDPOINT}/hello
