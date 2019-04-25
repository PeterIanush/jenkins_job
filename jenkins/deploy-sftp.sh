# Script deploys sftp stack.
# It's meant to be triggered from Jenkins job.
# Expected environment variables: JENKINS_HOME, WORKSPACE, BOOTSTRAP_NAME, ACTION, REGION, ENVIRONMENT, STACK_NAME, CLUSTER.

set -exu

#JENKINS_HOME=$1
#WORKSPACE=$2
#BOOTSTRAP_NAME=$1
#ACTION=$2
#REGION=$3
#ENVIRONMENT=$4
#STACK_NAME=$5
#CLUSTER=$6

echo $JENKINS_HOME >> ./logs/JENKINS_HOME.txt
echo $WORKSPACE >> ./logs/WORKSPACE.txt
echo $BOOTSTRAP_NAME >> ./logs/BOOTSTRAP_NAME.txt
echo $ACTION>> ./logs/ACTION.txt
echo $REGION >> ./logs/REGION.txt
echo $ENVIRONMENT >> ./logs/ENVIRONMENT.txt
echo $STACK_NAME >> ./logs/STACK_NAME.txt
echo $CLUSTER >> ./logs/CLUSTER.txt

