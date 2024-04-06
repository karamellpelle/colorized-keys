# SSH {#ssh}

<!--🔑 🔒 🔐 ❗ ✅-->
* A keypair `id_key` consists of two files: `id_key` (private) and `id_key.pub` (public)
* Key format is _SSH_[^fnote-ssh-key-format]
* Common names are `id_<algorithm>` (user) and `ssh_host_<algorithm>_key` (host)

To list a SSH key:

~~~colorized-sh
$ ssh-keygen -l -f ❗keyname 
~~~


## Create SSH key {#create-ssh}

Creating a keypair `🔑id_key` and `🔒id_key.pub` using algorithm _Ed25519_.

```colorized-sh
$ KEY_IDENTIFIER="❗[email or hostname, typically]"
$ ssh-keygen -t ed25519 -C $KEY_IDENTIFIER -f 🔐id_key
```

## Sign SSH key {#sign-ssh-ssh}

There are two types of certificates: user and host. The parameter `-I` specifies an identifier for the signer's key and is used for logging by the server whenever the certificate is used for authentication [^fnote-dmuth]. A serial number can be specified by the `-z` parameter [^fnote-ssh-serial].

To list a SSH certificate:

~~~sh
$ ssh-keygen -L -f ✅keyname-cert.pub
~~~
<!--TODO: fix colorize keyname-cert.pub-->


### SSH user certificate

Sign `userkey.pub` using `ca_key`, creating `userkey-cert.pub`, also specifying expiration date and principals the certificate covers. Handling of principals is defined by the server, see [man sshd_config](https://man.archlinux.org/man/sshd_config.5#AuthorizedPrincipalsFile).

```colorized-sh
$ CERTIFICATE_ID="❗[identifier for ca_key]"
$ CERTIFICATE_SERIAL=❗0 # or generate unique: $(date -u "+%Y%m%d%H%M%S") 
$ CERTIFICATE_PRINCIPALS=❗principal0,..,principalN
$ CERTIFICATE_VALID=❗+53w
$ ssh-keygen -s 🔑ca_key -I $CERTIFICATE_ID -z $CERTIFICATE_SERIAL -n $CERTIFICATE_PRINCIPALS -V $CERTIFICATE_VALID 🔒userkey.pub
```


### SSH host certificate

Sign `hostkey.pub` using `ca_key`, creating `hostkey-cert.pub`, also specifying which hostnames the certificate covers. 

```colorized-sh
$ CERTIFICATE_ID="❗[identifier for ca_key]"
$ CERTIFICATE_SERIAL=❗0 # or generate unique: $(date -u "+%Y%m%d%H%M%S")
$ CERTIFICATE_HOSTS=❗hostname0,..,hostnameN
$ CERTIFICATE_VALID=❗+53w
$ ssh-keygen -h -s 🔑ca_key -I $CERTIFICATE_ID -z $CERTIFICATE_SERIAL -n $CERTIFICATE_HOSTS -V $CERTIFICATE_VALID 🔒hostkey.pub
```

[^fnote-ssh-key-format]: [`ssh-keygen -m`](https://man.archlinux.org/man/ssh-keygen.1#m) and  [RFC4716](https://www.rfc-editor.org/rfc/rfc4716)
[^fnote-dmuth]: [SSH At Scale: CAs and Principals](https://www.dmuth.org/ssh-at-scale-cas-and-principals/)
[^fnote-ssh-serial]: [Example of generating unique serial numbers](https://security.stackexchange.com/questions/246389/ssh-keygen-how-to-guarantee-the-uniqueness-of-serial-numbers)

\newpage
