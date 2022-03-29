#!/bin/bash

WORKFLOW=$1
REPOSITORY=$2

if [[ -z $WORKFLOW || -z $REPOSITORY ]]; then
  echo "Usage: $0 <workflow> <repository-with-owner>"
  echo "Examples: $0 nlu-runtime-service nuance-internal/ct-platform-nlu-nle"
  echo "          $0 nlu-runtime-service \${github.repository}"
  exit 1
fi

API_QUERY="repos/$REPOSITORY/actions/workflows/.github%2fworkflows%2f$WORKFLOW.yml/runs?per_page=1&branch=main"

RUN_NUMBER=$(gh api $API_QUERY --jq ".workflow_runs[].run_number")
echo "::set-output name=last-run-number::$RUN_NUMBER"