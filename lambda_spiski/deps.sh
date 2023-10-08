#!/usr/bin/env bash

rm -rf delivery/lambda_spiski
mkdir -p delivery/lambda_spiski
cd lambda_spiski || exit 1

cp -rf . ../delivery/lambda_spiski
pip install --target ../delivery/lambda_spiski/ -r requirements.txt
