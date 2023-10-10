#!/bin/bash

helm list -o json | \
jq -r '.[] | [.name, .revision, .chart, .updated] | @tsv  ' | \
column -t -s$'\t' -N"NAME","REVISION","CHART","UPDATED"
