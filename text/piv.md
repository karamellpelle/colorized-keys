# PIV {#piv} 
\label{yubico-piv}

## Create PIV keypair {#create-piv}

### Create PIV keypair using Yubikey {#create-piv-yubikey}

Generate a private Ed25519 key at `9X` with default touch and PIN policies, and export the public key as 🔒public.pem :

~~~colorized-sh
> ykman piv keys generate --algorithm ED25519 ❗9X 🔒public.pem
~~~

[TODO: create x509 certificate and write to PIV](#selfsign-piv)

### Create PIV keypair using SSL {#inject-ssl-piv}

## Sign PIV key {#sign-piv-piv}
\label{selfsign-piv}

### Sign PIV key using SSL {#sign-ssl-piv}

TODO: sign public key and create x509 certificate, upload to hardware key

\newpage

