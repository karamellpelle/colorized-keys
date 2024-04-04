TODO: REMOVE export, use shell variables
# SSH

## create keypairs

changing comment for keypair `key`/`key.pub` from default user@host:
`ssh-keygen -c -C <new comment> -f key`. Certificates does not have comments but a key identifier `-I <keyid>`

## create user keypairs 

```sh
$ # generate keypair id_key and id_key.pub
$ # OUT FORMAT: SSH
# export KEY_COMMENT
$ ssh-keygen -t ed25519 -C "<comment, i.e. identifier>" -f id_key
```

## create host keypairs

```sh
$ # create host keypairs here of common types (RSA; ECDSA, ED25519) 
$ mkdir --parents ./etc/ssh/
$ ssh-keygen -A -f .
$ 
```

## SSH|Piv inject

```sh
$ # get SSH public key for PIV.9a: Authentification
$ # use YubiKey PKCS#11 API library (TODO: create list for different libs)
# export PKCS11_LIB=/usr/lib/libykcs11.so
$ ssh-keygen -D "$PKCS11_LIB" | grep Auth > piv-auth.pub
```

# SSH signing

"-I key_id: In all cases, key_id is a "key identifier" that is logged by the	server when the	certificate is used for	authentication."


```sh
$ # show certificate 
$ ssh-keygen -L -f <filename>
$ 
```

## SSH|SSH sign user public key


```sh
$ # 
$ CERTIFICATE_SERIAL=$(date -u "+%Y%m%d%H%M%S") 
$ CERTIFICATE_ID=username@host.net
$ CERTIFICATE_USERS=username0,..,usernameN
$ CERTIFICATE_VALID=+52w
$ CERTIFICATE_OPTIONS="-Ono-touch-required"
$ ssh-keygen -s ca_key -I "$CERTIFICATE_ID" -z $CERTIFICATE_SERIAL -n $CERTIFICATE_USERS $CERTIFICATE_OPTIONS -V $CERTIFICATE_VALID userkey.pub
```

## SSH|SSH sign host public key

```sh
$ # 
$ HOSTNAME=my.domain.net
$ CERTIFICATE_ID=${HOSTNAME}:ssh_host_xxx_key-cert.pub
$ CERTIFICATE_VALID=+52w
$ CERTIFICATE_SERIAL=$(date -u "+%Y%m%d%H%M%S") 
$ # ^ use 64 a bit unique number for this certificate, https://security.stackexchange.com/questions/246389/ssh-keygen-how-to-guarantee-the-uniqueness-of-serial-numbers, 64 bit
$ # sign public ssh_host_xxx_key.pub using private SSH key ca_key, creating ssh_host_xxx_key-cert.pub for the host with (domain) name HOSTNAME
$ ssh-keygen -h -s ca_key -I "$CERTIFICATE_ID" -n "$HOSTNAME" -V $CERTIFICATE_VALID -z $CERTIFICATE_SERIAL ssh_host_xxx_key.pub
```


## SSH|PIV sign 
```sh
$ # get SSH public key for PIV.9c: Signature
$ ssh-keygen -D "$PKCS11_LIB" | grep Sign > piv-sign.pub
$ 

```

## SSH|PIV sign user public key

```sh
$ # 
$ ssh-keygen -D "$PKCS11_LIB" -s piv_sign.pub 
$ CERTIFICATE_SERIAL=$(date -u "+%Y%m%d%H%M%S") 
$ CERTIFICATE_ID=username@host.net
$ CERTIFICATE_USERS=username0,..,usernameN
$ CERTIFICATE_VALID=+52w
$ CERTIFICATE_OPTIONS="-Ono-touch-required"
$ ssh-keygen -D "$PKCS11_LIB" -s piv_sign.pub -I "$CERTIFICATE_ID" -z $CERTIFICATE_SERIAL -n $CERTIFICATE_USERS $CERTIFICATE_OPTIONS -V $CERTIFICATE_VALID userkey.pub

$ 
```

## SSH|PIV sign host public key

```sh
$ # 
$ HOSTNAME=my.domain.net
$ CERTIFICATE_VALID=+52w
$ CERTIFICATE_SERIAL=$(date -u "+%Y%m%d%H%M%S") # use 64 a bit unique number for this certificate, https://security.stackexchange.com/questions/246389/ssh-keygen-how-to-guarantee-the-uniqueness-of-serial-numbers, 64 bit
$ # sign public ssh_host_xxx_key.pub using PIV.9c (pointed to by piv-sign.pub), creating ssh_host_xxx_key-cert.pub for the host with (domain) name HOSTNAME

$ ssh-keygen -h -D "$PKCS11_LIB" -s piv-sign.pub -I "$CERTIFICATE_ID" -n "$HOSTNAME" -V $CERTIFICATE_VALID -z $CERTIFICATE_SERIAL ssh_host_xxx_key.pub

```

# SSHD add: 
https://goteleport.com/blog/how-to-configure-ssh-certificate-based-authentication/#configuring-ssh-to-use-host-certificates FIXME: remove this commercial reference
Add host key certificate and present for anyone who wants to connect
```sh
$ # add SSH keypair and SSH certificate to ssh_host_xxx_key/ssh_host_xxx_key.pub
$ cp -i ssh_host_xxx_key* /etc/ssh/
$ # update sshd_config: HostCertificate /etc/ssh/ssh_host_xxx_key-cert.pub', https://man.archlinux.org/man/sshd_config.5#HostCertificate
$ # NOTE: for every host key
$ # restart SSHD
$ systemctl restart sshd
$ # for users, add piv-sign.pub to a line in ~/.ssh/known_hosts with @cert-authority *.domain.net: @cert-authority *.example.com,ip, <piv-sign.pub content>



# fix permissions
$ chmod go-w ~
$ chmod 700 ~/.ssh
$ chmod 600 ~/.ssh/*
$ chown -R $USER ~/.ssh 

$ 
```

To enable access for user certificates, in sshd_config: 
* Add `PubkeyAuthentication yes`
* Add `TrustedUserCAKeys <file to list of .pub entries>`, like `/etc/ssh/ca/user_ca.pub`

Keep certificate at same place as public key. Principal must have been set in certificate.

## SSH create

Create a keypair `id_<keytype>` and `id_<keytype>.pub`

* `<comment>` is usually hostname, user or email
* Hosts keypairs are often named `ssh_host_<keytype>_key` and `ssh_host_<keytype>_key.pub`

```sh
$ ssh-keygen -t <keytype> -C "<comment>" -f id_<keytype>
```

## SSH CA create

Create a keypair `<host_ca_key|user_ca_key>` and `<host_ca_key|uyseer>k.p_uba` cfo_r host or user signing

* FIXME: what comment?

```sh
$ ssh-keygen -t <keytype> -C "<comment>" -f <host_ca_key|user_ca_key>
```

## SSH|SSH CA certify

Certify a host's public key `ssh_host_<keytype>_key.pub` as `ssh_host_<keytype>_key-cert.pub` using private key `<host_ca_key>`:

  * Certificate Only valid for comma separated `<{hostnames}>`
  * FIXME: What is `<key_id>`?

```sh
$ ssh-keygen -h -s <host_ca_key> -I <keyid> -n <{hostnames}> <host_ca_key> 
```

Certify a user's public key `id_<keytype>.pub` into `id_<keytype>-cert.pub` using private `<user_ca_key>` for signing.
  * consider adding validity
  * consider adding options, see _CERTIFICATES_ in manual page 


```sh
$ ssh-keygen -s <user_ca_key> -I <key_id> -n user1,user2 id_<keytype>.pub
```

### Extra:
Using SSH certificates: https://goteleport.com/blog/how-to-configure-ssh-certificate-based-authentication/#configuring-ssh-for-user-certificate-authentication
SSH change mod if generated outside: chmod 600 ssh_host_xxx* (todo: not -cert)

## SSH | YubicoPIV inject
Yubbico/PIV Format = PKSC8 ?

`ykman piv keys export 9a - | cmd`
`ykman piv keys import --pin-policy <PP> --touch-policy <TP> 9a - | cmd`

### Notes
Can be done with `yubico-piv-tool`

## SSH|PIV sign

```sh
ssh-keygen -s ca_key.pub -D libpkcs11.so -I key_id user_key.pub
```

## SSH|Piv inject

## SSH|Yubico FIDO inject
See https://man.freebsd.org/cgi/man.cgi?query=ssh-keygen&sektion=1&apropos=0&manpath=FreeBSD+14.0-RELEASE+and+Ports#FIDO_AUTHENTICATOR

## Yubico PIV create
Generating keys on hardware makes it possible to set attentation with slot f9, after private key generated. YubiKeys comes preloaded with Yubico PIV CA ("template") in f9 available for use. This default certificate can be overwritten (but not recalled if so). Out format is PEM or DER

ykman piv keys import --pin-policy <POLICY> --touch-policy <POLICY> 9x <9x_private.pem>
^ since the pin/touch policies for slot in PIV standard is given, other PKCS11 implementations will probably don't care about non-default settings
### Notes
Can be done with `gpg-card`

----------------------

Inject/map SSH: `ssh-keygen -i/-e <file> -m <format>`

`openssl pksc8 -in <infile>`
`openssl x509 -in certificate.pem -text`
`ykman piv` public output format is PKCS8. Default ssh import er RFC4716
`openssl ecparam/genrsa` gir keypair i formatet PKCS#1
`openssl ec/rsa -in keypair.pkcs1 -pubout -out` gir  i formatet PKCS#1
`openssl ec -in keypair.pkcs1 -text` : shows file
`openssl pkcs11 -topk8 `
`openssl verify -CAfile cert.pem cert.pem` : verify self signed x509 certifcate in PEM format 
`openssl req -CA take from MicroCA, -CAkey private.pem `
`openssl req -config: read config`
`openssl req -x509: test certificate output`
`openssl s_client -connect linuxhandbook.com:443 2>/dev/null | openssl x509 -noout -dates`: print client certificate
`openssl x509 -in certificate.pem -noout -pubkey`: create self signed certificated
`openssl s_client`: useful simple TLS client
create cert: https://docs.yubikey.wiki/v/piv-1/generate/with-openssl

Make sure non-user accessable to work: https://wiki.archlinux.org/title/OpenSSH#Checklist

## PIV
* PIV Card: FP 800-73: https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-73-4.pdf
* Key specification FP 800-78: https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-78-4.pdf

## PEM format 
https://stackoverflow.com/questions/5355046/where-is-the-pem-file-format-specified
spec here: https://www.rfc-editor.org/rfc/rfc7468
https://www.rfc-editor.org/rfc/rfc7468
PKCS12: encrypted container format for private and public certificate
  - openssl pkcs12 -export -in clientprivcert.pem -out clientprivcert.pfx
PKCS10: certificate sign request format
PKCS7: certificate sign request answer: certificate + CA cert
PKCS8: private key format
https://www.rfc-editor.org/rfc/rfc7468#section-13: public key format (used by SSH(?))
https://stackoverflow.com/questions/41904252/how-to-convert-x509-certificate-and-private-key-in-pem-format-to-gpg-format
TODO: use openssl req config files! https://www.aapelivuorinen.com/blog/2018/09/01/x509-on-macos-with-yubikey/
https://docs.yubico.com/hardware/yubihsm-2/hsm-2-user-guide/hsm2-openssl-yubihsm2.html
