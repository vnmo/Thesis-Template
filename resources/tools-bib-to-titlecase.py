#!/usr/bin/env python
#
# Original by Daniel L. Greenwald
# http://dlgreenwald.weebly.com/blog/capitalizing-titles-in-bibtex
# Modified by Garrett Dash Nelson
# https://gist.github.com/garrettdashnelson/af0f8307393da37c6f94eda8c4613a4f
#
# Modified by Manuel Olguín Muñoz
#
# Modified by Vishnu: 
# (1) Updated incorrect changing of, for example IEEE to Ieee by protecting acronyms 
# (2) Updated Regex pattern by additing multiple options () to choose from. 

# # RECOMMENDED BIBTEX TIDYING
# While not mandatory, it is strongly RECOMMENDED to use bibtex tidy before running this.
# Goto https://flamingtempura.github.io/bibtex-tidy to do this with multiple configurations and de-duplication options.
# A simple tidying can be done by the below code. it SHOWS duplicates but DOES NOT handle them.
# bibtex-tidy --curly --numeric --tab --align=13 --sort=key,title,author,year --duplicates=key,doi,citation --strip-enclosing-braces --no-escape --sort-fields --remove-empty-fields --no-remove-dupe-fields YOUR_FILE.bib

# Usage : python bib-to-titlecase.py resources/references_input.bib -o resources/references_output.bib

import io
import re
from collections import deque
from typing import Sequence

import click as click
from titlecase import titlecase

# # Match title, Title, booktitle, Booktitle fields
# # OLD Strictly matches title = {…} (single spaces on either side of =)
# pattern = re.compile(r'(\W*)([Bb]ook)?([Tt]itle = {+)(.*)(}+,)')

# # ONEW Option 1: In addition to above handles arbitrary spaces, tabs
# pattern = re.compile(r'(\W*)([Bb]ook)?([Tt]itle\s*=\s*{+)(.*?)(}+,)')

# # ONEW Option 2: In addition to above handles "mytitle" along with standard {mytitle}
# pattern = re.compile(r'(\W*)([Bb]ook)?([Tt]itle = {+)(.*)(}+,)')

# # NEW Option 3: In addition to above handles "mytitle" along with standard {mytitle}
# pattern = re.compile(r'(\W*)([Bb]ook)?([Tt]itle = {+)(.*)(}+,)')

# # # # NEW Option 3: In addition to above make journal field title case
pattern = re.compile(
    r'(\W*)'
    r'([Bb]ook)?'
    r'('
        r'[Tt]itle\s*=\s*(?:{+|")'
        r'|'
        r'[Jj]ournal(?:[Tt]itle)?\s*=\s*(?:{+|")'
    r')'
    r'(.*?)'
    r'(?:}+",|}+,|",)'
)

# Shield acronyms like IEEE, INFOCOM, 3GPP, CNN-LSTM
ACRONYM_TOKEN = re.compile(r'(?<!{)\b(?=[A-Z0-9-]*[A-Z])[A-Z0-9-]{2,}\b(?!})')

# Leave tokens like {IEEE}, {INFOCOM}, {3GPP}, {CNN-LSTM} unchanged in titlecase()
BRACED_SINGLE = re.compile(r'^\{[A-Za-z0-9-]+\}$')
def keep_braced(word: str, **kwargs):
    # If the "word" is exactly a single braced token, return it unchanged
    if BRACED_SINGLE.match(word):
        return word
    return None

# global set to remember all acronyms we shielded
SHIELDED = set()
def protect_acronyms(s: str) -> str:
    # Wrap ALL-CAPS/digit/hyphen tokens (len>=2, with at least one A-Z) in braces,  unless already braced.
    def replace_token(m: re.Match) -> str:
        token = m.group(0)
        SHIELDED.add(token)  # track unique new shields
        return '{' + token + '}'
    return ACRONYM_TOKEN.sub(replace_token, s)

class LineError(Exception):
    def __init__(self, num: int, line: str):
        super().__init__(f"Error in line num {num:d} (line: \"{line}\")")


def to_titlecase(lines: Sequence[str]) -> Sequence[str]:
    # Search for title strings and replace with titlecase
    new_lines = deque()
    for line_num, line in enumerate(lines):
        # Check if line contains title
        match_obj = pattern.match(line)
        if match_obj is not None:
            try:
                # Need to "escape" any special chars to avoid misinterpreting them in the regular expression.
                old_title = re.escape(match_obj.group(4))

                # Apply titlecase to get the correct title.
                raw = match_obj.group(4) # NEW: protect acronyms before titlecasing
                new_title = titlecase(protect_acronyms(raw), callback=keep_braced)            

                # Replace and add to list
                p_title = re.compile(old_title)
                newline = p_title.sub(new_title, line)
            except Exception as e:
                raise LineError(line_num, line) from e

            new_lines.append(newline)
        else:
            # If not title, add as is.
            new_lines.append(line)

    return new_lines


@click.command
@click.argument("input-file", type=click.File())
@click.option("-o", "--output-file", type=click.File(mode="w", lazy=True, atomic=True), default="-", show_default=True)
def main(input_file: io.StringIO, output_file: io.StringIO):
    output_file.writelines(to_titlecase(input_file.readlines()))
    if SHIELDED:
        print("\n\n[INFO] The following acronyms are detected and shielded (if not already shielded with {..}):"
            "Showing unique values; duplicates may exist in the file:\n")
        print(", ".join(sorted(SHIELDED)))
        print("\n[INFO] These acronyms are shielded but otherwise unmodified in the output.")


if __name__ == '__main__':
    main()
