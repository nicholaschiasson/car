# car
[![Build Status](https://travis-ci.org/nicholaschiasson/car.svg?branch=master)](https://travis-ci.org/nicholaschiasson/car)

Compile and Run! Execute source files directly without worrying at all about compiling.

Command-line utility for quickly executing files containing code in a compiled language such as C, C++, Java, etc.

Seamlessly execute files as if they were scripts, leaving no trace of binaries behind.

## Installation
To install *car* enter the following command into a terminal:

```
sudo curl -sL "$(curl -s https://api.github.com/repos/nicholaschiasson/car/releases/latest | sed -n -e 's/^.*"browser_download_url": "\(.*\)"$/\1/p')" | sh
```

## Usage
- Make sure that the containing directory of *car* is present in your ${PATH} environment variable
- Write some code (check out the supported languages below)
- Unless you want to execute your file explicitly using ```car example.c```, add a *shebang* to the top of your source file like so:

  ```
  #!/usr/bin/env car
  ```
- Change the permissions of the file to be executable

  ```
  chmod ugo+x example.c
  ```
- Run your source file like it were its own program or a script file

  ```
  ./example.c
  ```
- As mentioned, if you plan to execute the file using the *car* program explicitly, forget about the *shebang* and changing the file permissions.

![](https://github.com/nicholaschiasson/car/raw/master/res/example_usage.gif)

## Supported Languages
- C (GCC)
- C++ (G++)
- C# (Mono)
- Go
- Java
- Rust

## Supported Operating Systems
- Linux
- Mac OS X
- Windows? (Windows subsystem for Linux)
  - Untested, but presumably the script should work on any Bash shell on a system that is supported by the compilers listed above, so my bet is that Windows is fair game (even though it's not really Windows...)
  - Could maybe get it to work on Cygwin or MinGW too

## Notes
*car* is only a shell script; it does not ship with the capability to compile source on its own.

*car* makes use of various other compilers, but does not in its current state ship with binaries for those compilers, thus it is up to the user to download and install compilers on their own.

In a future release, perhaps an installer for *car* will be included which will be able to fetch compilers as dependencies.
