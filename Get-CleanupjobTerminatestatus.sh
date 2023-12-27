#!/bin/bash
# Haalt uit de huidige namespace de start-, stoptijd en exitCode van de database-cleanup jobs

printf 'Name                                    startedAt             finishedAt            exitCode\n'

for pod in `oc get pod | awk '/cleanup/{print $1}'`
do
   oc get pod $pod -o jsonpath='{.metadata.name}{"  "}{range .status.containerStatuses[*]}{.state.terminated.startedAt}{"  "}{.state.terminated.finishedAt}{"  "}{.state.terminated.exitCode}{"\n"}{end}' 
done
