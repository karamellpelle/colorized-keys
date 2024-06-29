# SSH {#ssh}

A keypair `id_key` consists of two files: `id_key` (private) and `id_key.pub` (public). The key format is [SSH](https://coolaj86.com/articles/the-openssh-private-key-format/). To list the content of a SSH key file:

~~~color
$ ssh-keygen -l -f ❗filename
~~~

## Create SSH keypair {#create-ssh}

Creating a SSH keypair consisting of `🔑id_key` and `🔒id_key.pub` using algorithm _Ed25519_:

~~~color
$ KEY_IDENTIFIER="❗[email or hostname, typically]"
$ ssh-keygen -t ed25519 -C $KEY_IDENTIFIER -f 🔐id_key
~~~

### Create SSH keypair using FIDO2 {#inject-fido2-ssh}

A type of SSH keypair that is controlled by a FIDO2 hardware key. Two variants:

  * _Resident_/_Discoverable_: Proxy keypair is stored on the hardware key so it can be deployed at any host. Needs hardware key and PIN to verify.
  * _Non-resident_/_Non-discoverable_: Proxy keypair is not stored on on the hardware key, so it's useless without this, even for someone who has access to both the hardware key and PIN. 

Creating a resident keypair using algorithm _Ed25519_:

~~~color
$ # these values are only used for key meta information (?):
$ KEY_SERVICE=❗[name of host service] 
$ KEY_USER=❗[username of host service to differate between] 
$ # generate resident FIDO2 key :
$ ssh-keygen -t ed25519-sk -O resident                       \
                           -O application="ssh:$KEY_SERVICE" \
                           -O user="$KEY_USER" \
                           -O verify-required
~~~

The proxy keypair can be deployed on a system using `cd ~/.ssh && ssh-keygen -K`.


### Create SSH keypair using PIV {#inject-piv-ssh}
\label{inject-piv-yubikey-ssh}

Find and define your PIV library on your system, something like

~~~color
$ PKCS11_LIB=/usr/lib/libykcs11.so      # Yubico
$ PKCS11_LIB=/usr/lib/opensc-pkcs11.so  # OpenSC
~~~

Use PIV's authentication key (_9a_) for SSH authentication: 

~~~color
$ ssh-keygen -D $PKCS11_LIB | grep -i auth > 🔒piv_auth.pub
~~~

Add `piv_auth.pub` to _authorized_keys_ on target host, for example through `ssh-copy_id`.

To log into a host using PIV:

~~~color
$ ssh -I $PKCS11_LIB ❗example.com
~~~


### Create SSH keypair using SSL {#inject-ssl-ssh} 

TODO: Use [sshpk](https://security.stackexchange.com/a/267767/303936) instead?
NOTE: For algorithm _Ed25519_ there is a [bug](https://security.stackexchange.com/a/267767/303936) for _ssh_ version < [9.6](https://www.openssh.com/txt/release-9.6), but it should work for algorithm _RSA_.

The generated keypair from SSL should already be in _PKCS8_ format.
<!--Convert SSL keypair to PKCS8 format (should unessessary because PKCS8 should be default output from `openssl genpkey`):-->
<!---->
<!--~~~color-->
<!--<!--$ openssl pkcs8 -topk8 -in 🔑key-priv.pem -->-->
<!--$ openssl pkey -in key-priv.pem -out key-priv.pkcs8-->
<!--$ openssl pkey -in 🔑key-priv.pem -pubout -out key-pub.pkcs8 -->
<!--$ openssl pkey -in 🔑key-priv.pem -out key-priv.pkcs8 -->
<!--~~~-->

Import public SSL key `🔒key-pub.pkcs8`:

~~~color
$ ssh-keygen -i -m pkcs8 -f 🔒key-pub.pkcs8  > 🔒id_key.pub 
~~~

TODO: Import private SSL key into SSH private key (should work as public key above according to `man ssh-keygen`).


## Sign SSH key {#sign-ssh-ssh}

There are two types of certificates: _user_ and _host_ (`-h`). The parameter `-I` specifies an identifier for the signer's key and is used for logging by the server whenever the certificate is used for authentication [^fnote-dmuth]. A serial number can be specified by the `-z` parameter.

To list a SSH certificate file:

~~~color
$ ssh-keygen -L -f key-cert.pub
~~~


### SSH user certificate

Sign `userkey.pub` using `ca_key`, creating `userkey-cert.pub`, also specifying expiration date and principals the certificate covers. Handling of principals is defined by the server, see [man sshd_config](https://man.archlinux.org/man/sshd_config.5#AuthorizedPrincipalsFile).

~~~color
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

Sign `hostkey.pub` using `ca_key`, creating `hostkey-cert.pub`, also specifying which hostnames the certificate covers (note the `-h` switch for host certificates):

~~~color
$ CERTIFICATE_ID="❗[identifier for ca_key]"
$ CERTIFICATE_SERIAL=❗0 # or generate unique: $(date -u "+%Y%m%d%H%M%S")
$ CERTIFICATE_HOSTS=❗hostname0,..,hostnameN
$ CERTIFICATE_VALID=❗+53w
$ ssh-keygen -s 🔑ca_key -I $CERTIFICATE_ID   \
                       -z $CERTIFICATE_SERIAL \
                       -n $CERTIFICATE_HOSTS  \
                       -V $CERTIFICATE_VALID  \
                       -h 🔒hostkey.pub
~~~

### Sign SSH key using PIV {#sign-piv-ssh}

Find and define your `$PKCS11_LIB` as [above](#inject-piv-ssh). Retrive the _public_ part of the PIV sign keypair (9c):

~~~color
$ ssh-keygen -D $PKCS11_LIB | grep -i sign > 🔒piv_sign.pub
~~~

Sign `key.pub`, creating `key-cert.pub`, using the private hardware key on PIV pointed to by `piv_sign.pub`. Remember the `-h` switch if this is a host certificate:

~~~color
$ ssh-keygen -s 🔒piv_sign.pub -D $PKCS11_LIB [-I ❗... -z ❗... -n ❗... -V ❗... ] \
                                            [-h] 🔒key.pub
~~~


## Notes
* The identifier (comment) of a key can be changed: `ssh-keygen -c -C ❗[new identifier] -f key`.
* To convert private SSH key `id_key` to public key: `ssh-keygen -y -f id_key > id_key.pub`

[^fnote-ssh-fido2]: [Securing SSH with FIDO2](https://developers.yubico.com/SSH/Securing_SSH_with_FIDO2.html)
https://developers.yubico.com/PIV/Guides/Securing_SSH_with_OpenPGP_or_PIV.html
[^fnote-dmuth]: [SSH At Scale: CAs and Principals](https://www.dmuth.org/ssh-at-scale-cas-and-principals/)
[^fnote-ssh-serial]: [Example of generating unique serial numbers](https://security.stackexchange.com/questions/246389/ssh-keygen-how-to-guarantee-the-uniqueness-of-serial-numbers)

\newpage
