pipeline {

	/*	
		Build bootstrap RPM for SFTP instances.
		Once bootstrap is ready, tiggers QA deployment.
	*/
    agent any 
    
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
        	name: 'REGION',
        	defaultValue: 'us-east-1',
        	description: 'usa-sftp')
        string(
        	name: 'CLUSTER',
        	defaultValue: 'c0',
        	description: 'usa-claster')
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
        string(
            name: 'BUILD_NUMBER',
            defaultValue: 'deploy/cfn',
            description: '')
        string(
            name: 'ENVIRONMENT',
            defaultValue: 'nexus/jenkins/job/SftpBuild',
            description: '---')                 
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
                script {
                    sh "printenv"
                    sh "./jenkins/build-bootstrap.sh"
                }
            }

        }    

        stage ('Deploy sftp USA') {
        	
        	agent any

        	steps{
                script{
                    sh "printenv"
                    sh "./jenkins/deploy-sftp.sh"
                }
            }  	
        }
        
        stage ('Deploy sftp EU'){

        	steps{

                script{
                    sh 'export REGION="eu-west-1"'
                    sh 'export CLUSTER="c7"'
                    sh "printenv"
                    sh "./jenkins/deploy-sftp.sh"
                }
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