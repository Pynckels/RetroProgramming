#! /usr/bin/bash

DIR_SCRIPT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

TIMESTAMP="$(date +%Y%m%d%H%M%S)"

FILE_LPT1="$DIR_SCRIPT/lpt/lpt1/dosbox-x.lpt1.bin"
FILE_PDF1="$DIR_SCRIPT/lpt/lpt1/dosbox-x.lpt1.$TIMESTAMP.pdf"

FILE_LPT2="$DIR_SCRIPT/lpt/lpt2/dosbox-x.lpt2.bin"
FILE_PDF2="$DIR_SCRIPT/lpt/lpt2/dosbox-x.lpt2.$TIMESTAMP.pdf"

PRT1403="$HOME/.local/bin/prt1403"

# LPT1 : print predefined header

if [[ -f "$FILE_LPT1" ]]; then
    "$PRT1403" -c GREEN -d DMY -e -i LPT1 -j RETROPRG -o "$FILE_PDF1" -s WIDE -u DOSBOX -y "$FILE_LPT1"
    rm "$FILE_LPT1"
fi

# LPT2 : print without header and without separator

if [[ -f "$FILE_LPT2" ]]; then
    "$PRT1403" -c GREEN -n -o "$FILE_PDF2" -s WIDE -y "$FILE_LPT2"
    rm "$FILE_LPT2"
fi
