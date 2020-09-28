#include <stdio.h>

#include "coursesdb.c"
#include "coursesdb.h"

int main() {
  printf("Initializing database");
  return init_database();
}