pipeline {
     agent any
     triggers {
          pollSCM('* * * * *')
     }
     stages {
          stage("Docker build") {
               steps {
                    sh "docker build -t imarif28/chapter08-exercise2:${BUILD_NUMBER} ."
               }
          }

          stage("Docker push") {
               steps {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                         sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                         sh "docker push imarif28/chapter08-exercise2:${BUILD_NUMBER}"
                    }
               }
          }

          stage("Update version") {
               steps {
                    sh "sed  -i 's/{{VERSION}}/${BUILD_NUMBER}/g' deployment.yaml"
               }
          }
          
          stage("Deploy to staging") {
               steps {
                    withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                         sh "kubectl --context=kind-staging --insecure-skip-tls-verify=true apply -f deployment.yaml"
                    }
               }
          }

          stage("Performance test") {
               steps {
                    withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                         sleep 20
                         sh "chmod +x performance-test.sh && ./performance-test.sh"
                    }
               }
          }
     }
}
