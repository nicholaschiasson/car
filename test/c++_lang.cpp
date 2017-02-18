#!/usr/bin/env car

#include <iostream>

using namespace std;

int main(int argc, char *argv[])
{
  cout << "Hello, world!" << endl << "This is a C++ source file with the file extension '.cpp'." << endl;
  return (argc > 1 ? atoi(argv[1]) : 0);
}
