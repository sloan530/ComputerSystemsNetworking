#include <stdio.h>
#include "file2.h"

int global_var_in_file2 = 0;

void function_in_file2(void)
{
  printf("This is a function in file2.c\n");
  global_var_in_file2++;
}

