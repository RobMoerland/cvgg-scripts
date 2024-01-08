#!/usr/bin/env bash

Usage() {
   BASENAME=`basename ${0}`
   cat 1>&2 << EOT
Usage: $BASENAME [options]
Verwijdert ReplicaSets die niet meer worden gebruikt. Per default blijven 3 oude versie bewaard in OpenShift.

Options:
  -n, --namespace    Gebruik een andere dan de huidige namespace
  -k, --keep         Het aantal te bewaren ReplicaSets

Examples:
  $BASENAME
  $BASENAME -n rivm-cvg-ont
  $BASENAME --keep 2
EOT
}

NAMESPACE=$(kubectl config current-context | awk -F '/' '{print $1}')
KEEP=3
# Check parameters
while [ "$#" -gt 0 ]
do
  case "${1}" in
    (-n | --namespace)
      NAMESPACE=${2}
      shift 2
      ;;

    (-k | --keep)
      KEEP=${2}
      shift 2
      ;;
    (-h | --help)
      Usage
      exit 0
      ;;
    *)
      echo -e "Invalid option: ${1}\n"
      Usage
      exit 1
      ;;
  esac
done

if [ -z "${NAMESPACE}" ] || [ -z "${KEEP}" ]; then
    Usage
    exit 1
fi

GREEN="\e[32m"
RED="\e[41m"
ENDCOLOR="\e[0m"

for label in $(kubectl get deployment -o jsonpath="{.items[*].spec.selector.matchLabels.app}")
do
  echo -e "[$GREEN$label$ENDCOLOR]"
  for replicaset in $(kubectl get replicaset --namespace $NAMESPACE --selector app=$label -o=jsonpath='{range .items[?(@.spec.replicas==0)]}{.metadata.name}{"\n"}{end}' | head -n -$KEEP)
  do 
    bash -c "kubectl delete replicaset $replicaset --namespace $NAMESPACE"
  done
done
