#!/usr/bin/env bash

SRC_FILE="$1"
TEMP_OUT_FILE=$(mktemp -q)

function usage()
{
  echo -e "usage:\n\tcar <source-file> [<args>]"
  error $1
}

function error()
{
  [ -n "${ORIGINAL_SRC_FILE_CONTENTS}" ] && echo "${ORIGINAL_SRC_FILE_CONTENTS}" > "${SRC_FILE}"
  [ -f "${TEMP_OUT_FILE}" ] && rm "${TEMP_OUT_FILE}"
  exit $1
}

([ -n "${SRC_FILE}" ] && [ -f "${SRC_FILE}" ]) || usage 1

ORIGINAL_SRC_FILE_CONTENTS=`cat "${SRC_FILE}"`

NEW_SRC_FILE_CONTENTS=`sed -e 's/^#!.*$//g' "${SRC_FILE}"` || error 2

echo "${NEW_SRC_FILE_CONTENTS}" > "${SRC_FILE}"

gcc "${SRC_FILE}" -o "${TEMP_OUT_FILE}" || error 3

"${TEMP_OUT_FILE}" ${@:2} || error 4

error 0
