#!/usr/bin/env car

#include <stdio.h>

int main(int argc, char *argv[])
{
  printf("Hello, world!\nThis is a C source file with the file extension '.c'.\n");
  printf("Command-line argument count: %d\n", argc - 1);
  if (argc > 1)
  {
    int i = 1;
    printf("Printing command-line arguments:\n");
    for (i = 1; i < argc; ++i)
    {
      printf("\t%s\n", argv[i]);
    }
  }
  return 0;
}
