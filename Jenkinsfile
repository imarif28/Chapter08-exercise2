pipeline {
     agent any
     triggers {
          pollSCM('* * * * *')
     }
     stages {
          stage("Docker build") {
               steps {
                    sh "docker build -t leszko/hello-service:${BUILD_NUMBER} ."
               }
          }

          stage("Docker push") {
               steps {
                    sh "docker push leszko/hello-service:${BUILD_NUMBER}"
               }
          }

          stage("Update version") {
               steps {
                    sh "sed  -i 's/{{VERSION}}/${BUILD_NUMBER}/g' deployment.yaml"
               }
          }
          
          stage("Deploy to staging") {
               steps {
                    sh "kubectl config use-context staging"
                    sh "kubectl apply -f deployment.yaml"
               }
          }

          stage("Performance test") {
               steps {
                    sleep 20
                    sh "chmod +x performance-test.sh && ./performance-test.sh"
               }
          }
     }
}
