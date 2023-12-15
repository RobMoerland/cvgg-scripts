#!/bin/bash

helm list -o json --kube-as-user rivm-cvg-tab $* | \
jq -r '.[] | [.name, .revision, .chart, .updated] | @tsv  ' | \
column -t -s$'\t' -N"NAME","REVISION","CHART","UPDATED"
