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

colorized-keys:
    languages:
      colorized-sh:
        syntax: colorized-sh
        style:  colorized-sh-doesnotworkyet
        # ^ FIXME: this can be added as appedix/prefix to tokens, after creating macros using styleToLaTeX/HTML.
        #          for example: KeywordTok -> KeywordTok#colorized-sh
        #          currently set in pandoc-defaults.yaml
        map:
            🔑: "ColorizeKeyPrivate"
            🔒: "ColorizeKeyPublic"
            🔐: "ColorizeKeyPair"
            ❗: "ColorizeIdentifier"

---

\backgroundimage{front.pdf}

