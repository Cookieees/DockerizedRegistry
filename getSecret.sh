#!/bin/bash
#b4b37df04b840ec7
read -p "Input the acces token, and press Enter: [b4b37df04b840ec7]" access_token
access_token=${access_token:-'b4b37df04b840ec7'}
read -p "Remove container and their volumes after work? [y/n]: " removeTrigger
removeTrigger=${removeTrigger:-'y'}
problemURL="https://hackattic.com/challenges/dockerized_solutions/problem?access_token=${access_token}"
mkdir -p tmp
echo $problemURL > ./tmp/problem.url
touch ./.env
echo '' > ./.env
containerName="registry"

# Installing dependencies: curl and jq
sudo apt-get update -y && sudo apt-get install jq -y && sudo apt-get install curl -y

# Requesting JSON with parameters
echo 'Requesting a JSON ...'
response=$(curl -s $problemURL)
echo $response > ./tmp/response.json

# Setup vars from response JSON
username=$(echo ${response} | jq '.credentials.user')
password=$(echo ${response} | jq '.credentials.password')
ignition_key=$(echo ${response} | jq '.ignition_key')
echo "IGNITION_KEY=${ignition_key}" > ./.env
echo "containerName=${containerName}" >> ./.env
registry_host='registry.rtfm.in'
trigger_token=$(echo ${response} | jq '.trigger_token')
requestedURL="https://hackattic.com/_/push/${trigger_token}"


# Setup httpd credentials
echo 'Setup httpd credentials ...'
mkdir -p auth
docker run --rm --entrypoint htpasswd httpd:2 -Bbn $username $password > auth/htpasswd

# Setup envs for docker-compose
echo 'Starting docker-compose with Docker Registry ...'
docker compose up -d

# Creating JSON payload to achive the secret
json_payload=$(jq -n \
  --arg registry_host "${registry_host}" \
  '$ARGS.named')

until [ "`docker inspect -f {{.State.Running}} ${containerName}`"=="true" ] 
do
    sleep 0.1
done

echo 'Extraction of the secret...'
secret=$(curl -s \
    -H 'Content-Type: application/json'\
    -d '${json_payload}' ${requestedURL}) | \
        jq '.secret' && secret='Bad response from solving server'

echo "secret=${secret}" >> ./.env
echo "Your secret is: ${secret}"

# Delete temporary (debug) data
rm -rf ./tmp

# Stop and remove container after work
if [[ $removeTrigger -eq "y" ]] || [[ $removeTrigger -eq "yes" ]]
then
  docker container stop ${containerName} && docker container rm -v ${containerName}
fi