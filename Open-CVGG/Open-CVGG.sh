#!/usr/bin/env bash

CD_NAMESPACE=rivm-cvg-ont
FILENAME=./deployment-${CD_NAMESPACE}.yaml

if [ $(kubectl auth can-i get pods --namespace ${CD_NAMESPACE}) == "no" ] 
then 
   zenity --error --text="Inloggen op het juiste OpenShift cluster is noodzakelijk."
   exit 1
fi

if [ ! -f ${CONFIGFILE} ]
then
   zenity --error --text="Configuratiebestand \"${FILENAME}\" niet beschikbaar."
   exit 1
fi

zenity --question \
       --title "Centrale Voorziening Geluidgegevens" \
       --text "Stel het Geluidsregister open voor gebruik." \
       --width=300 

if [ $? == 0 ]
then
   sed -i "s/geluidregisterEnabled: .*/geluidregisterEnabled: true/" ${FILENAME}
   sed -i "s/downloadsEnabled: .*/downloadsEnabled: true/" ${FILENAME}
   cat ${FILENAME}
   
   kubectl config set-context $(kubectl config current-context) --namespace=${CD_NAMESPACE}
   
   echo kubectl apply -f ${FILENAME} --as rivm-cvg-tab
   kubectl apply -f ${FILENAME} --as rivm-cvg-tab

   echo kubectl rollout restart deployment cvgg-intern --as rivm-cvg-tab
   kubectl rollout restart deployment cvgg-intern --as rivm-cvg-tab
   echo kubectl rollout restart deployment cvgg-messages --as rivm-cvg-tab
   kubectl rollout restart deployment cvgg-messages --as rivm-cvg-tab
   echo kubectl rollout restart deployment cvgg-filedownloads --as rivm-cvg-tab
   kubectl rollout restart deployment cvgg-filedownloads --as rivm-cvg-tab
   echo kubectl rollout restart deployment cvgg-fileuploads --as rivm-cvg-tab
   kubectl rollout restart deployment cvgg-fileuploads --as rivm-cvg-tab
   kubectl get pods -w --field-selector=status.phase=Running
fi
