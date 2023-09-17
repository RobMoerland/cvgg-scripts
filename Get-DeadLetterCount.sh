#!/usr/bin/env bash

show_help() {
   BASENAME=`basename ${0}`
   cat 1>&2 << EOT
Usage: $BASENAME [options]
Get length of MQ queues. By default those having "failed" in their name.

Options:
  -a, --all          Show length of all queues
  -f, --failed       Show length of "failed" queues

Output:
  server: dns name of the RabbitMQ server
  name: name of the queue
  idle_since: last write time to queue
  len: backing_queue_status.len

Examples:
  $BASENAME
  $BASENAME | jq -c 'select(.len != 0)'
  $BASENAME -a | jq -r 'select(.server | contains("test4"))'
  $BASENAME --failed | jq -r '[.server, .name, .len] | @csv' | tr -d \" | column -t -s ',' -N SERVER,NAME,LEN
EOT
}

# Check parameters
case $1 in
"-a" | "--all")
   filter="Queue"
   ;;

"" | "-f" | "--failed")
   filter="failed"
   ;;

*)
   show_help
   exit
   ;;
esac

# Check required apps
for app in "curl" "jq"
do
   if ! [ -x "$(command -v $app)" ]; then
      echo "Error: $app is not installed." >&2
      exit 1
   fi
done


declare -A servernames=( ["rabbitmq.rivm-cvg-ont.test4.s15m.nl"]="dmFsaWRhdGlvbi11c2VyOmphbnVhcmkyMDIzCg=="
              ["rabbitmq.rivm-cvg-tst.test4.s15m.nl"]="dmFsaWRhdGlvbi11c2VyOmphbnVhcmkyMDIzCg=="
              ["rabbitmq.rivm-cvg-prf.prod4.s15m.nl"]="dmFsaWRhdGlvbi11c2VyOktvdW5lbGkyMDIzCg=="
              ["rabbitmq.rivm-cvg-prd.prod4.s15m.nl"]="dmFsaWRhdGlvbi11c2VyOktvdW5lbGkyMDIzCg==" )

for server in "${!servernames[@]}"
do
   user=`echo ${servernames[$server]} | base64 -d`
   curl --silent --user ${user} https://${server}/api/queues/ | \
   jq -c --arg server $server --arg filter $filter '.[] | select(.name | contains($filter)) | {server: $server, name, len: (.backing_queue_status|.len)}'
done
