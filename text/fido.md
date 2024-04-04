
# FIDO2 {#yubico-fido2}
  - [man ssh-keygen#FIDO_AUTHENTICATOR](https://man.archlinux.org/man/ssh-keygen.1#FIDO_AUTHENTICATOR)
  - https://developers.yubico.com/SSH/Securing_SSH_with_FIDO2.html

Resident (discoverable) vs non-discoverable: Discoverable lets you easy carry the keypair and deploy on a new system (keys can be found - discovered). Non-discoverable: the proxy-private and public keys are carried on the key, so you must move this keypair to the new computer where you want to do SSH (hence: a forgotten/stolen yubikey with pin known will not be enough to authoricate because the attacker also need the (non-discoverable) keypair )


## Create FIDO2{#create-fido2}
Two types:
  - Resident/Discoverable: Both keys are stored on Yubikey and can be deployed at
    any host. Needs PIN to verify.
  * Non-resident/Non-discoverable: Private key is not stored on Yubikey, so Yubikey
    is useless if someone else has access to both the Yubikey and PIN. 

Creating a resident keypair on a Yubikey, using ED25519 and host identificator ❗hostid. `<comment>` is typically used for easy identification:

~~~colorized-sh
> ssh-keygen -t ed25519-sk -O resident -O application=ssh:❗hostid -O verify-required -C <comment>
> 
~~~

## Insert FIDO2 -> PIV {#inject-fido2-piv}

## Insert FIDO2 -> SSH {#inject-fido2-ssh}

## Old

```sh
$ # generate proxy-private key (pointing to generated private key in hardware) and public key
$ ssh-keygen -t ed25519-sk -C "$KEY_ID" -O resident -O no-touch-required -O verify-required [-O application="ssh:$APPLICATION_ID"] [-O user="$USER_ID"]

```
TODO: -f <filename> ?

## deploy
https://developers.yubico.com/SSH/Securing_SSH_with_FIDO2.html
```sh
$ # retrieve proxy-private and public keys
$ cd ~/.ssh
$ ssh-keygen -K
$ # now launch ssh with -i <deployed id>
```

