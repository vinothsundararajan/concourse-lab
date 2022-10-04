# concourse-lab
Setting up labs for concourse-ci with help of cloud-shell

### Servers from cloud-shell 
    https://shell.cloud.google.com
  
### Documentation 
    https://concoursetutorial.com
    https://github.com/starkandwayne/concourse-tutorial
    https://concourse-ci.org

 ### Docker compose
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
  
 ### Docker image repository:
    registry-image
    
 ### Download fly 
    curl 'http://localhost:8080/api/v1/cli?arch=amd64&platform=linux' -o fly   
    chmod +x ./fly
    mv ./fly /usr/local/bin/
   
