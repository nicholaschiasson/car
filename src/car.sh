#!/usr/bin/env bash

# Variable defines
SRC_FILE="$1"
SRC_FILE_BASENAME=`basename "${SRC_FILE}"`
TEMP_OUT_FILE=$(mktemp -q)
CXX=gcc

if test -t 1; then
  ncolors=$(tput colors)

  if test -n "$ncolors" && test $ncolors -ge 16; then
    color_default="$(tput sgr0)"
    color_black="$(tput setaf 0)"
    color_red="$(tput setaf 1)"
    color_green="$(tput setaf 2)"
    color_yellow="$(tput setaf 3)"
    color_blue="$(tput setaf 4)"
    color_magenta="$(tput setaf 5)"
    color_cyan="$(tput setaf 6)"
    color_light_gray="$(tput setaf 7)"
    color_gray="$(tput setaf 8)"
    color_light_red="$(tput setaf 9)"
    color_light_green="$(tput setaf 10)"
    color_light_yellow="$(tput setaf 11)"
    color_light_blue="$(tput setaf 12)"
    color_light_magenta="$(tput setaf 13)"
    color_light_cyan="$(tput setaf 14)"
    color_white="$(tput setaf 15)"
  fi
fi

function IsColor
{
  ret=false
  if [ -n "$1" ]; then
    if [ "$1" == "$color_default" ] ||
       [ "$1" == "$color_black" ] ||
       [ "$1" == "$color_red" ] ||
       [ "$1" == "$color_green" ] ||
       [ "$1" == "$color_yellow" ] ||
       [ "$1" == "$color_blue" ] ||
       [ "$1" == "$color_magenta" ] ||
       [ "$1" == "$color_cyan" ] ||
       [ "$1" == "$color_light_gray" ] ||
       [ "$1" == "$color_gray" ] ||
       [ "$1" == "$color_light_red" ] ||
       [ "$1" == "$color_light_green" ] ||
       [ "$1" == "$color_light_yellow" ] ||
       [ "$1" == "$color_light_blue" ] ||
       [ "$1" == "$color_light_magenta" ] ||
       [ "$1" == "$color_light_cyan" ] ||
       [ "$1" == "$color_white" ]
    then
      ret=true
    fi
  fi
  echo $ret
}

function ColorEcho
{
  if [ -z "$1" ]; then
    echo -e "ColorEcho: Invalid color <null> provided for first argument." >&2
  elif [ $(IsColor "$1") != true ]; then
    echo -e "ColorEcho: Invalid color '$1' provided for first argument." >&2
  else
    echo -e "$1$2$color_default"
  fi
}

function Usage()
{
  echo -e "usage:\n\tcar <source-file> [<args>]"
  Error $1 "$2"
}

function Cleanup()
{
  # Put original source file contents back in case a shebang was removed
  [ -n "${ORIGINAL_SRC_FILE_CONTENTS}" ] && echo "${ORIGINAL_SRC_FILE_CONTENTS}" > "${SRC_FILE}"
  # Remove compilation output
  [ -f "${TEMP_OUT_FILE}" ] && rm "${TEMP_OUT_FILE}"
}

function Error()
{
  Cleanup

  ERROR_MESSAGE="$2"
  if [ -z "$1" ] || [ "$(IsNumber $1)" == "true" ]; then
    EXIT_CODE=$1
  else
    EXIT_CODE=255
    ERROR_MESSAGE="$1"
  fi

  [ -n "$ERROR_MESSAGE" ] && (>&2 echo "car: $(ColorEcho $color_light_red error:) ${ERROR_MESSAGE}")
  exit $EXIT_CODE
}

function IsNumber()
{
  if [ -n "$1" ] && [[ $1 =~ ^[0-9]+$ ]]; then
    echo true
  else
    echo false
  fi
}

## Begin main procedure

# Require source file
([ -n "${SRC_FILE}" ] && [ -f "${SRC_FILE}" ]) || Usage 1 "must provide <source-file>"

# Look for shebang and remove it from original source, caching the original source to put back later
ORIGINAL_SRC_FILE_CONTENTS=`cat "${SRC_FILE}"`
NEW_SRC_FILE_CONTENTS=`sed -e 's/^#!.*$//g' "${SRC_FILE}"` || Error 2 "failed sed operation on '${SRC_FILE}'"
echo "${NEW_SRC_FILE_CONTENTS}" > "${SRC_FILE}"

# Determine compiler to use based on file extension
case "${SRC_FILE_BASENAME##*.}" in
  c)
    CXX=gcc
    ;;
  cc | cpp)
    CXX=g++
    ;;
  *)
    Error 3 "unsupported source file type; no compiler for '${SRC_FILE_BASENAME##*.}' files"
esac

# Perform compilation
${CXX} "${SRC_FILE}" -o "${TEMP_OUT_FILE}" || Error 4 "failed to compile '${SRC_FILE}' using ${CXX}"

# Execute ouput file passing any extra command-line arguments
"${TEMP_OUT_FILE}" ${@:2} || Error 5 "'${SRC_FILE}' failed with exit code $?"

# Exit with success
Error 0
