#include <stdio.h>

#include "coursesdb.c"
#include "coursesdb.h"

int main() {
  printf("Initializing database\n");
  if (init_database() != 0) {
    printf("Failed to initialize database\n");
  } else {
    printf("Successfully initialized database\n");
  }
}