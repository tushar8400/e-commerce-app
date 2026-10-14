@Library("shared") _

pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'tusharv02/e-commerce' 
        DOCKER_MIGRATION_IMAGE = 'tusharv02/e-commerce-migration' 
        DOCKER_CREDENTIALS = credentials("docker-hub-credentials")
        GITHUB_CREDENTIALS = credentials("github-credentials")
        EMAIL_ADDRESS = "tusharvalmiki0204@gmail.com"
        GIT_BRANCH = "hackathon"
    }
    
    stages {
        stage("Set Build Tags") {
            steps {
                script {
                    env.DOCKER_TAG = "${BUILD_NUMBER}"
                }
            }
        }
        stage("Clean Workspace") {
            steps {
                cleanWorkspace()
            }
        }
        stage("Code Repository") {
            steps {
                cloneRepository(
                    branch: "hackathon",
                    repoUrl: "https://github.com/tushar8400/e-commerce-app.git"
                )
            }
        }
        stage("Trivy File System Scanning") {
            steps {
                trivyFileSystemScan()
            }
        }
        stage("Docker Image Build") {
            parallel {
                stage("Build Main Docker Image") {
                    steps {
                        dockerBuild(
                            imageName: env.DOCKER_IMAGE,
                            imageTag: env.DOCKER_TAG
                        )
                    }
                }
                stage("Build Migration Docker Image") {
                    steps {
                        dockerBuild(
                            imageName: env.DOCKER_MIGRATION_IMAGE,
                            imageTag: env.DOCKER_TAG,
                            dockerfile: './scripts/Dockerfile.migration',
                            context: '.'
                        )
                    }
                }
            }
        }
        stage("Trivy Image Scanning") {
            steps {
                trivyImageScan(
                    imageName: env.DOCKER_IMAGE, 
                    imageTag: env.DOCKER_TAG
                )
            }
        }
        stage("Push Docker Image") {
            parallel {
                stage("Pushing Main Docker Image") {
                    steps {
                        dockerPush(
                            imageName: env.DOCKER_IMAGE,
                            imageTag: env.DOCKER_TAG,
                            credentialsId: env.DOCKER_CREDENTIALS
                        )
                    }
                }
                stage("Pushing Migration Docker Image") {
                    steps {
                        dockerPush(
                            imageName: env.DOCKER_MIGRATION_IMAGE,
                            imageTag: env.DOCKER_TAG,
                            credentialsId: env.DOCKER_CREDENTIALS
                        )
                    }
                }
            }
        }
    }
    post {
        always {
            emailNotification(env.EMAIL_ADDRESS, ['trivy-image-report.txt', 'trivy-fs-report.txt'])
        }
    }
}
