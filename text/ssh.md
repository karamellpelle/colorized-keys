# SSH {#ssh}

A keypair `id_key` consists of two files: `id_key` (private) and `id_key.pub` (public). 
The key format is [SSH](https://coolaj86.com/articles/the-openssh-private-key-format/). 
To list a SSH key file:

~~~colorized-sh
$ ssh-keygen -l -f ❗filename
~~~

## Create SSH keypair {#create-ssh}

Creating a SSH keypair consisting of `🔑id_key` and `🔒id_key.pub` using algorithm _Ed25519_:

~~~colorized-sh
$ KEY_IDENTIFIER="❗[email or hostname, typically]"
$ ssh-keygen -t ed25519 -C $KEY_IDENTIFIER -f 🔐id_key
~~~

### Create SSH keypair using FIDO2 {#inject-fido2-ssh}

A type of SSH keypair that is controlled by a FIDO2 hardware key. Two variants:

  * _Resident_/_Discoverable_: Proxy keypair is stored on the hardware key so it can 
    be deployed at any host. Needs hardware key and PIN to verify.
  * _Non-resident_/_Non-discoverable_: Proxy keypair is not stored on on the hardware 
    key, so it's useless without this, even for someone who has access to both the 
    hardware key and PIN. 

Creating a resident keypair using algorithm _Ed25519_:

~~~colorized-sh
$ KEY_SERVICE=❗[name of host service, typically] # only for information
$ KEY_SERVICE_USER=❗[username for this service]  # only for information
$ ssh-keygen -t ed25519-sk -O resident                       \
                           -O application="ssh:$KEY_SERVICE" \
                           -O user=$KEY_SERVICE_USER         \
                           -O verify-required
~~~

The proxy keypair can be deployed on a system using `ssh-keygen -K`.


### Create SSH keypair using PIV {#inject-piv-ssh}
\label{inject-piv-yubikey-ssh}

Find and define your PIV library on your system, something like

~~~colorized-sh
$ PKCS11_LIB=/usr/lib/libykcs11.so      # Yubico
$ PKCS11_LIB=/usr/lib/opensc-pkcs11.so  # OpenSC
~~~

Use PIV's authentication key (_9a_) for SSH authentication: 

~~~colorized-sh
$ ssh-keygen -D $PKCS11_LIB | grep -i auth > 🔒piv_auth.pub
~~~

Add `piv_auth.pub` to _authorized_keys_ on target host, for example through `ssh-copy_id`.

To log into a host using PIV:

~~~colorized-sh
$ ssh -I $PKCS11_LIB ❗example.com
~~~


### Create SSH keypair using SSL {#inject-ssl-ssh} 

## Sign SSH key {#sign-ssh-ssh}

There are two types of certificates: _user_ and _host_ (`-h`). The parameter `-I` specifies an identifier for the signer's key and is used for logging by the server whenever the certificate is used for authentication [^fnote-dmuth]. A serial number can be specified by the `-z` parameter.

To list a SSH certificate file:

~~~colorized-sh
$ ssh-keygen -L -f key-cert.pub
~~~


### SSH user certificate

Sign `userkey.pub` using `ca_key`, creating `userkey-cert.pub`, also specifying expiration date and principals the certificate covers. Handling of principals is defined by the server, see [man sshd_config](https://man.archlinux.org/man/sshd_config.5#AuthorizedPrincipalsFile).

~~~colorized-sh
$ CERTIFICATE_ID="❗[identifier for ca_key]"
$ CERTIFICATE_SERIAL=❗0 # or generate unique: $(date -u "+%Y%m%d%H%M%S") 
$ CERTIFICATE_PRINCIPALS=❗principal0,..,principalN
$ CERTIFICATE_VALID=❗+53w
$ ssh-keygen -s 🔑ca_key -I $CERTIFICATE_ID       \
                       -z $CERTIFICATE_SERIAL     \
                       -n $CERTIFICATE_PRINCIPALS \
                       -V $CERTIFICATE_VALID      \
                       🔒userkey.pub
~~~


### SSH host certificate

Sign `hostkey.pub` using `ca_key`, creating `hostkey-cert.pub`, also specifying which hostnames the certificate covers. 

~~~colorized-sh
$ CERTIFICATE_ID="❗[identifier for ca_key]"
$ CERTIFICATE_SERIAL=❗0 # or generate unique: $(date -u "+%Y%m%d%H%M%S")
$ CERTIFICATE_HOSTS=❗hostname0,..,hostnameN
$ CERTIFICATE_VALID=❗+53w
$ ssh-keygen -h -s 🔑ca_key -I $CERTIFICATE_ID   \
                          -z $CERTIFICATE_SERIAL \
                          -n $CERTIFICATE_HOSTS  \
                          -V $CERTIFICATE_VALID  \
                          🔒hostkey.pub
~~~


## Notes
* The identifier (comment) of key can be changed: `ssh-keygen -c -C ❗[new identifier] -f key`.


[^fnote-ssh-fido2]: [Securing SSH with FIDO2](https://developers.yubico.com/SSH/Securing_SSH_with_FIDO2.html)
https://developers.yubico.com/PIV/Guides/Securing_SSH_with_OpenPGP_or_PIV.html
[^fnote-dmuth]: [SSH At Scale: CAs and Principals](https://www.dmuth.org/ssh-at-scale-cas-and-principals/)
[^fnote-ssh-serial]: [Example of generating unique serial numbers](https://security.stackexchange.com/questions/246389/ssh-keygen-how-to-guarantee-the-uniqueness-of-serial-numbers)

\newpage
