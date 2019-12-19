# CWRC-GitWriter-Docker

Docker Compose orgistrated CWRC-Writer with included GitHub connector, NERVE, and Validation service

1. [Overview](#overview)

2. [Requirements](#requirements)

3. [Configuration](#configuration)

4. [Deployment](#deployment)

## Overview

Provide an container orgistrated means to deploy the [GitWriter] along with the connector to [GitHub] and validation tool and named entity recognizer [NERVE].

The goal, provide an easy to deploy instance of CWRC-Writer including commponents while only only modifying a limited number of config files.

## Requirements

- Docker & Docker Compose

## Configuration

The basics, clone this repository, modify the config files, and run docker-compose to pull the DockerHub images and deploy GitWriter. There are two appraoches available

- nginx reverse proxy: requried IP for the config files; [instructions](https://gitlab.dh.tamu.edu/bptarpley/CWRC-GitDocker/tree/master)

- or traefik reverse proxy & Let's Encrypt: required server DNS entry (following)
- By default, `docker-compose.yml` and `traefik.yml` setup ports `80` and `443`
  
### Steps for Traefik

1. Clone repository: `https://github.com/cwrc/CWRC-GitWriter-Docker.git`

2. **Change to development branch**: `cd CWRC-GitWriter-Docker && git checkout development`

3. Make copies of the following files (remove the `.example` extension):

- `container_volumes/cwrc-gitserver/config.js.example`: set the GitHub integration
- `container_volumes/traefik/traefik.yml`: set e-mail for Let's Encrypt
- `container_volumes/traefik/traefik.d/*`: set the host name

4. Replace / Complete the following:

- E-mail for Let's Encrypt certificate generation within Traefik config:
  - traefik.yml: `email: "USER@EXAMPLE.ORG"`
- Host name: edit Traefik config adding the server host name
  - dynamic.yml: ``rule: Host(`gitwriter.services.EXAMPLE.ORG`)``
  - gitwriter.yml: ``rule: Host(`gitwriter.services.EXAMPLE.ORG`)``
  - gitserver.yml: ``rule: Host(`gitwriter.services.EXAMPLE.ORG`)``

5. GitHub Oauth App creation (in not already available. [Instructions](https://developer.github.com/apps/building-oauth-apps/creating-an-oauth-app/)

- `Homepage URL`, use `https://${your_host_from_above}/`,
- `Authorization callback URL`, use `https://${your_host_from_above}/github/callback`
- Record `Client ID` and the `Client Secret` for the next step

6. Update config for GitHub OAuth connectivity; details <https://github.com/cwrc/CWRC-GitServer#config>

- Update `Client ID` and the `Client Secret` from above
- Update `jwt_secret` with a randomly generated string of characters
- Update `github_client_origin`,`github_oath_callback` and `github_oath_callback` with the server host name

**Ports:** By default, `docker-compose.yml` and `traefik.yml` setup ports `80` and `443`

## Deployment

- `https://${your_host_from_above}/` will be the site URL of CWRC-Writer

- `docker-compose up -d` will launch the containers

- `docker-compose logs -f` will follow the logs produced by the containers

- `docker-compose pull` will pull new images from DockerHub

- `docker-compose down` will stop the containers
