
```shellbox
$ # 
$ HOSTNAME=my.domain.net # TODO
$ CERTIFICATE_ID=${HOSTNAME}:ssh_host_xxx_key-cert.pub # CRITICAL
$ CERTIFICATE_VALID=+52w # NOTE: COC
$ CERTIFICATE_SERIAL=$(date -u "+%Y%m%d%H%M%S") # FIXME!
$ # ^ use 64 a bit unique number for this certificate, https://security.stackexchange.com/questions/246389/ssh-keygen-how-to-guarantee-the-uniqueness-of-serial-numbers, 64 bit
$ # sign public ssh_host_xxx_key.pub using private SSH key ca_key, creating ssh_host_xxx_key-cert.pub for the host with (domain) name HOSTNAME
$ ssh-keygen -h -s ca_key -I "$CERTIFICATE_ID" -n "$HOSTNAME" -V $CERTIFICATE_VALID -z $CERTIFICATE_SERIAL ssh_host_xxx_key.pub
$ ssh-keygen -h -s ca_key -I "$CERTIFICATE_ID" -n "$HOSTNAME" -V $CERTIFICATE_VALID -z $CERTIFICATE_SERIAL ssh_host_xxx_key.pub fi
$ openssl req -d
$ ykman piv --help

## YubiKey create private key + public certificate
### Create keypair 
TODO: valid signature algoritms for YubiKey5!
```

# new shellbox

```shellbox
$ # * add -pass pass:<password> to encrypt 9x_private.pem
$ # outformat: PKCS8 FIXME
$ # Ed25519
CUNT
$ openssl COCK genpkey -out 9x_private.pem [-pass pass:PASSWORD] -algorithm ED25519
$ # RSA 4096 bits:
$ openssl genpkey -algorithm RSA -out ca_private.pem -pkeyopt rsa_keygen_bits:4096 -aes-128-cbc [-pass pass:PASSWORD]
$ 
$ # extract public key
$ # format: https://www.rfc-editor.org/rfc/rfc7468#section-13
$ openssl pkey -in 9x_private.pem -pubout -out 9x_public.pem
NOTE
ALERT
WARNING
$ for i in *.hs ; do cd $i source ; if x then x else z end; done
```

### fdsf

~~~~ {#mycode .haskell .numberLines startFrom="100"}
qsort []     = []
qsort (x:xs) = qsort (filter (< x) xs) ++ [x] ++
               qsort (filter (>= x) xs)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

### hoeeeeo


```default {#cunt .colorize .fuck mykey=isnotyours whatisit=nothing}
forM [0..2] $ \i -> putText (toText i) \textbf{crocs!}

```

~~~latex
### custom shellbox markups
* `\keypriv{private.key}  | 🔑{private.key}`
* `\keypub{public.key}    | 🔒{public.key}`
* `\keypair{keypair.keys} | 🔐{keypair.keys}`
* `\userdef{identifier}   | ❗{identifier}`
~~~


hohoho


> [!INFO]
> This is an informational message.

ddff

> [!NOTE]
> Useful information that users should know, even when skimming content.

ddff

> [!TIP]
> Helpful advice for doing things better or more easily.

ddff

> [!IMPORTANT]
> Key information users need to know to achieve their goal.

ddff

> [!WARNING]
> Urgent info that needs immediate user attention to avoid problems.

ddff

> [!CAUTION]
> Advises about risks or negative outcomes of certain actions.

ddff

##This is you{alert}

::::: {.block .alert}
hallo hallo hallo hallo
hhei hei ehie heie ehie
:::::

ho

::::: {#special .block .example}
Here is a paragraph.

And another.
:::::

hoh

::: Warning ::::::
This is a warning.
:::

::: Danger
This is a warning within a warning.
:::


### create and self sign certificate
```sh
$ # openssl req -x509 -new -key 9x-private.pem -utf8 -days 1000 -subj "CN=$YUBIKEY_ID" -out cert.pem
$ # FIXME: subject, etc. PKCS format?
$ # ^ -CA template.pem -CAkey 0x-private.pem for micro CA, 
$ # ^ -set_serial 
$ # ^ generate self signed root certificate: openssl req -x509 -newkey rsa:2048 -keyout key.pem -out req.pem
```

#### Notes
* openssl req -config <file.cfg> can setup a certificate a lot easier, even the [req] parameters here




### TODO: inject with OpenSC

### PIV|Yubico inject

```sh
$ ykman piv keys import --pin-policy DEFAULT --touch-policy DEFAULT [--password <password>] 9X 9x_private.pem
$ # policies will probabably be ignored by other PKCS#11 standard implementations
$ ykman piv certificates import --verify [--password <PASSWORD>] 9X 9x-cert.pem 
```

### TODO: PIV|Yubico self sign

```sh
$ export YUBIKEY_CN=Yubikey5-$(ykman list --serials | head -n1)
$ export 9X_CERT_VALID_DAYS=365
$ # ^ example: use serial number of first connected YubiKey as Common Name for Subject and Issuer
$ # create certificate for public key and sign with injected private key 
$ ykman piv certificates generate --subject "$YUBIKEY_CN" --valid-days $9X_CERT_VALID_DAYS 9X 9x-public.pem

```


### Bonus: read PIV certificate

```sh
$ ykman piv certificates export 9X - | openssl x509 -noout -text  
```


