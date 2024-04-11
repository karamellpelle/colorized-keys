# SSL {#ssl}

The key format is usually [_PEM_](https://man.archlinux.org/man/openssl-format-options.1ssl.en) but can be changed. 

## Create SSL keypair {#create-ssl}

Creating a SSL private key `private.pem` using algorithm _Ed25519_ and default options (algorithm specific options can be controlled by the `-pkeyopt` flag):

~~~colorized-sh
$ openssl genpkey -algorithm ed25519 -out 🔑private.pem
~~~

Get the public key `public.pem` from the private key:

~~~colorized-sh
$ openssl pkey -in 🔑private.pem -pubout -out 🔒public.pem 
~~~

## Sign SSL key {#sign-ssl-ssl}

To sign a public SSL key `public.pem`, first use the private key `private.pem` to create a certificate signing request `request.csr`. Output format is [PKCS#10](https://www.rfc-editor.org/rfc/rfc2986) (as PEM). This command will prompt for the [_Distinguished Name_](https://www.rfc-editor.org/rfc/rfc1485) (subject) of the certificate request.

~~~colorized-sh
$ openssl req -utf8 -new -key 🔑private.pem -out ❗request.csr
~~~

To add number of days valid (default is 30!), subject, extensions, etc. to a CSR, it's easier to pass a [configuration file](https://man.archlinux.org/man/openssl-req.1ssl.en#EXAMPLES) instead of flags (`-days`, `-subj`, `-addext`):

~~~colorized-sh
$ openssl req -utf8 -new -config ❗configfile -key 🔑private.pem -out ❗request.csr
~~~

Now sign the certificate request using a CA certificate `ca.cert` and its private key `ca-private.pem` to create a x509 certificate `certificate.cert`:

~~~colorized-sh
$ openssl x509 -req -CA ✅ca.cert -CAkey 🔑ca-private.pem -copy_extensions copyall -in ❗request.csr -out ✅certificate.cert
~~~

Note that the certificate `ca.cert` above needs the extension `basicConstraints = CA:TRUE` in order to create a valid chain to `certificate.cert` [^fnote-catrue-0] [^fnote-catrue-1].

## SSL root certificate {#selfsign-ssl}

Create a self signed (root certificate) x509 certificate `ca_root.cert` from private key `private.pem` (additional request settings as above like number of days valid are available too):

~~~colorized-sh
$ openssl req -utf8 -x509 -addext 'basicConstraints = CA:TRUE' -key 🔑private.pem -out ✅ca_root.cert
~~~



## Notes
* To list the content of a x509 certificate: `openssl x509 -noout -text -in ✅certificate.cert`
* To verify a chain $\text{CA}_0 (\rightarrow \text{CA}_1 \rightarrow \cdots \rightarrow \text{CA}_n); \rightarrow\; \text{C}$: `openssl verify -show_chain -CAfile ✅ca_0.cert [-untrusted ✅ca_i.cert] -- ✅c.cert` [^fnote-verify-ca].


[^fnote-catrue-0]: [https://stackoverflow.com/a/53951346/753850](https://stackoverflow.com/a/53951346/753850)
[^fnote-catrue-1]: [https://www.openssl.org/docs/manmaster/man5/x509v3_config.html]( https://www.openssl.org/docs/manmaster/man5/x509v3_config.html)
[^fnote-verify-ca]: [https://superuser.com/a/986177](https://superuser.com/a/986177)

\newpage
