#! /usr/bin/bash

# -------------------------------------------------------------------
# Adjust the PRT1403 directory (dosbox-x does not use $PATH)
# -------------------------------------------------------------------

PRT1403="$HOME/.local/bin/prt1403"

# -------------------------------------------------------------------

DIR_SCRIPT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"

# -------------------------------------------------------------------
# Usage message
# -------------------------------------------------------------------

usage() {
    echo "usage: $(basename "$0") [--clean | --open]"
    echo ""
    echo "Handle dosbox-x print commands."
    echo ""
    echo "options:"
    echo "  -c, --clean   Delete all printed files"
    echo "  -o, --open    Open all printed files with a pdf viewer"
}

# -------------------------------------------------------------------
# print file $1 to printer number $2
# -------------------------------------------------------------------

print_file() {
    local lpt="$2"
    local pdf="$DIR_SCRIPT/lpt/lpt$lpt/dosbox-x.lpt$lpt.$TIMESTAMP.pdf"
    local in="$1"

    case "$lpt" in
        1) "$PRT1403" -c GREEN -d DMY -e -i LPT1 -j RETROPRG -o "$pdf" -s WIDE -u DOSBOX -y "$in" ;;
        2) "$PRT1403" -c GREEN -n -o "$pdf" -s WIDE -y "$in" ;;
        3) "$PRT1403" -c WHITE -n -o "$pdf" -s MEDIUM -y "$in" ;;
        4) "$PRT1403" -c WHITE -n -o "$pdf" -s SMALL -y "$in" ;;
        *) echo "Insert print command to print $1 on printer $2"
           echo "All printers are silent... No LPT files found. Even the paperclip is unemployed!"
           ;;
    esac
    rm -f "$in"
}

# -------------------------------------------------------------------
# More or less than 1 parameter: exit with error
# -------------------------------------------------------------------

if [ "$#" -ne 1 ]; then
    usage
    exit 1
fi

# -------------------------------------------------------------------
# 1 parameter
# -------------------------------------------------------------------

case "$1" in

    -c|--clean)
		# Erase all bin and pdf files in $DIR_SCRIPT/lpt/lpt1 ... $DIR_SCRIPT/lpt/lpt9
        for dir in "$DIR_SCRIPT"/lpt/lpt[1-9]; do
            [ -d "$dir" ] || continue
            find "$dir" -type f \( -iname '*.pdf' -o -iname '*.bin' \) -delete
        done
        exit 0
        ;;

	-o|--open)
		# Open all pdf files in $DIR_SCRIPT/lpt/lpt1 ... $DIR_SCRIPT/lpt/lpt9
		for dir in "$DIR_SCRIPT"/lpt/lpt[1-9]; do
			[ -d "$dir" ] || continue
			find "$dir" -type f -iname '*.pdf' -print0 |
			while IFS= read -r -d '' file; do
				setsid -f open "$file" < /dev/null > /dev/null 2>&1
			done
		done
		exit 0
		;;

	*)
        # The only parameter should be an existing file: execute dosbox-x print logic
        if [ ! -f "$1" ]; then
            echo "File not found: $1" >&2
            exit 1
        fi

        # Extract the port number from the file name, e.g. dosbox-x.lpt4.bin -> 4
        name="${1##*/}"
        lpt="${name#dosbox-x.lpt}"
        lpt="${lpt%.bin}"

        if [[ "$name" == dosbox-x.lpt*.bin && "$lpt" =~ ^[1-9]$ ]]; then
            print_file "$1" "$lpt"
            exit 0
        else
            echo "Unrecognized print file: $1" >&2
            exit 1
        fi
        ;;

esac
