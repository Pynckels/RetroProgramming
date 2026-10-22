#! /usr/bin/bash

DIR_SCRIPT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

TIMESTAMP="$(date +%Y%m%d%H%M%S)"

FILE_LPT1="$DIR_SCRIPT/lpt/lpt1/dosbox-x.lpt1.bin"
FILE_PDF1="$DIR_SCRIPT/lpt/lpt1/dosbox-x.lpt1.$TIMESTAMP.pdf"

FILE_LPT2="$DIR_SCRIPT/lpt/lpt2/dosbox-x.lpt2.bin"
FILE_PDF2="$DIR_SCRIPT/lpt/lpt2/dosbox-x.lpt2.$TIMESTAMP.pdf"

FILE_LPT3="$DIR_SCRIPT/lpt/lpt3/dosbox-x.lpt3.bin"
FILE_PDF3="$DIR_SCRIPT/lpt/lpt3/dosbox-x.lpt3.$TIMESTAMP.pdf"

FILE_LPT4="$DIR_SCRIPT/lpt/lpt4/dosbox-x.lpt4.bin"
FILE_PDF4="$DIR_SCRIPT/lpt/lpt4/dosbox-x.lpt4.$TIMESTAMP.pdf"

FILE_LPT5="$DIR_SCRIPT/lpt/lpt5/dosbox-x.lpt5.bin"
FILE_PDF5="$DIR_SCRIPT/lpt/lpt5/dosbox-x.lpt5.$TIMESTAMP.pdf"

FILE_LPT6="$DIR_SCRIPT/lpt/lpt6/dosbox-x.lpt6.bin"
FILE_PDF6="$DIR_SCRIPT/lpt/lpt6/dosbox-x.lpt6.$TIMESTAMP.pdf"

FILE_LPT7="$DIR_SCRIPT/lpt/lpt7/dosbox-x.lpt7.bin"
FILE_PDF7="$DIR_SCRIPT/lpt/lpt7/dosbox-x.lpt7.$TIMESTAMP.pdf"

FILE_LPT8="$DIR_SCRIPT/lpt/lpt8/dosbox-x.lpt8.bin"
FILE_PDF8="$DIR_SCRIPT/lpt/lpt8/dosbox-x.lpt8.$TIMESTAMP.pdf"

FILE_LPT9="$DIR_SCRIPT/lpt/lpt9/dosbox-x.lpt9.bin"
FILE_PDF9="$DIR_SCRIPT/lpt/lpt9/dosbox-x.lpt9.$TIMESTAMP.pdf"

PRT1403="$HOME/.local/bin/prt1403"

# LPT1 : print 132 width with predefined header and with separator page

if [[ -f "$FILE_LPT1" ]]; then
    "$PRT1403" -c GREEN -d DMY -e -i LPT1 -j RETROPRG -o "$FILE_PDF1" -s WIDE -u DOSBOX -y "$FILE_LPT1"
    rm "$FILE_LPT1"
fi

# LPT2 : print 132 width without header and without separator page

if [[ -f "$FILE_LPT2" ]]; then
    "$PRT1403" -c GREEN -n -o "$FILE_PDF2" -s WIDE -y "$FILE_LPT2"
    rm "$FILE_LPT2"
fi

# LPT3 : print 80 width without header and without separator page

if [[ -f "$FILE_LPT3" ]]; then
    "$PRT1403" -c GREEN -n -o "$FILE_PDF3" -s SMALL -y "$FILE_LPT3"
    rm "$FILE_LPT3"
fi

# LPT4

if [[ -f "$FILE_LPT4" ]]; then
    echo "Insert print command to print $FILE_LPT4"
    rm "$FILE_LPT4"
fi

# LPT5

if [[ -f "$FILE_LPT5" ]]; then
    echo "Insert print command to print $FILE_LPT5"
    rm "$FILE_LPT5"
fi

# LPT6

if [[ -f "$FILE_LPT6" ]]; then
    echo "Insert print command to print $FILE_LPT6"
    rm "$FILE_LPT6"
fi

# LPT7

if [[ -f "$FILE_LPT7" ]]; then
    echo "Insert print command to print $FILE_LPT7"
    rm "$FILE_LPT7"
fi

# LPT8

if [[ -f "$FILE_LPT8" ]]; then
    echo "Insert print command to print $FILE_LPT8"
    rm "$FILE_LPT8"
fi

# LPT9

if [[ -f "$FILE_LPT9" ]]; then
    echo "Insert print command to print $FILE_LPT9"
    rm "$FILE_LPT9"
fi
