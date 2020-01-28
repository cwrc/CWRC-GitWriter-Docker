openssl req -config cwrc-gitwriter-localhost.conf -new -sha256 -newkey rsa:2048 \
-nodes -keyout cwrc-gitwriter-localhost.key -x509 -days 365 \
-out cwrc-gitwriter-localhost.crt