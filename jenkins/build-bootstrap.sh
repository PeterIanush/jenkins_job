#!/bin/bash
# Script bundles puppet modules and bootstrap scripts into RPM package.
# It's meant to be triggered from Jenkins job.
# Expected environment variables: JENKINS_HOME, WORKSPACE, RELEASE, GIT_BRANCH, BUILD_NUMBER.

set -exu

JENKINS_HOME=$1
WORKSPACE=$2
BOOTSTRAP_NAME=$3
ACTION=$4
REGION=$5
ENVIRONMENT=$6
STACK_NAME=$7
CLUSTER=$8

echo '$JENKINS_HOME' >> ./logs/JENKINS_HOME.txt
echo '$WORKSPACE' >> ./logs/WORKSPACE.txt
echo '$RELEASE' >> ./logs/RELEASE.txt
echo '$GIT_BRANCH' >> ./logs/GIT_BRANCH.txt
echo '$BUILD_NUMBER' >> ./logs/BUILD_NUMBER.txt

