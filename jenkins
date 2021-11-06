pipeline{

  stages{

      stage("Maven Build"){

    agent {
        docker{
            image: maven:3.3.9-jdk-8-alpine
        }
    }
  steps{

     script{
     echo " Maven package"
      sh 'mvn package'
      sh "ls -a"
     }

  }

      }
  }

}