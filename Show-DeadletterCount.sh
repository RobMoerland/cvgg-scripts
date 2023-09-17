#!/usr/bin/env bash

declare -A servernames=( 
   ["rabbitmq.rivm-cvg-ont.test4.s15m.nl"]="dmFsaWRhdGlvbi11c2VyOmphbnVhcmkyMDIzCg==" 
   ["rabbitmq.rivm-cvg-tst.test4.s15m.nl"]="dmFsaWRhdGlvbi11c2VyOmphbnVhcmkyMDIzCg=="
   ["rabbitmq.rivm-cvg-prf.prod4.s15m.nl"]="dmFsaWRhdGlvbi11c2VyOktvdW5lbGkyMDIzCg=="
   ["rabbitmq.rivm-cvg-prd.prod4.s15m.nl"]="dmFsaWRhdGlvbi11c2VyOktvdW5lbGkyMDIzCg=="
)

function GetValues()
{
   for server in "${!servernames[@]}"
   do
      user=`echo ${servernames[$server]} | base64 -d`
      curl --silent --user ${user} https://${server}/api/queues/ | \
      jq -c --arg server $server '.[] | select(.name | contains("failed")) | {server: $server, name, length: (.backing_queue_status|.len)}'
   done
}

function Spaces()
{
   for ((i=0; i < $1 ; i++ ))
   do 
     echo -n " "
   done
}
function ShowSleep()
{
   Spaces $(expr $1 + 1)
   echo -ne ']\r['

   for ((i=0; i < $1 ; i++ ))
   do 
     sleep 1
     echo -n "."
   done
}


GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
NC=$(tput sgr0)

oldvalues=""
oldtime=""

trap "tput cnorm" EXIT
tput clear
tput civis

interval=10

while true
do
   newvalues=$(GetValues)
   newtime=$(date +'%F %T')

   if [ "$oldvalues" != "$newvalues" ]
   then
      tput cup 0 0
      echo $newvalues | \
      jq -r '. | [.server,.name, .length] | @tsv' | \
      column -t -s$'\t' -N SERVER,NAME,LENGTH  | \
      echo -e "$(sed -E -s 's/([^0H])$/\\033[0;31m\1 *\\033[0m/; s/^(SERVER.*)/\\033[7m\1/; s/(LENGTH)$/\1\\033[27m/')"
      echo ""
      Spaces $(expr $interval + 3)
      [[ -z $oldtime ]] && echo -n "${GREEN}start time: $newtime${NC}" || echo -ne "previous: $oldtime ${RED}new: $newtime${NC}" 
      
      oldvalues=$newvalues
      oldtime=$newtime
   fi

   echo -ne '\r'
   ShowSleep $interval
done

