#!/bin/bash
# Haalt uit de huidige namespace de logging van de database-cleanup jobs


for pod in `oc get pod | awk '/cleanup/{print $1}'`
do
   echo "[$pod]"
   kubectl logs $pod
done
