---
title: Colorized Keys
author: karamellpelle@hotmail.com

data-dir: ./data-dir/colorized-keys/

fonts:
    data-dir: ./data-dir/colorized-keys/fonts/
    main:
        name: SourceSans3Light
        ext: .ttf
    sans: 
        name: SourceSans3Light
        ext: .ttf
    title:
        name: SourceSans3Light
        ext: .ttf
    mono:
        name: MesloLGSDZNerdFontPropo
        ext: .ttf

colorized_keys:
    replace:
      shellbox:
        syntax-xml: shellbox.xml
        replace:
            🔑: "ColorizeKeyPrivate"
            🔒: "ColorizeKeyPublic"
            🔐: "ColorizeKeyPair"
            ❗: "ColorizeIdentifier"

---

\includepdf[pages={1}]{colorized-front.pdf}