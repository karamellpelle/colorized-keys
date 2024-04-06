# PIV {#piv} 
\label{yubico-piv}

## Create PIV {#create-piv}
FIXME: create PIV using OpenSC or similar

## Create PIV (Yubikey) {#create-piv-yubikey}

<!--Generating key `❗9X`{.colorized-sh}: FIXME: colorize inline-->
Generate an ED25519 key `9X` and export public key as a [SSL certificate](#cert-ssl):

~~~colorized-sh
> ykman piv keys generate --algorithm ED25519 ❗9X 🔒public.pem
~~~

#### more options 
(See `ykman piv keys generate -h`)

  - touch policy: _[DEFAULT|NEVER|ALWAYS|CACHED]_
  - PIN policy:   _[DEFAULT|NEVER|ONCE|ALWAYS]_
  - algorithms:   _[RSA1024|RSA2048|RSA3072|RSA4096|ECCP256|ECCP384|ED25519|X25519]_

## Insert PIV -> SSH {#inject-piv-ssh}


## Yubikey insert PIV -> SSH {#inject-piv-yubikey-ssh}
Create a proxy SSH key 🔒id_key.pub using PIV on hardware for verification:

## selfsign {#selfsign-piv}


## Yubico sign SSH
TODO: see text/ssh.md instead

Sign a SSH key 🔒id_key.pub with 🔒ca_key.pub on Yubikey and create either a host (`-h`) or user certificate ✅id_key-cert.pub

~~~colorized-sh
> ssh-keygen -s 🔒ca_key.pub [-h] -D /usr/lib/libykcs11.so -I host.example.com 🔒id_key.pub 
> # `-n user1,...,userN` can be added to restrict certificate to specified users 
> # on host
~~~

