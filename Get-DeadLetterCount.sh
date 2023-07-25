#!/usr/bin/env bash

declare -A servernames=( ["rabbitmq.rivm-cvg-ont.test4.s15m.nl"]="dmFsaWRhdGlvbi11c2VyOmphbnVhcmkyMDIzCg=="
              ["rabbitmq.rivm-cvg-tst.test4.s15m.nl"]="dmFsaWRhdGlvbi11c2VyOmphbnVhcmkyMDIzCg=="
              ["rabbitmq.rivm-cvg-prf.prod4.s15m.nl"]="dmFsaWRhdGlvbi11c2VyOktvdW5lbGkyMDIzCg=="
              ["rabbitmq.rivm-cvg-prd.prod4.s15m.nl"]="dmFsaWRhdGlvbi11c2VyOktvdW5lbGkyMDIzCg==" )
for server in "${!servernames[@]}"
do
   user=`echo ${servernames[$server]} | base64 -d`
   curl --silent --user ${user} https://${server}/api/queues/ | \
   jq -c --arg server $server '.[] | select(.name | contains("failed")) | {server: $server, name, idle_since, len: (.backing_queue_status|.len)}'
done
