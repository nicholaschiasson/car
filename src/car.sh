#!/usr/bin/env bash

function usage()
{
  echo -e "usage:\n\tcar <source-file> [<args>]"
  exit $1
}

[ -n "$1" ] || usage 1

SRC_FILE="$1"
TEMP_OUT_FILE=$(mktemp -q)

gcc "${SRC_FILE}" -o "${TEMP_OUT_FILE}"

"${TEMP_OUT_FILE}" ${@:2}

rm "${TEMP_OUT_FILE}"
