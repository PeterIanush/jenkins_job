pipeline {

	/*	
		Build bootstrap RPM for SFTP instances.
		Once bootstrap is ready, tiggers QA deployment.
	*/
    agent none
      parameters {
        string(
            name: 'BOOTSTRAP_NAME',
            defaultValue: 'bv-bootstrap-$GIT_BRANCH-$BUILD_NUMBER',
            description: 'bootstrap_name')
        string(
        	name: 'ACTION',
        	defaultValue: 'update',
        	descrption: 'update')
        string(
        	name: 'STACK_NAME',
        	defaultValue: 'sftp-qa',
        	descrption: 'QA server')
        string(
        	name: 'REGION-US',
        	defaultValue: 'us-east-1',
        	descrption: 'usa-sftp')
        string(
        	name: 'CLUSTER-US',
        	defaultValue: 'c0',
        	descrption: 'usa-claster')
        string(
        	name: 'REGION-EU',
        	defaultValue: 'eu-west-1',
        	descrption: 'europe-sftp')
        string(
        	name: 'CLUSTER-EU',
        	defaultValue: 'c7',
        	descrption: 'europe-claster')
        string(
        	name: 'GIT_BRANCH',
        	defaultValue: 'master',
        	descrption: 'Git branch name')
        string(
        	name: 'RELEASE',
        	defaultValue: '33.0',
        	descrption: 'number of release')
        string(
        	name: 'LABLE',
        	defaultValue: 'deploy/cfn && enviroment/qa && account/bv-nexus-qa',
        	descrption: '')
                  
      }
      options {
        buildDiscarder(logRotator(numToKeepStr: '20'))
        tomeout(time: 1, unit: 'HOURS')
        timestamps{
            echo "$entry.value"
        }
        ansiColor('xterm')
      }
      environment {
          IAM_ROLE_NAME="nexus/jenkins/job/SftpBuild"
      }
  

  stages {

        stage('SCM'){
            steps {
                checkout scm
            }
        }   	
        	
        stage ('Build bootstrap rpm') {
        	
        	agent any 
        	steps {
                sh './jenkins/build-bootstrap.sh RELEASE={params.RELEASE} GIT_BRANCH=${params.GIT_BRANCH} BUILD_NUMBER=${params.BUILD_NUMBER}'
            }
        }
        
        stage ('Deploy sftp USA') {
        	
        	agent any 
        	steps{
                sh './jenkins/deploy-sftp.sh BOOTSTRAP_NAME=${params.BOOTSTRAP_NAME} ACTION=${params.ACTION} REGION=${params.REGION-US} ENVIRONMENT=${env.IAM_ROLE_NAME} STACK_NAME=${params.STACK_NAME} CLUSTER=${params.CLUSTER-US}'
            }
        	
        }
        
        
        stage ('Deploy sftp EU'){
        	
        	agent any 
        	steps{
                sh './jenkins/deploy-sftp.sh BOOTSTRAP_NAME=${params.BOOTSTRAP_NAME} ACTION=${params.ACTION} REGION=${params.REGION-EU} ENVIRONMENT=${env.IAM_ROLE_NAME} STACK_NAME=${params.STACK_NAME} CLUSTER=${params.CLUSTER-EU}'
            }
        }
        

    }  



  post {
            failure {
                    mail subject: "${currentBuild.fullDisplayName} FAILURE",
                    body: "${env.BUILD_URL}",
                    to: 'pyanush@bazaarvoice.com, pyanush@softserveinc.com'
                    }
            success {
                    mail subject: "${currentBuild.fullDisplayName} SUCCESS",
                    body: "${env.BUILD_URL}",
                    to: 'pyanush@bazaarvoice.com, pyanush@softserveinc.com'
                    }
            always {
                    cleanWs()
                   }
        }
}