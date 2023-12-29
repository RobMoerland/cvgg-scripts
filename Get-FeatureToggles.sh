#!/usr/bin/env bash

kubectl get cm/cvgg-feature-toggles --as rivm-cvg-tab -o jsonpath="{..data}" $* | jq -r ".[]"
