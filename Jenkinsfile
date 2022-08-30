pipeline { 
     agent any 
     stages { 
          stage("Compile") { 
               steps { 
                    sh "./gradlew compileJava" 
               } 
          } 
          stage("Unit test") { 
               steps { 
                    sh "./gradlew test" 
               } 
          } 
          stage("Code Coverage") {
            steps {
                sh "./gradlew jacocoTestReport"
                 publishHTML (target: [ 
                    reportDir: 'build/reports/jacoco/test/html',               
                    reportFiles: 'index.html',               
                    reportName: "JaCoCo Report"          
                ])
                sh "./gradlew jacocoTestCoverageVerification"
            }
          }
          stage("Static Code Analysis") {
            steps {
                sh "./gradlew checkstyleMain"
                publishHTML (target: [     
                    reportDir: 'build/reports/checkstyle/',     
                    reportFiles: 'main.html',     
                    reportName: "Checkstyle Report" 
                ])
            }
          }
          stage("Package") {
            steps {
                sh "./gradlew build"
            }
          }
          stage("Docker Build") {
            steps {
                sh "docker build -t splucena/calculator:latest ."
            }
          }
          stage("Docker Login") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-registry-login', passwordVariable: 'DOCKER_REGISTRY_PWD', usernameVariable: 'DOCKER_REGISTRY_USER')]) {
                sh "docker login -u $DOCKER_REGISTRY_USER -p $DOCKER_REGISTRY_PWD"
                }
            }
          }
          stage("Docker Push") {
            steps {
                sh "docker push splucena/calculator:latest"
            }
          }
          stage("Deploy to Staging") {
            steps {
                sh "docker run -d --rm -p 8765:8080 --name calculator splucena/calculator:latest"
            }
          }
     } 
}