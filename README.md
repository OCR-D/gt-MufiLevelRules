# keyboardGT

The Aletheia document image analysis system, Transkribus, LAREX, QURATOR-neat and eScriptorium offer the possibility to install additional virtual keyboards or to customize them.
This repository offers about 80 keyboards based on the [MUFI snapshot](https://mufi.info/m.php?p=mufiexport) for download on the [Github page](https://tboenig.github.io/keyboardGT/overview.html).

## Download your Keyboard

You can download the suitable keyboard here.
### 🖮  https://tboenig.github.io/keyboardGT/overview.html 🖮


## In-house Keyboard Production

The production of the keyboards is done automatically. 
An XSLT stylesheet and a Github action workflow are used.

If you want to create the keyboard on your computer 
- an XSLT processor is installed (Saxon is recommended)
- clone the repo and 
- the following command is necessary.

**For Aletheia**
`java -jar saxon-he.jar -xsl:scripts/keyboard.xsl output=keyboards -s:scripts/keyboard.xsl `

**For Transkribus**
`java -jar saxon-he.jar -xsl:scripts/keyboard.xsl output=tkeyboards -s:scripts/keyboard.xsl `

**For LAREX**
`java -jar saxon-he.jar -xsl:scripts/keyboard.xsl output=lkeyboards -s:scripts/keyboard.xsl `

**For QURATOR-neat**
`java -jar saxon-he.jar -xsl:scripts/keyboard.xsl output=qkeyboards -s:scripts/keyboard.xsl `

**For eScriptorium**
`java -jar saxon-he.jar -xsl:scripts/keyboard.xsl output=ekeyboards -s:scripts/keyboard.xsl `


📝 Note: The keyboards are stored in the folder `ghout/keyboards` on your system.

## See Also

- MUFI: The Medieval Unicode Font Initiative https://mufi.info/
- Aletheia https://www.primaresearch.org/tools/Aletheia
- Transkribus https://readcoop.eu/transkribus/
- LAREX https://github.com/OCR4all/LAREX
- QURATOR-neat https://github.com/qurator-spk/neat
- eScriptorium https://gitlab.com/scripta/escriptorium
- Saxon https://www.saxonica.com/welcome/welcome.xml
