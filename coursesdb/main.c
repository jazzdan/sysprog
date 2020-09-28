#include <stdio.h>

#include "coursesdb.c"
#include "coursesdb.h"

int main() {
  printf("Initializing database\n");
  if (init_database() != 0) {
    printf("Failed to initialize database\n");
    return EXIT_FAILURE;
  } else {
    printf("Successfully initialized database\n");
  }

  if (save_tables("test") != 0) {
    printf("Failed to save tables\n");
    return EXIT_SUCCESS;
  } else {
    printf("Successfully saved tables\n");
  }
}