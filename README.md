# Lambda layer - Supply OpenSSL Modules (Fips)
### Build
Built using Docker, uses a generic buid image to compile OpenSSL from source based on the architecture and supplies it.
Passes the built libs through another layer used to push the final image.

### Run Container & Zip contents

Start the temp container to pull the image contents (especially the OpenSSL libs), download them locally. 
Uses ditto facility (zip/7zip in windows) to produce the archive which contains the built libs from the container.

### Supply them as Layer
Upload or login to AWS through CLI to create the lambda layer using the zip package produced above.

### Running the Lambda
Supply a wrapper script which will load the `.cnf` files along with the env variables as below -

```shell
export OPENSSL_CONF_INCLUDE=<path of configuration files>
export OPENSSL_MODULES=<provider-path>
```
In addition, set the `NODE_OPTIONS` variable to `--enable-fips` or programmatically set it like this - 
```js
crypto.setFips(true)
```
Supply the wrapper script via the env variable `AWS_LAMBDA_EXEC_WRAPPER` and providint the value as `/var/task/script.sh`.
The `script.sh` file being your wrapper script. 

<img width="1125" alt="Screenshot 2024-04-12 at 12 00 04 AM" src="https://github.com/Venkatakrishnan/opensssl-fips-lambda-layer/assets/174667/d1e5f9f7-e913-4a06-bc71-5168c88d8270">

>Sample wrapper script 
```shell
#!/bin/bash
args=("$@")
#Add the env vars here
export FIPS_MODE="true"
export OPENSSL_CONF=/var/task/nodejs.cnf
export OPENSSL_MODULES=/opt/layer/local/lib/ossl-modules
export NODE_OPTIONS=--enable-fips
# Pass the execution back to the runtime
exec "${args[@]}"
```
