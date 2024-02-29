# colorized-keys 🌈

🤔

## shellbox
~~~~ 
~~~shellbox { .class1 ... .classN .attribute1=value1 ... .attributeN=valueN }
~~~

~~~~

### custom shellbox markups
* `\keypriv{private.key}  | 🔑{private.key}`
* `\keypub{public.key}    | 🔒{public.key}`
* `\keypair{keypair.keys} | 🔐{keypair.keys}`
* `\userdef{identifier}   | ❗{identifier}`

# LaTeX packages:
* tcolorbox
* fancyvrb
* xcolor


## FAQ
* _Why not write a [Pandoc filter](https://pandoc.org/filters.html) instead?_ Because I thought Pandoc filters don't have access to variables, only the Pandoc JSON AST. Which is true (?). But I later realized that metadata is included in the JSON AST, and any variables declared in the documents YAML header will be available in the JSON AST as metavalues.
