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

  if (add_course(3, "hello3", 1921, 'f') != 0) {
    printf("Failed to add course\n");
    return EXIT_FAILURE;
  } else {
    printf("Successfully added course\n");
  }

  if (delete_course(2) != 0) {
    printf("Failed to delete course\n");
    return EXIT_FAILURE;
  } else {
    printf("Successfully deleted course\n");
  }

  if (add_student(2, "taro", 2010) != 0) {
    printf("Failed to add student\n");
    return EXIT_FAILURE;
  } else {
    printf("Successfully added student\n");
  }

  print_courses();
  print_students();

  if (enroll_student(1, 1) != 0) {
    printf("Failed to enroll student\n");
    return EXIT_FAILURE;
  } else {
    printf("Successfully enrolled student in course\n");
  }

  if (enroll_student(2, 1) != 0) {
    printf("Failed to enroll student\n");
    return EXIT_FAILURE;
  } else {
    printf("Successfully enrolled student in course\n");
  }

  if (cancel_enrollment(2, 1) != 0) {
    printf("Failed to cancel enrollment\n");
    return EXIT_FAILURE;
  } else {
    printf("Successfully cancelled enrollment\n");
  }

  if (add_student(3, "steve", 2012) != 0) {
    printf("Failed to add student\n");
    return EXIT_FAILURE;
  }

  if (delete_student(2) != 0) {
    printf("Failed to delete student\n");
    return EXIT_FAILURE;
  }

  // Test student iterator
  struct student_iterator *si = next_student(NULL);
  printf("Student name should be dan: %s\n", student_name(si));
  si = next_student(si);
  printf("Student name should be steve: %s\n", student_name(si));
  si = next_student(si);
  if (si != NULL) {
    printf(
        "Student iterator should return null once there are no more "
        "students\n");
    return EXIT_FAILURE;
  }

  if (save_tables("test") != 0) {
    printf("Failed to save tables\n");
    return EXIT_FAILURE;
      } else {
        printf("Successfully saved tables\n");
      }
}