pipeline {

	/*	
		Build bootstrap RPM for SFTP instances.
		Once bootstrap is ready, tiggers QA deployment.
	*/
    agent any 

    //Envioroment
    environment {
            IAM_ROLE_NAME='nexus/jenkins/job/SftpBuild'
            BOOTSTRAP_NAME='bv-bootstrap-$GIT_BRANCH-$BUILD_NUMBER'
            ACTION='update'
            STACK_NAME='sftp-qa'
            GIT_BRANCH='master'
            RELEASE='33.0'
            LABLE='deploy/cfn && enviroment/qa && account/bv-nexus-qa'
            BUILD_NUMBER='deploy/cfn'

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
       /* string(
        	name: 'REGIONUS',
        	defaultValue: 'us-east-1',
        	description: 'usa-sftp')
        string(
        	name: 'CLUSTERUS',
        	defaultValue: 'c0',
        	description: 'usa-claster')
        string(
        	name: 'REGIONEU',
        	defaultValue: 'eu-west-1',
        	description: 'europe-sftp')
        string(
        	name: 'CLUSTEREU',
        	defaultValue: 'c7',
        	description: 'europe-claster')*/
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
                  
      }
      

  stages {

        stage('SCM'){
            steps {
                checkout scm
            }
        }

        stage ('Export enviroment variables') {
            
            agent any 
            steps {
                script {
                    sh "printenv"
                }
            }

        }   	
        	
        stage ('Build bootstrap rpm') {
        	
        	agent any 

        	steps {
                script {
                    sh "./jenkins/build-bootstrap.sh RELEASE=${params.RELEASE} GIT_BRANCH=${params.GIT_BRANCH} BUILD_NUMBER=${params.BUILD_NUMBER}"
                }
            }

        }
        
    

        stage ('Deploy sftp USA') {
        	
        	agent any
            
            environment {
                REGION="us-east-1"
                CLUSTER="c0"
            }

            step {
                script {
                    sh "printenv"
                }
            }

        	step{
                script{
                    
                    sh "./jenkins/deploy-sftp.sh"
                }
            }  	
        }
        

        
        stage ('Deploy sftp EU'){
        	
            

            environment {
                REGION="eu-west-1"
                CLUSTER="c7"
            }

            steps {
                script {
                    sh "printenv"
                }
            }

        	steps{

                script{

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