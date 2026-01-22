#!/bin/bash
set -e

# Extraer el RDS host desde el estado en S3
aws s3 cp s3://tf-states-grupo2-aimar/compute/dev/terraform.tfstate - | \
  jq -r '.resources[] | select(.module == "module.rds_mysql" and .type == "aws_db_instance" and .name == "this") | .instances[0].attributes.address'