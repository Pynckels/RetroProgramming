#! /usr/bin/bash

DIR_SCRIPT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
FILE_CONF="$DIR_SCRIPT/dosbox-x.conf"
FILE_CONF_UPDATED="$DIR_SCRIPT/dosbox-x.updated.conf"

sed "s|~/retroprogramming|${DIR_SCRIPT%/}|g" "$FILE_CONF" > "$FILE_CONF_UPDATED"

pushd "$DIR_SCRIPT" > /dev/null
dosbox-x -conf "$FILE_CONF_UPDATED" -defaultdir "$DIR_SCRIPT" -nopromptfolder &
popd > /dev/null
