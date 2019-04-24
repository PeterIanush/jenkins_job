# Script bundles puppet modules and bootstrap scripts into RPM package.
# It's meant to be triggered from Jenkins job.
# Expected environment variables: JENKINS_HOME, WORKSPACE, RELEASE, GIT_BRANCH, BUILD_NUMBER.

set -exu

echo $JENKINS_HOME >> JENKINS_HOME.txt
echo $WORKSPACE >> WORKSPACE.txt
echo $RELEASE >> RELEASE.txt
echo $GIT_BRANCH >> GIT_BRANCH.txt
echo $BUILD_NUMBER >> BUILD_NUMBER.txt

