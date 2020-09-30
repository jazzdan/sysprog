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

  if (load_tables("test") != 0) {
    printf("Failed to load tables\n");
    return EXIT_FAILURE;
  } else {
    printf("Successfully loaded tables\n");
  }

  if (add_course(2, "hello", 1921, 'f') != 0) {
    printf("Failed to add course\n");
    return EXIT_FAILURE;
  } else {
    printf("Successfully added course\n");
  }

  print_courses();

  if (save_tables("test") != 0) {
    printf("Failed to save tables\n");
    return EXIT_FAILURE;
  } else {
    printf("Successfully saved tables\n");
  }
}