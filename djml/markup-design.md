<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">

# GENERAL

* micro-markup of structured (stanzaic) poetry and poetic translation
* single curly brackets are for structural markup (stanzas, titles, etc.) and alignment
* double curly brackets are for translator comments

# DEFINITIONS

* **comments**: are what translators add
* **descants**: stuff ignored by djml (analogous to code comments in programming languages)

# COMMENTS

*  fragment vs pointed (byref)
*  comment types
  *    e.g.: `dignissim ante lacinia {{<b>Вася Петров</b> | Великий русский поэт. |azangru> прибл. 1800—1855. |azimov> Возможно, Петя. |wrp> Не исключено, что Коля}}. Sed euismod facilisis
    pointed comments are assigned ids within a stanza`
*  "consensus" is the default type

# CHALLENGES/REQURIEMENTS

##  CH1: опознавать строфу, отделять "номер" от текста строфы (варианты нумерации строф: арабские, римские, др.)

* the beginning of a stanza is implicitly recognized as text following a double NL or the beginning of the file
* the beginning of a stanza is explicitly recognized as text following a stanza header:
      `{text}NL`
*    the end of a stanza is implicitly marked by one or more NLs or EOF
*    the end of a stanza can be explicitly marked by `{_^_}`

##  CH2: parallel texts and alignment (sources and translations)

##  CH3: nested fragment comments

##  CH4: a fragment comment begins in one stanza and ends in another

