
pipeline {
   agent any
   environment {
      VERSION = "${env.BUILD_ID}"
   }
   tools {
      // Install the Maven version configured as "M3" and add it to the path.
      maven "M2"
   }

   stages {
      stage('Build') {
         steps {
            // Get some code from a GitHub repository
            git 'https://github.com/praneethreddybilakanti/hello-world-cicd.git'

            // Run Maven on a Unix agent.
            sh "mvn -Dmaven.test.failure.ignore=true clean package"

            // To run Maven on a Windows agent, use
            // bat "mvn -Dmaven.test.failure.ignore=true clean package"
         }

      }
      stage('Static Code Analyis') {
         steps {
            script {
               withSonarQubeEnv(credentialsId: 'sonar_token') {
                  sh "mvn sonar:sonar"

               }
               /*   timeout(time: 1, unit: 'SECONDS') {
                    def qg = waitForQualityGate()
                   
                    if (qg.status != 'OK') {
                        error "Pipeline aborted due to quality gate failure: ${qg.status}"
                    }
                  } */

            }

         }
      }
      stage("docker build") {

         steps {

            script {

               withCredentials([string(credentialsId: 'docker_password', variable: 'docker_password')]) {
                 sh '''
                                sudo docker build -t 34.71.140.43:8083/hello-world-cicd-latest:${VERSION} .
                                sudo docker login -u admin -p $docker_password 34.71.140.43:8083 
                                sudo docker push  34.71.140.43:8083/hello-world-cicd-latest:${VERSION}
                                sudo docker rmi 34.71.140.43:8083/hello-world-cicd-latest:${VERSION}
                            '''
                  }
               }
            }
       }
    stage("Identifing Misconfigs using datree") {
            steps {
               script {
                  dir('helm/') {
                     withEnv(['export DATREE_TOKEN=dG3BGWsFXkVqkjRPZ2sqFR']) {
                        sh "ls "
                        sh 'helm datree test hello-world-cicd/'
                     }

                  }
               }
            }
         }
 stage("pushing the helm charts to nexus") {

         steps {

            script {

               withCredentials([string(credentialsId: 'docker_password', variable: 'docker_password')]) {
               dir('helm/') {
               
               sh '''
                                 helmversion=$( helm show chart  hello-world-cicd | grep version | cut -d: -f 2 | tr -d ' ')
                                 tar -czvf   hello-world-cicd-${helmversion}.tgz  hello-world-cicd/
                                 curl -u admin:$docker_password http://34.71.140.43:8081/repository/helm-hosted/ --upload-file hello-world-cicd-${helmversion}.tgz -v
                            '''
                      }
                  }
               }
            }
       } 
 stage('manual approval'){
            steps{
                script{
                    timeout(10) {
                        mail bcc: '', body: "<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> Go to build url and approve the deployment request <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", to: "praneethreddy8498995302@gmail.com";  
                        input(id: "Deploy Gate", message: "Deploy ${params.project_name}?", ok: 'Deploy')
                    }
                }
            }
        }
       stage("Deploying Helm charts in k8s"){
          steps{
           script{
                withCredentials([kubeconfigFile(credentialsId: 'gke_config', variable: 'gke-cluster')]) {
                   
                    dir('helm/') {
                          sh 'helm upgrade --install --set image.repository="34.71.140.43:8083/hello-world-cicd-latest" --set image.tag="${VERSION}" hello-world-cicd hello-world-cicd/ ' 
                    }
                }

           }

          }

       }
        stage('verifying app deployment'){
            steps{
                script{
                withCredentials([kubeconfigFile(credentialsId: 'gke_config', variable: 'gke-cluster')]) {
                   sh 'kubectl get services'
                         //sh 'kubectl run curl --image=curlimages/curl -i --rm --restart=Never -- curl hello-world-cicd:8080'

                     }
                }
            }
        }
    }
      post {
         always {
            mail bcc: '', body: "<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", to: "praneethreddy8498995302@gmail.com";
         }
      }
   }
