# section
\lipsum[1]


```shellbox
$ # set hostname
$ HOSTNAME=my.domain.net 
$ # see https://github.com/karamellpelle/ 
$ ssh-keygen -h -s 🔑ca_key -I "$CERTIFICATE_ID" -n "$HOSTNAME" -V $CERTIFICATE_VALID -z $CERTIFICATE_SERIAL 🔒ssh_host_xxx_key.pub
$ openssl pkey -in 🔑9x_private.pem -pubout -out 🔒9x_public.pem
$ ykman piv keys import --pin-policy DEFAULT --touch-policy DEFAULT [--password <password>] ❗9X 🔑9x_private.pem
$ ls ❗[this is secret] 🔑[9x is also private]
$ # comment
$ 🔐[can this] work?
$ # testing
$ 🔑my-long-name
$ 🔑[my spaced name]
$ 🔑[] <- empty name
```


## section section {#inject-ssh-ssl}
\lipsum[1] 


```sh
$ # set hostname
$ HOSTNAME=my.domain.net 
$ # see https://github.com/karamellpelle/ 
$ ssh-keygen -h -s ca_key -I "$CERTIFICATE_ID" -n "$HOSTNAME" -V $CERTIFICATE_VALID -z $CERTIFICATE_SERIAL ssh_host_xxx_key.pub
$ openssl pkey -in 9x_private.pem -pubout -out 9x_public.pem
$ ykman piv keys import --pin-policy DEFAULT --touch-policy DEFAULT [--password <password>] 9X 9x_private.pem
$ 😄 
```

```default
😄 
🤗
😚
```


### section section section {#inject-apple-dog}
\lipsum[1]

~~~~ {#mycode .haskell .numberLines startFrom="100"}
qsort []     = []
qsort (x:xs) = qsort (filter (< x) xs) ++ [x] ++
               qsort (filter (>= x) xs)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#### section section section section 
\lipsum[1]

~~~~ {#mycode1 .haskell .numberLines startFrom="100"}
qsort []     = []
qsort (x:xs) = qsort (filter (< x) xs) ++ [x] ++
               qsort (filter (>= x) xs)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
