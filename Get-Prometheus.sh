#!/bin/bash

kubectl config set-context $(kubectl config current-context) --namespace=rivm-cvg-ont

echo "Monitors"
echo "========"
(for servicemonitor in $(kubectl get servicemonitor -o custom-columns=':.metadata.name'); do
   kubectl get servicemonitor $servicemonitor -o custom-columns='MONITOR:.metadata.name,SELECTOR:.spec.selector.matchLabels.app,PATH:.spec.endpoints[0].path,PORT:.spec.endpoints[0].port' --no-headers=true
done) | column -t -N MONITOR,SELECTOR,PATH,PORT
echo ""

echo "Pods"
echo "===="
(for serviceselector in $(kubectl get servicemonitor -o custom-columns=':.spec.selector.matchLabels.app'); do
   for appselector in $(kubectl get service $serviceselector -o custom-columns=':.spec.selector.app'); do
      kubectl get pod -l app=$appselector --no-headers=true
   done
done)  | column -t -N NAME,READY,STATUS,RESTARTS,AGE
echo ""

echo "Ingresses"
echo "========="
(for serviceselector in $(kubectl get servicemonitor -o custom-columns=':.spec.selector.matchLabels.app'); do
  kubectl get ingress -o custom-columns='NAME:.metadata.name,HOST:.spec.rules[0].host,PATH:.spec.rules[0].http.paths[0].path,SERVICE:.spec.rules[0].http.paths[0].backend.service.name,PORT:.spec.rules[0].http.paths[0].backend.service.port.number' | grep $serviceselector
done) | column -t -N NAME,HOST,PATH,SERVICE,PORT
echo ""

echo "Prometheus"
echo "=========="
for serviceselector in $(kubectl get servicemonitor -o custom-columns=':.spec.selector.matchLabels.app'); do
   URL=$(kubectl get ingress -o custom-columns='HOST:.spec.rules[0].host,SERVICE:.spec.rules[0].http.paths[0].backend.service.name' | awk -v service=$serviceselector  '$2==service {print $1}')
   ENDPOINT=$(kubectl get servicemonitor "$serviceselector-monitor" -o jsonpath='{.spec.endpoints[0].path}')
   echo -n "eerste regel ${serviceselector}-monitor: "
   curl -s https://${URL}${ENDPOINT} | awk  'NR==1{print $0}'
done

