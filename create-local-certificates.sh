#!/usr/bin/env bash

mkdir ./certs/

# Generate the root certificate
openssl genrsa -des3 -out ./certs/rootCA.key -passout pass:password 2048

# Generate public certificate
openssl req -x509 -new -nodes -key ./certs/rootCA.key -sha256 -passin pass:password -days 1024 -out ./certs/rootCA.pem -subj '/CN=localhost' -extensions EXT -config <( printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

# Generate certificate signing request
openssl req -new -sha256 -nodes -out ./certs/server.csr -newkey rsa:2048 -keyout ./certs/server.key -config <( cat server.csr.cnf )

# Generate server certificate 
openssl x509 -req -in ./certs/server.csr -CA ./certs/rootCA.pem -CAkey ./certs/rootCA.key -passin pass:password -CAcreateserial -out ./certs/server.crt -days 500 -sha256 -extfile v3.ext

# Ask macOS Keychain Access to trust rootCA and localhost cert
sudo security -v add-trusted-cert -d -r trustRoot -p ssl -k /Library/Keychains/System.keychain certs/rootCA.pem
sudo security -v add-trusted-cert -d -r trustRoot -p ssl -k /Library/Keychains/System.keychain certs/server.crt