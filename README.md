# concourse-lab
Setting up labs for concourse-ci with help of cloud-shell

### Servers from cloud-shell and aws instance:
    https://shell.cloud.google.com
  
### Documentation help:
    https://concoursetutorial.com
    https://github.com/starkandwayne/concourse-tutorial
    https://concourse-ci.org

 ### Docker compose:
    # wget https://raw.githubusercontent.com/starkandwayne/concourse-tutorial/master/docker-compose.yml
    # cat docker-compose.yaml 
        ---
        version: "3"

        services:
          concourse-db:
            image: postgres
            environment:
              - POSTGRES_DB=concourse
              - POSTGRES_PASSWORD=concourse_pass
              - POSTGRES_USER=concourse_user
              - PGDATA=/database

          concourse:
            image: concourse/concourse
            command: quickstart
            privileged: true
            depends_on: [concourse-db]
            ports: ["8080:8080"]
            environment:
              - CONCOURSE_POSTGRES_HOST=concourse-db
              - CONCOURSE_POSTGRES_USER=concourse_user
              - CONCOURSE_POSTGRES_PASSWORD=concourse_pass
              - CONCOURSE_POSTGRES_DATABASE=concourse
              - CONCOURSE_EXTERNAL_URL=https://<fqdn-address>
              - CONCOURSE_ADD_LOCAL_USER=admin:admin
              - CONCOURSE_MAIN_TEAM_LOCAL_USER=admin
              - CONCOURSE_GARDEN_DNS_PROXY_ENABLE=true
              - CONCOURSE_WORKER_GARDEN_DNS_PROXY_ENABLE=true
    # docker-compose up -d
  

 ### Download fly 
    curl 'http://localhost:8080/api/v1/cli?arch=amd64&platform=linux' -o fly   
    sudo chmod +x ./fly
    sudo mv ./fly /usr/local/bin/
 ### Configure fly
    #cat ~/.flyrc 

      targets:
      tutorial:
         api: http://localhost:8080
         team: main
         token:
            type: bearer
            value: <*token-id*>

 ### Sample project
    pipeline.yaml
    ---
    resources:
    - name: concourse-tutorial
        type: git
        source:
        uri: https://github.com/vinothsundararajan/concourse-lab.git
        branch: main
    jobs:
    - name: maven-build-project
        public: true
        plan:
        - get: concourse-tutorial
        - task: pull-mvn-build
            config:
            platform: linux
            image_resource:
                type: registry-image
                source: 
                repository: maven
                tag: latest
            inputs:
                - name: concourse-tutorial
            outputs:
                - name: concourse-app-output
            run:
                path: concourse-tutorial/ci/mvn.sh
                args: ["vinothsundararajan"]
    mvn.sh
    
    #!/bin/sh
    set -xe 
    echo  -e "INFO: This script to execute maven build , compile and package  process by $1"
    sleep 5
    if [ $? -eq 0 ]; then
      echo -e "INFO: Maven clean process just begins.."
      disk_usage=$(df -hT /)
      ls -l 
      echo  -e "INFO: maven building in $(hostname) container at $(pwd)"
      cd concourse-tutorial
      mvn clean
      if [ "$?" -eq 0 ]; then
        mvn install ; 
        if [ "$?" -eq 0 ]; then
          echo  -e "INFO: Maven clean and install successfully."
          mvn package ;
          cp target/my-app-*.jar ../concourse-app-output/my-app.jar
        fi
      fi
    fi
    sleep 5

 ### Docker image repository:
    registry-image

 ### Execute executor.sh and fly command configured:
     bash ./executor.sh
