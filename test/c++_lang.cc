#!/usr/bin/env car

#include <iostream>
#include <cstdlib>

using namespace std;

int main(int argc, char *argv[])
{
  cout << "Hello, world!" << endl << "This is a C++ source file with the file extension '.cc'." << endl;
  return (argc > 1 ? atoi(argv[1]) : 0);
}
