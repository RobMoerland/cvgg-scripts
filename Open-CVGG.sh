#!/usr/bin/env bash

zenity --question \
       --text "Open het Geluidsregister voor gebruik." \
       --title "Centrale Voorziening Geluidgegevens" \
       --width=300 

if [[ $? == 0 ]]
then
   CD_NAMESPACE=rivm-cvg-prd
   sed -i "s/geluidregisterEnabled: .*/geluidregisterEnabled: true/" deployment-${CD_NAMESPACE}.yaml
   cat deployment-${CD_NAMESPACE}.yaml
   kubectl config set-context $(kubectl config current-context) --namespace=${CD_NAMESPACE}
   echo kubectl apply -f ./deployment-${CD_NAMESPACE}.yaml --as rivm-cvg-tab
   # kubectl apply -f ./deployment-${CD_NAMESPACE}.yaml --as rivm-cvg-tab
   echo kubectl rollout restart deployment cvgg-intern --as rivm-cvg-tab
   # kubectl rollout restart deployment cvgg-intern --as rivm-cvg-tab
   echo kubectl rollout restart deployment cvgg-messages --as rivm-cvg-tab
   # kubectl rollout restart deployment cvgg-messages --as rivm-cvg-tab
   echo kubectl rollout restart deployment cvgg-filedownloads --as rivm-cvg-tab
   # kubectl rollout restart deployment cvgg-filedownloads --as rivm-cvg-tab
   echo kubectl rollout restart deployment cvgg-fileuploads --as rivm-cvg-tab
   # kubectl rollout restart deployment cvgg-fileuploads --as rivm-cvg-tab
   kubectl get pods -w
fi
