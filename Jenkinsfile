node {
    def app

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }

    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        app = docker.build("neilcar/hellonode")
        echo app.id
        // echo app.parsedId
    }

    stage('Scan image') {
        twistlockScan ca: '', cert: '', gracePeriodDays: 60, compliancePolicy: 'low', dockerAddress: 'unix:///var/run/docker.sock', ignoreImageBuildTime: true, image: 'neilcar/hellonode:latest', key: '', logLevel: 'true', policy: 'warn', requirePackageUpdate: false, timeout: 10
    }
    
    stage('Publish scan results') {
        twistlockPublish ca: '', cert: '', compliancePolicy: 'low', image: 'neilcar/hellonode:latest', dockerAddress: 'unix:///var/run/docker.sock', key: '', ignoreImageBuildTime: true, logLevel: 'true', timeout: 10
    }
    
    stage('Test image') {
        /* Ideally, we would run a test framework against our image.
         * For this example, we're using a Volkswagen-type approach ;-) */

        app.inside {
            sh 'echo "Tests passed"'
        }
    }

    stage('Push image') {
        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Second, the 'latest' tag.
         * Pushing multiple tags is cheap, as all the layers are reused. */
        docker.withRegistry('http://localhost:5000') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }
}
