# PIV {#piv} 
\label{yubico-piv}

## Create PIV keypair {#create-piv}
TODO: use OpenSC ([pkcs11-tool](https://htmlpreview.github.io/?https://github.com/OpenSC/OpenSC/blob/master/doc/tools/tools.html#pkcs11-tool)?)

### Create PIV keypair using Yubikey {#create-piv-yubikey}

Generate private Ed25519[^1] keypairs for authorization, signing and encryption with default touch and PIN policies. The private parts are (obviously) stored in the YubiKey, and the public parts are written to files.

~~~colorized-sh
$ ykman piv keys generate --algorithm ED25519 ❗9A 🔒piv-auth.pem # auth
$ ykman piv keys generate --algorithm ED25519 ❗9C 🔒piv-sign.pem # sign
$ ykman piv keys generate --algorithm X25519  ❗9D 🔒piv-encr.pem # encryption
~~~

Create self signed certificates for each slot:\label{selfsign-piv}

~~~colorized-sh
$ YUBIKEY_CN=YubiKey5-$(ykman list --serials | head -n1) # use serial number for common name,
$                                                        # assuming only only 1 connected YubiKey
$ YUBIKEY_SUBJECT="$YUBIKEY_CN" # +=",O=org,L=city,etc" <- add more parts to distinguished name
$ YUBIKEY_VALID_DAYS=365 # for example
$ ykman piv certificates generate --valid-days $YUBIKEY_VALID_DAYS --subject '$YUBIKEY_SUBJECT' 9A 🔒piv-auth.pem 
$ ykman piv certificates generate --valid-days $YUBIKEY_VALID_DAYS --subject '$YUBIKEY_SUBJECT' 9C 🔒piv-sign.pem 
$ ykman piv certificates generate --valid-days $YUBIKEY_VALID_DAYS --subject '$YUBIKEY_SUBJECT' 9D 🔒piv-encr.pem 
~~~

TODO: update SVG sign arrows!

To show PIV certicate for keypair at slot `9X`: `ykman piv certificates export 9X - | openssl x509 -noout -text` (or export to file without piping from stdout, `-`).

#### Attested hardware generated certificates

Hardware generated keypairs can be [attested](https://developers.yubico.com/PIV/Introduction/PIV_attestation.html), that is, the generated certificate will be signed by the template X509 certificate at slot `9F`. An attested certificate means that the keypair has only been generated on the hardware. YubiKey's comes with a preinstalled, official attestation certificate template at `9F`, _Yubico PIV CA_, but this template certificate can be changed to a custom template certificate by uploading a X509 certificate together with its private key at slot `9F`. However, uploading a new template certificate will delete _Yubico PIV CA_ on the YubiKey forever, and it can't be reuploaded, even by a device reset.

~~~colorized-sh
$ yubico-piv-tool --action=attest --slot=9a > ✅piv-auth.cert 
$ yubico-piv-tool --action=attest --slot=9c > ✅piv-sign.cert 
$ yubico-piv-tool --action=attest --slot=9d > ✅piv-encr.cert 
$ ykman piv certificates import --verify 9A ✅piv-auth.cert
$ ykman piv certificates import --verify 9C ✅piv-sign.cert
$ ykman piv certificates import --verify 9D ✅piv-encr.cert
~~~

### Create PIV keypair using SSL {#inject-ssl-piv}

### Sign PIV key using SSL {#sign-ssl-piv}

TODO: sign public key and create x509 certificate, upload to hardware key

## Notes

[^1]: Needs YubiKey 5.7 or later. For other algorithms, see `ykman piv keys generate -h`

\newpage

