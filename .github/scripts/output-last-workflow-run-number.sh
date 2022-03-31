#!/bin/bash

WORKFLOW=$1
REPOSITORY=$2
BRANCH=$3

if [[ -z $WORKFLOW || -z $REPOSITORY || -z $BRANCH ]]; then
  echo "Usage: $0 <workflow> <repository-with-owner> <branch>"
  echo "Examples: $0 nlu-runtime-service nuance-internal/ct-platform-nlu-nle main"
  echo "          $0 nlu-runtime-service \${github.repository} main"
  exit 1
fi

API_QUERY="repos/$REPOSITORY/actions/workflows/.github%2fworkflows%2f$WORKFLOW.yml/runs?per_page=1&branch=$BRANCH"

RUN_NUMBER=$(gh api $API_QUERY --jq ".workflow_runs[].run_number")
echo "::set-output name=last-run-number::$RUN_NUMBER"