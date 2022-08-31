pipeline { 
     agent any
     environment {
        dockerhub=credentials("dockerhub")
     } 
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
                sh "docker build -t splucena/calculator:${BUILD_TIMESTAMP} ."
            }
          }
          stage("Docker Login") {
            steps {
                sh "docker login -u \$dockerhub_USR -p \$dockerhub_PSW"
            }
          }
          stage("Docker Push") {
            steps {
                sh "docker push splucena/calculator:${BUILD_TIMESTAMP}"
            }
          }
          stage("Deploy to Staging") {
            steps {
                sh "docker run -d --rm -p 8765:8080 --name calculator splucena/calculator:${BUILD_TIMESTAMP}"
            }
          }
          stage("Acceptance Test") {
            steps {
                sleep 60
                sh "./gradlew acceptanceTest -D calculator.url=http://localhost:8765"
            }
          }
     }
     post {
        always {
            sh "docker stop calculator"
        }
     }
}