# HM User Service
A user microservice for the Household Manager platform.

## For Dev Work

Dependencies:
- dotnet core 10.0

1. Clone the main branch.
2. Navigate to the directory you cloned it into (the root of the project).
3. Run `dotnet restore` to install the dependencies on the projects.
4. Open the solution in your IDE of preference.

## For Dev Docker Build

Dependencies:
- docker
- docker compose
- traefik 2.0
- dnsmasq to redirect *.docker urls to localhost
- dotnet core 10.0 with ef tool installed

1. Clone the main branch.
2. Navigate to the directory you clone it into (the root of the project).
3. Create an empty file .data/userContext.db (ex. `touch .data/userContext.db`).
7. Run `docker compose --build -up -d`. Wait for the notification that the user service is running.
8. Open your browser and navigate to http://hm-user-service.docker/graphql.

## Production

Automatically builds to the https://hub.docker.com/r/kcordes/hm-user-service image in DockerHub.
