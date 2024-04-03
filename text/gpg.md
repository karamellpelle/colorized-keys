# GPG {#gpg}
\kant[1]

```colorized-sh
> # set hostname. FIXME
> HOSTNAME=my.domain.net 
> # see https://github.com/karamellpelle/ 
> ssh-keygen -h -s 🔑ca_key -I "$CERTIFICATE_ID" -n "$HOSTNAME" -V $CERTIFICATE_VALID -z $CERTIFICATE_SERIAL 🔒ssh_host_xxx_key.pub
> ssh-keygen -h -s 🔑ca_key | cat --pretty | tree -d 
> openssl pkey -in 🔑9x_private.pem -pubout -out 🔒9x_public.pem
> ykman piv keys import --pin-policy DEFAULT --touch-policy DEFAULT [--password <password>] ❗9X 🔑9x_private.pem
> 🔑my-long-name
> 🔑[my spaced name]
> 🔑[] <- empty name
> ^ testing
```

#### Yubico GPG {#yubico-gpg}
FIXME: link to above
\kant[22]

## create {#create-gpg}
\kant[2]

## sign {#sign-gpg-gpg}
\kant[3]

