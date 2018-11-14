#!/usr/bin/env groovy

env.ELASTICSEARCH_HOST = 'rocks'
env.KIBANA_HOST = 'rocks'

node('arm32v7') {

    try {

        stage('grab_arch') {
          sh "uname -m > arch.txt"
          env.ARCH = readFile('arch.txt').trim()
          sh 'echo "$ARCH"'
        }

        stage('build') {
            // Clean workspace
            deleteDir()
            // Checkout the app at the given commit sha from the webhook
            checkout scm
            sh "make"
        }

        stage('test') {
            // Run any testing suites
        }

        stage('push') {
            // Push to Dockerhub
            sh "make push"
        }

    } catch(error) {
        throw error

    } finally {
        // Any cleanup operations needed, whether we hit an error or not

    }
}

node('master') {

    try {

        stage('scm') {
            // Clean workspace
            deleteDir()
            // Checkout the app at the given commit sha from the webhook
            checkout scm
        }

        stage('deploy') {
            // Docker deploy
            sh "make deploy"
        }

    } catch(error) {
        throw error

    } finally {
        // Any cleanup operations needed, whether we hit an error or not

    }
}
