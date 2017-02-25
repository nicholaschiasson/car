#!/usr/bin/env bash

# Variable defines
CWD="${PWD}"
SRC_FILE="$1"
SRC_FILE_BASENAME=$(basename "${SRC_FILE}" 2> /dev/null)
TEMP_OUT_FILE=$(mktemp -q)
TEMP_OUT_DIR=$(mktemp -qd)
TEMP_SRC_FILE="${TEMP_OUT_DIR}/${SRC_FILE_BASENAME}"
CXX=gcc
CXX_OUTPUT_FLAG=-o
VM=
PRERUN=
POSTRUN=

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
  echo -e "$1$2$color_default"
}

function Usage()
{
  echo -e "usage:\n\tcar <source-file> [<args>]"
  Error $1 "$2"
}

function Cleanup()
{
  # Remove cloned source file and compilation output
  rm -rf "${TEMP_SRC_FILE}"
  rm -rf "${TEMP_OUT_FILE}"
  rm -rf "${TEMP_OUT_DIR}"
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

  [ -n "$ERROR_MESSAGE" ] && (>&2 echo "car: "$(ColorEcho "${color_light_red}" error:)" ${ERROR_MESSAGE}")
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

# TODO: Parse arguments using getopts
# Accept -h argument for usage
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  Usage 0
fi

# Require source file
([ -n "${SRC_FILE}" ] && [ -f "${SRC_FILE}" ]) || Usage 1 "must provide valid <source-file>"

# Copy source file contents to temp source file
rm -rf "${TEMP_SRC_FILE}"
cp -f "${SRC_FILE}" "${TEMP_SRC_FILE}"

# Look for shebang and remove it from temp source
NEW_SRC_FILE_CONTENTS=`sed -e 's/^#!.*$//g' "${TEMP_SRC_FILE}"` || Error 2 "failed sed operation on '${SRC_FILE_BASENAME}'"
echo "${NEW_SRC_FILE_CONTENTS}" > "${TEMP_SRC_FILE}"

# Determine compiler to use based on file extension
case "${SRC_FILE_BASENAME##*.}" in
  c)
    CXX=gcc
    CXX_OUTPUT_FLAG=-o
    VM=
    ;;
  cc | cpp)
    CXX=g++
    CXX_OUTPUT_FLAG=-o
    VM=
    ;;
  cs)
    CXX=mcs
    CXX_OUTPUT_FLAG=-out:
    VM=mono
    ;;
  go)
    CXX="go build"
    CXX_OUTPUT_FLAG="-o "
    VM=
    ;;
  java)
    # Need to do some weird things for Java since the .class files need to have the same name as the class they contain.
    # Also, Java programs need to be run from the root of their packages.
    rm -rf "${TEMP_OUT_FILE}"
    TEMP_OUT_FILE="${TEMP_OUT_DIR}"
    CXX=javac
    CXX_OUTPUT_FLAG="-d "
    VM=java
    JAVA_CLASS_NAME=${TEMP_SRC_FILE%.java}
    JAVA_PACKAGE=$(sed -n -e 's/^package \(.*\);$/\1/p' "${TEMP_SRC_FILE}")
    [ -n "${JAVA_PACKAGE}" ] && JAVA_PACKAGE="${JAVA_PACKAGE}."
    PRERUN='cd "${TEMP_OUT_DIR}"; TEMP_OUT_FILE="${JAVA_PACKAGE}"$(basename "${JAVA_CLASS_NAME}")'
    POSTRUN='cd "${CWD}"'
    ;;
  rs)
    CXX=rustc
    CXX_OUTPUT_FLAG=-o
    VM=
    ;;
  *)
    Error 3 "unsupported source file type; no compiler for '${SRC_FILE_BASENAME##*.}' files"
esac

# Perform compilation
${CXX} ${CXX_OUTPUT_FLAG}"${TEMP_OUT_FILE}" "${TEMP_SRC_FILE}" || Error 4 "failed to compile '${SRC_FILE_BASENAME}' using ${CXX}"

# Optional pre-run commands
eval "${PRERUN}"

# Execute ouput file passing any extra command-line arguments
${VM} "${TEMP_OUT_FILE}" ${@:2} || Error 5 "'${SRC_FILE_BASENAME}' failed with exit code $?"

# Optional post-run commands
eval "${POSTRUN}"

# Exit with success
Error 0
