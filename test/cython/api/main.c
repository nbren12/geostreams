#include <stdlib.h> 
#include <Python.h>
#include "delorean_api.h"

int main(int argc, char *argv[])
{
  Py_Initialize();
  PyRun_SimpleString("from time import time,ctime\n"
                     "print('Today is',ctime(time()))\n");

  import_delorean();
  activate();
  Py_Finalize();
  return 0;
}
