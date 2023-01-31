# Hoe te gebruiken

## Get-CleanupjobTerminatestatus.sh

Toont de backup cleanup jobs met hun exit status in de huidige namespace.
```
$ ./Get-CleanupjobTerminatestatus.sh 
Name                                    startedAt             finishedAt            exitCode
postgres-backup-cleanup-27915780-ktwvf  2023-01-28T23:00:07Z  2023-01-28T23:00:07Z  0
postgres-backup-cleanup-27917220-dfgl6  2023-01-29T23:00:07Z  2023-01-29T23:00:07Z  0
postgres-backup-cleanup-27918660-tdm9z  2023-01-30T23:00:16Z  2023-01-30T23:00:16Z  0
```

## kubectl-jobs.fmt
Toont de jobs, stijd- stoptijd en exit status
```
$ kgj -o custom-columns-file=kubectl-jobs.fmt       
JOB                                START                  STOP                   SUCCEEDED
cvgg-test                          2023-01-31T12:29:46Z   2023-01-31T13:04:01Z   1
postgres-backup-27915720           2023-01-28T22:00:00Z   2023-01-28T22:00:19Z   1
postgres-backup-27917160           2023-01-29T22:00:00Z   2023-01-29T22:00:54Z   1
postgres-backup-27918600           2023-01-30T22:00:00Z   2023-01-30T22:00:45Z   1
postgres-backup-cleanup-27915780   2023-01-28T23:00:00Z   2023-01-28T23:00:12Z   1
postgres-backup-cleanup-27917220   2023-01-29T23:00:00Z   2023-01-29T23:00:11Z   1
postgres-backup-cleanup-27918660   2023-01-30T23:00:00Z   2023-01-30T23:00:19Z   1
postgres-backup-inspect            2022-07-05T11:18:06Z   2022-07-05T11:18:25Z   1
postgres-backup-list               2022-07-19T12:23:28Z   2022-07-19T12:23:45Z   1
postgres-backup2                   2022-07-05T12:21:41Z   2022-07-05T12:21:54Z   1
```

## pod-nodes.fmt
Toont de pods en hun worker nodes, status en starttijd.
```
$ oc get pods -o custom-columns-file=pod-nodes.fmt
POD                                      NODE                               STATUS      RESTARTS   STARTTIME
cvgg-authorization-975b4467-tb248        test4-gn2-worker-m-xl-gn2b-ffzc5   Running     0          2023-01-17T10:31:26Z
cvgg-database-statefulset-0              test4-gn2-worker-m-xl-gn2a-27ghn   Running     0          2022-11-07T18:30:26Z
cvgg-filedownloads-54cc4cb47b-ktb4c      test4-gn2-worker-m-xl-gn2a-ss28s   Running     19         2023-01-27T14:10:21Z
cvgg-filedownloads-54cc4cb47b-n8bql      test4-gn2-worker-m-xl-gn2b-f7z4v   Running     2          2023-01-27T15:06:32Z
cvgg-fileuploads-84b9784b85-47vb5        test4-gn2-worker-m-xl-gn2a-tt7mw   Running     0          2023-01-31T13:28:58Z
cvgg-fileuploads-84b9784b85-wlwmm        test4-gn2-worker-m-xl-gn2c-bwlkw   Running     0          2023-01-31T13:27:37Z
cvgg-intern-74d66fddb7-q6k5n             test4-gn2-worker-m-xl-gn2a-5nkmt   Running     0          2023-01-23T15:02:47Z
cvgg-messages-84bc5cc479-xn7bw           test4-gn2-worker-m-xl-gn2b-jdbbr   Running     0          2023-01-19T09:20:34Z
cvgg-mock-7b8df5d99f-nt64k               test4-gn2-worker-m-xl-gn2b-hsljr   Running     0          2022-12-16T13:10:15Z
cvgg-rabbitmq-statefulset-0              test4-gn2-worker-m-xl-gn2a-c77rg   Running     0          2022-12-22T15:41:01Z
```
