# car [![Build Status](https://travis-ci.org/nicholaschiasson/car.svg?branch=master)](https://travis-ci.org/nicholaschiasson/car)
Compile and Run! Execute source files directly without worrying at all about compiling.

Command-line utility for quickly executing files containing code in a compiled language such as C, C++, Java, etc.

Seemlessly execute files as if they were scripts, leaving no trace of binaries behind.

## Usage
- Add *car* to a local bin directory and make sure the directory is part of your ${PATH} environment variable.

  ```
  mkdir -p "${HOME}/bin"
  mv "${HOME}/Downloads/car.sh" "${HOME}/bin/car"
  PATH="${HOME}/bin:${PATH}"
  ```

  For ease of use, paste that last line into your ```~/.profile``` or ```~/.bashrc``` or wherever makes the most sense (do some googling if you don't know what I'm talking about).
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

## Supported Languages
- C (GCC)
- C++ (G++)
- C# (Mono)
- Go
- Java
- Rust

## Notes
*car* is only a shell script; it does not ship with the capability to compile source on its own.

*car* makes use of various other compilers, but does not in its current state ship with binaries for those compilers, thus it is up to the user to download and install compilers on their own.

In a future release, perhaps an installer for *car* will be included which will be able to fetch compilers as dependencies.
