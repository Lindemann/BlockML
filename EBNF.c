B L O C K M L  M A R K U P  E L E M E N T

markupElement = selector block {block}.

selector = string.

block = "[" content "]".

content = {markupElement | string}.

string = UTF8Character {UTF8Character}.


B L O C K M L  E B N F

document = {textBlock | blockTag}.

textBlock = text ["LF" [paragraph]].

text = (string | inlineTag) {string | inlineTag}.

paragraph = "LF" {"LF"} textBlock.

string = UTF8Character {UTF8Character}. // character could be every UTF-8 sign and space

blockTag = tableOfContent | title | frontpage | pageBreak
           section | image | math | code | heading | list |
           quote | table | caption | bibliography | love.

inlineTag = footnote | link  | html | styleModifier |
            inlineCode | inlineMath.

/*/////////////////////////////////////////////////////////////*/

/*                           BlockTag                          */

/*/////////////////////////////////////////////////////////////*/

title = "title[" string "]".

tableOfContent = "toc[" string "]".

frontpage = "fp[" {title | heading | image } "]".

pageBreak = "pb[]".

section = "sec[" string "]""[" document "]" |
          "sec[" string "]""[" document "]""[" string "]".

heading = heading1 |...| heading6.

heading1 = "h1[" string "]". // heading2 - heading6 are equivalent

imgage = "img[" string "]""[" number "," number "]" |
		 "img[" string "]".

math = "math[" string "]".

code = "code[" string "]""[" string "]".

list = unorderedList | orderedList.

unorderedList = "ul[" {listItem | list | "LF"} "]".

orderedList = "ol[" {listItem | list | "LF"} "]".

listItem = ["-"] text.

quote =  "q[" textBlock "]""[" text "]" |
         "q[" textBlock "]".

caption = "cap[" string "]""[" text "]" |
          "cap[" string "]""[" text "]""[" string "]".

bibliography = "bib[" string "]""[" text "]".

table = "table[" {tableRow} "]".

tableRow = "tr[" {tableHeader | tableData} "]".

tableHeader = "th[" document "]""[" string "]".

tableData = "td[" document "]""[" string "]".

love = "<3[]".

/*/////////////////////////////////////////////////////////////*/

/*                         InlineTag                           */

/*/////////////////////////////////////////////////////////////*/

footnote = "fn[" text "]".

link = "a[" string "]""[" string "]" |
       "a[" string "]".

html = "html[" text "]".

inlineCode = "c[" string "]".

inlineMath = "im[" string "]".

styleModifier = bold | italic | inlineCode | marked | strikethrough | underline.

bold = "b[" string "]".

italic = "i[" string "]".

marked = "m[" string "]".

strikethrough = "s[" string "]".

underline = "u[" string "]".

identifier = "id[" string "]".
