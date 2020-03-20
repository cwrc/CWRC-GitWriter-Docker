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

**Change to development branch**: `cd CWRC-GitWriter-Docker && git checkout development`

2.Make copies of the following files (remove the `.example` extension):

- `container_volumes/traefik/traefik.yml`: set e-mail for Let's Encrypt (Step 4)
- `container_volumes/traefik/conf/*`: set the host name (Step 5)
- `container_volumes/cwrc-gitserver/config.json.example`: set the GitHub integration (Step 6-7)
- `container_volumes/cwrc-gitwriter/config.json.example`: set the host for nerve and validator service (Step 8)

3.Setup Let's Encrypt certificate generation

- traefik.yml: `email: "YOUR@EMAIL.COM"`

4.Setup host rules

- traefik-api.yml: ``rule: Host(`YOUR.DOMAIN`)`` and `"USER:PASSWORD"`. Use `htpasswd` to create an ecrypted password. (e.g., `htpasswd -nb admin secure_password`)
- common.yml: ``rule: Host(`YOUR.DOMAIN`)``
- gitserver.yml: ``rule: Host(`YOUR.DOMAIN`)``
- gitwriter.yml: ``rule: Host(`YOUR.DOMAIN`)``
- nerve.yml: ``rule: Host(`YOUR.DOMAIN`)``
- validator.yml: ``rule: Host(`YOUR.DOMAIN`)``

5.GitHub Oauth App creation (in not already available. [Instructions](https://developer.github.com/apps/building-oauth-apps/creating-an-oauth-app/)

- `Homepage URL`, use `https://${your_host_from_above}/`,
- `Authorization callback URL`, use `https://${your_host_from_above}/github/callback`
- Record `Client ID` and the `Client Secret` for the next step

6.Update config for GitHub OAuth connectivity; details <https://github.com/cwrc/CWRC-GitServer#config>

On cwrc-gitserver/config.json:

- Update `Client ID` and the `Client Secret` from above
- Update `jwt_secret` with a randomly generated string of characters
- Update `github_client_origin`,`github_oath_callback` and `github_oath_callback` with the server host name

7.Setup  CWRC-GitWriter config.

CWRC-GitWriter comes with basic configurations. Relevant information for a server setup is the following:

On cwrc-gitwriter/config.json:

- `nerveUrl: 'https://YOUR.DOMAIN/nerve/'`,
- `validationUrl: 'https://YOUR.DOMAIN/validator/validate.html'`

Also, provide a username to access GeoNames' service:

- `lookups: { geonames: { username": "YOUR.USERNAME"} }`
Note that if a username is not provided, CWRC-Git-Writer will throw an error when trying to access GeoNames. You can create a free user account here account: [https://www.geonames.org/login](https://www.geonames.org/login)

See more about the config file here: [https://github.com/cwrc/CWRC-GitWriter/blob/master/README.md](https://github.com/cwrc/CWRC-GitWriter/blob/master/README.md)

## Deployment

- `https://${your_host_from_above}/` will be the site URL of CWRC-Writer
- `docker-compose up -d` will launch the containers
- `docker-compose logs -f` will follow the logs produced by the containers
- `docker-compose pull` will pull new images from DockerHub
- `docker-compose down` will stop the containers

## Dashboard

To access Trafeik Dashboard, naviate to the url you setup on traefik-api.yml (e.g., `https://YOUR.DOMAIN/dashboard/`).
Use the user and password you setup.
