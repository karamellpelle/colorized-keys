---
title: Colorized Keys
author: karamellpelle@hotmail.com

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

urlcolor: Blue
urlstyle: tt

colorized-keys:
    languages:
      color:
        syntax: color
        style:  color-doesnotworkyet
        # ^ FIXME: this can be added as appedix/prefix to tokens, after creating macros using styleToLaTeX/HTML.
        #          for example: KeywordTok -> KeywordTok#color
        #          currently set in pandoc-defaults.yaml
        map:
            🔑: "ColorizeKeyPrivate"
            🔒: "ColorizeKeyPublic"
            🔐: "ColorizeKeyPair"
            ❗: "ColorizeIdentifier"
            ✅: "ColorizeCertificate"

---

\backgroundimage{front.pdf}

