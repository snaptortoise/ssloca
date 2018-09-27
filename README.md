# SSLoca
## Generate trusted local SSL certificates for macOS

This is a bash script that removes (some of) the headache when generating and trusting SSL certificates for localhost projects in macOS. Instead of jumping between ~5 different commands, 6+ prompts and manually opening Keychain Access to trust your locally generated certificates, you can simply run this script and be done with it.

To do so, clone the project and run:

`./create-local-certificates.sh`

You will be prompted to enter your user password for the final steps that add the certificates to your keychain. When finished you will have these files in your `certs` folder ready to use:

```
rootCA.key
rootCA.pem
server.crt
server.csr
server.key
```

How and where you use these will depend on your project. 

If you're using [Express](http://expressjs.com/) it might look something like this:

```
const https = require('https');
const fs = require('fs');

const options = {
  key: fs.readFileSync('certs/server.key'),
  cert: fs.readFileSync('certs/server.crt'),
};

https.createServer(options, (req, res) => {
  res.writeHead(200);
  res.end("hello world\n");
}).listen(8080);
```

## Caveats

**Do not use this in any kind of production!** The password generated for the root certificate is just `password`.


## Kudos

- [https://medium.freecodecamp.org/how-to-get-https-working-on-your-local-development-environment-in-5-minutes-7af615770eec](https://medium.freecodecamp.org/how-to-get-https-working-on-your-local-development-environment-in-5-minutes-7af615770eec)
- [https://www.jamf.com/jamf-nation/discussions/22294/adding-a-certificate-to-the-system-keychain-set-to-always-trust](https://www.jamf.com/jamf-nation/discussions/22294/adding-a-certificate-to-the-system-keychain-set-to-always-trust)
- [https://stackoverflow.com/questions/38318102/how-to-specify-policy-constraint-for-certificates-using-os-xs-security-add-tru](https://stackoverflow.com/questions/38318102/how-to-specify-policy-constraint-for-certificates-using-os-xs-security-add-tru)
