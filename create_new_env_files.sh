#!/usr/bin/env bash

env="${1}"
region="${2}"
root_path="$(PWD)"
path_initial_config="${root_path}/initial-config"
path_environments="${root_path}/environments"

if [ -d "${path_initial_config}/${env}" ] ; then
  echo "${env} environment initial config directory is already present here ${path_initial_config}/${env}"
else
  mkdir "${path_initial_config}/${env}"
  cp "${path_initial_config}/dev/s3-dynamo.tf" "${path_initial_config}/${env}/"
  sed -i -e "s/dev/${env}/g" "${path_initial_config}/${env}/s3-dynamo.tf"
  sed -i -e "s/eu-west-1/${region}/g" "${path_initial_config}/${env}/s3-dynamo.tf"
  rm "${path_initial_config}/${env}/s3-dynamo.tf-e"
fi

if [ -d "${path_environments}/${env}" ] ; then
  echo "${env} environment directory is already present here ${path_environments}/${env}"
else
  mkdir "${path_environments}/${env}"
  cp "${path_environments}/dev/main.tf" "${path_environments}/${env}/"
  cp "${path_environments}/dev/vars.tf" "${path_environments}/${env}/"
  cp "${path_environments}/dev/outputs.tf" "${path_environments}/${env}/"
  sed -i -e "s/dev/${env}/g" "${path_environments}/${env}/main.tf"
  sed -i -e "s/eu-west-1/${region}/g" "${path_environments}/${env}/main.tf"
  rm "${path_environments}/${env}/main.tf-e"
fi
