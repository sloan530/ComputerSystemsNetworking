#include <stdio.h>
#include "file2.h"
#include "main.h"

extern global_var_in_file2;

int main(void)
{
  printf("This is main()\n");
  function_in_main();
  function_in_file2();
  printf("Global var = %i\n", global_var_in_file2);
  return 0;
}

void function_in_main(void)
{
  printf("This is a function in main.c\n");
}
