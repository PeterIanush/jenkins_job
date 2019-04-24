# Script deploys sftp stack.
# It's meant to be triggered from Jenkins job.
# Expected environment variables: JENKINS_HOME, WORKSPACE, BOOTSTRAP_NAME, ACTION, REGION, ENVIRONMENT, STACK_NAME, CLUSTER.

set -exu

echo $JENKINS_HOME >> JENKINS_HOME.txt
echo $WORKSPACE >> WORKSPACE.txt
echo $BOOTSTRAP_NAME >> BOOTSTRAP_NAME.txt
echo $ACTION >> ACTION.txt
echo $REGION >> REGION.txt
echo $ENVIRONMENT >> ENVIRONMENT.txt
echo $STACK_NAME >> STACK_NAME.txt
echo $CLUSTER >> CLUSTER.txt

