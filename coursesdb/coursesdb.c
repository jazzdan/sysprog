#include <stdio.h>
#include <stdlib.h>

const char *types[3];

struct Course {
  int id;
  const char *title[60];
  int year;
  char semester;
};

struct Student {
  int id;
  const char *name[30];
  int enrollment_year;
};

struct Enrollment {
  int student_id;
  int course_id;
};

int init_database() {
  types[0] = "courses";
  types[1] = "students";
  types[2] = "enrollment";

  return 0;
}

int save_tables(const char *prefix) {
  for (int i = 0; i < 3; i++) {
    const char *type = types[i];
    FILE *fPtr;

    char buf[256];
    snprintf(buf, sizeof(buf), "data/%s-%s.csv", prefix, type);

    fPtr = fopen(buf, "w");
    if (fPtr == NULL) {
      printf("Unable to create file %s.\n", buf);
      return 101;
    }

    fclose(fPtr);
  }
  return 0;
}