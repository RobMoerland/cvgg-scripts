#!/bin/bash

kubectl get pods --field-selector=status.phase=Running $*
