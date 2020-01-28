# Generate Self-Signed SSL Certificate

**This is an optional step.**

For development purpuses, CWRC-GitWriter will work fine on http. But to make development environment more concestenct with staging and prodcution environment, this step will allow you to work with https on your local machine.

Tutotial adapted from: [How to Set Up HTTPS Locally Without Getting Annoying Browser Privacy Errors](https://deliciousbrains.com/https-locally-without-browser-privacy-errors/)

## Generate the certificate

Run `cd /container_volumes/cert && sudo sh generate-certs.sh` to generate SSL key and certificate. You will be prompt to inform you password and then to complete a form. You can leave most of the fields with the default information.
A certificate file will be created in the folder.

## Setup the certificate on Traefik

**docker-compose-dev.yml**
Uncomment `- ./container_volumes/certs:/certs` at Traefik block.

**/container_volumes/traefik/conf/router-dev/common.yml**
Uncomment `tls:` block.

Make sure to stop and remove containers all container before, and start them again once you have saved theses changes.

## Add and concifure the certificate in you computer

### MacOS

Double click on the file `cwrc-gitwriter-localhost.crt`. If you have multiple keychains it might prompt you to select the appropriate location. If you only have one keychain, your certificate might be added to your keychain without a prompt.

#### Configure

Open Keychain Access window and search for your certificate: `cwrc-gitwriter-localhost`
Double click on it. A window will open with the certificate details. Expand the Trust section. Change the “When using this certificate:” select box to “Always Trust”.
Close the certificate window. It will ask you to enter your password (or scan your finger), do that. Now visit your dev site again.

### Windows

### Linux

## Configure GitServer and GitWriter

### GitServer

**config.js**
url should be call `https`

```json
"github_client_origin": "https://localhost"
"github_oath_callback": "https://localhost:3000/github/callback"
"github_oath_callback_redirect": "https://localhost"
```

### GitWriter

**/config/config.js**
url should be call `https`

```json
"nerveUrl": "https://localhost/nerve/",
"validationUrl": "https://localhost/validator/validate.html",
```
