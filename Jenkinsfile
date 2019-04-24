pipeline {

	/*	
		Build bootstrap RPM for SFTP instances.
		Once bootstrap is ready, tiggers QA deployment.
	*/
    agent any 

    //Envioroment
    environment {
            IAM_ROLE_NAME="nexus/jenkins/job/SftpBuild"
    }

    //Options
    options {
        buildDiscarder(logRotator(numToKeepStr: '20'))
        timestamps()
        timeout(time: 1, unit: 'HOURS')
        //ansiColor('xterm')           
    }

    //Parameters
      parameters {
        string(
            name: 'BOOTSTRAP_NAME',
            defaultValue: 'bv-bootstrap-$GIT_BRANCH-$BUILD_NUMBER',
            description: 'bootstrap_name')
        string(
        	name: 'ACTION',
        	defaultValue: 'update',
        	description: 'update')
        string(
        	name: 'STACK_NAME',
        	defaultValue: 'sftp-qa',
        	description: 'QA server')
        string(
        	name: 'REGION-US',
        	defaultValue: 'us-east-1',
        	description: 'usa-sftp')
        string(
        	name: 'CLUSTER-US',
        	defaultValue: 'c0',
        	description: 'usa-claster')
        string(
        	name: 'REGION-EU',
        	defaultValue: 'eu-west-1',
        	description: 'europe-sftp')
        string(
        	name: 'CLUSTER-EU',
        	defaultValue: 'c7',
        	description: 'europe-claster')
        string(
        	name: 'GIT_BRANCH',
        	defaultValue: 'master',
        	description: 'Git branch name')
        string(
        	name: 'RELEASE',
        	defaultValue: '33.0',
        	description: 'number of release')
        string(
        	name: 'LABLE',
        	defaultValue: 'deploy/cfn && enviroment/qa && account/bv-nexus-qa',
        	description: '')
                  
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
                sh "./jenkins/build-bootstrap.sh RELEASE=${params.RELEASE} GIT_BRANCH=${params.GIT_BRANCH} BUILD_NUMBER=${params.BUILD_NUMBER}"
            }
        }
        
        stage ('Deploy sftp USA') {
        	
        	agent any 
        	steps{
                sh "./jenkins/deploy-sftp.sh BOOTSTRAP_NAME=${params.BOOTSTRAP_NAME} ACTION=${params.ACTION} REGION=${params.REGION-US} ENVIRONMENT=${env.IAM_ROLE_NAME} STACK_NAME=${params.STACK_NAME} CLUSTER=${params.CLUSTER-US}"
            }
        	
        }
        
        
        stage ('Deploy sftp EU'){
        	
        	agent any 
        	steps{
                sh "./jenkins/deploy-sftp.sh BOOTSTRAP_NAME=${params.BOOTSTRAP_NAME} ACTION=${params.ACTION} REGION=${params.REGION-EU} ENVIRONMENT=${env.IAM_ROLE_NAME} STACK_NAME=${params.STACK_NAME} CLUSTER=${params.CLUSTER-EU}"
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