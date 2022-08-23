# gt-MufiLevelRules

Creates OCR-D Ground-Truth Transcription Level Rules automatically from the encodings published by [MUFI: The Medieval Unicode Font Initiative](https://mufi.info/m.php?p=mufi). 

The resulting OCR-D level rules conform to the [OCR-D specification](https://ocr-d.de/en/gt-guidelines/trans/transkription.html). 
These rules can be used for substitutions or level checks, among other things. 

Note:
- There may not always be a definition for every level, esp. on level 1. OCR-D will try to correct these gaps manually. 
- For this reason, using the rules for automatic character normalization from level 3 or level 2 to level 1
  is currently not recommended before manually checking and correcting the corresponding rules.

## Recreation of the rules

Since external resources are requested and evaluated by the program, the computer must be connected to the Internet.

Install [Saxon](https://www.saxonica.com/download/download_page.xml) for XSL Transformations v3.0. Then simply run with `MufiGTLevelRules.xsl`:

    java -jar saxon-he.jar -xsl:MufiGTLevelRules.xsl -s:MufiGTLevelRules.xsl
 
The result of the conversion can be found in the directory: ``[directory]/rules/characters``.

This will:

1. Extract the [MUFI rules](https://mufi.info/m.php?p=mufiexport) (and place them into `rules/characters/*.json`).

2. Merge with the following **additional rules** (from the OCR-D Ground-Truth Transcription Guide](https://ocr-d.de/en/gt-guidelines/trans/trBeispiele.html), which have priority (take precendence over MUFI rules where applicable):
- [ruleset_character.json](https://github.com/tboenig/gt-guidelines/blob/gh-pages/rules/ruleset_character.json)
- [ruleset_hyphenation.json](https://github.com/tboenig/gt-guidelines/blob/gh-pages/rules/ruleset_hyphenation.json)
- [ruleset_ligature.json](https://github.com/tboenig/gt-guidelines/blob/gh-pages/rules/ruleset_ligature.json)
- [ruleset_roman_digits.json](https://github.com/tboenig/gt-guidelines/blob/gh-pages/rules/ruleset_roman_digits.json)

3. Output to `megarules.json`.

## Description of the rules
All JSON files (both the pure MUFI rules and the final result) follow the same schema.

**Example:**

```JSON
 {"ruleset":[
       ...
       {"rule": ["ä", "aͤ", ""], "type": "level"}
       ...
]}
```

- Each rule has a key: `rule` and a list of values
- The values define the character representation on each of the 3 transcription levels:
  - Level 1 is at the first position
  - Level 2 is in the second place
  - Level 3 is in the third place
- Additional key-value combinations: ...
- Character values can be empty to signify there is no definition (representation) at that level.

## See Also

- MUFI: The Medieval Unicode Font Initiative https://mufi.info/
- MUFI's data as JSON export https://mufi.info/m.php?p=mufiexport
- OCR-D Ground Truth Transcription Guidelines  https://ocr-d.de/en/gt-guidelines/trans/
- Ground Truth level overview https://ocr-d.de/en/gt-guidelines/trans/trLevels.html
