#include <Python.h>
#include "cython_hook.h"

int main(int argc, char *argv[])
{
  Py_Initialize();
  PyInit_cython_hook();
  cython_hook();
  Py_Finalize();
  return 0;
}

