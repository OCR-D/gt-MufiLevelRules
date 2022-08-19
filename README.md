# gt-MufiLevelRules

OCR-D-Level-Rules can be created automatically with **gt-MufiLevelRules** from the encodings published by [MUFI: The Medieval Unicode Font Initiative](https://mufi.info/m.php?p=mufi). The OCR-D level rules conform to the OCR-D specification. 
These rules can be used for substitutions or level checks, among other things. 
It should be noted 
- Especially in level 1, there may be no definitions. OCR-D tries to correct these places manually. 
- For this reason, use for automatic character normalization from Level 3 or Level 2 to Level 1 is not possible before a manual check of the corresponding rule or a manual correction.

## Validity of the rules:

Rules are automatically created with gt-MufiLevelRules. 
The following rules have priority over the rules created by gt-MufiLevelRules.
- ruleset_character.json
- ruleset_hyphenation.json
- ruleset_ligature.json
- ruleset_roman_digits.json 

These rules can be found under: 
- https://github.com/tboenig/gt-guidelines/tree/gh-pages/rules


## Description of the rules
**Example:**

```
 {"ruleset":[
       {"rule": ["a", "a", "a"], "type": "level"}
]}
```

- The rule starts with: rule
- Three rules are defined:
  - Level 1 is at the first position
  - Level 2 is in the second place
  - Level 3 is in the third place
- There can be blanks (level). In this case, there is no level definition. 

## Notes for in-house production:
- Saxon XSLT Transformer (https://www.saxonica.com/download/download_page.xml) is installed on the computer.
- Since external resources are requested and evaluated with the program, the computer must be connected to the Internet.
  - The external resources can be found at: https://mufi.info/m.php?p=mufiexport

Start the conversion: `java -jar saxon-he.jar -xsl:MufiGTLevelRules.xsl -s:MufiGTLevelRules.xsl`

- The result of the conversion can be found in the directory: [directory]/rules/characters


## See Also
- Ground truth level overview https://ocr-d.de/en/gt-guidelines/trans/trLevels.html
- MUFI: The Medieval Unicode Font Initiative https://mufi.info/
- MUFI’s data as json https://mufi.info/m.php?p=mufiexport
- OCR-D-Ground-Truth-Guidelines  https://ocr-d.de/en/gt-guidelines/trans/
