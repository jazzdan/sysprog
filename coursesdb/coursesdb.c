#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

struct Course current_courses[100];
struct Student current_students[100];
struct Enrollment current_enrollment[100];

int init_database() {
  types[0] = "courses";
  types[1] = "students";
  types[2] = "enrollment";

  return 0;
}

int save_tables(const char *prefix) {
  for (int i = 0; i < 3; i++) {
    const char *type = types[i];
    FILE *file_handle;

    char buf[256];
    snprintf(buf, sizeof(buf), "data/%s-%s.csv", prefix, type);

    file_handle = fopen(buf, "w");
    if (file_handle == NULL) {
      printf("Unable to create file %s.\n", buf);
      return 101;
    }

    fclose(file_handle);
  }
  return 0;
}

// https://stackoverflow.com/questions/12911299/read-csv-file-in-c
const char *getfield(char *line, int num) {
  const char *tok;
  for (tok = strtok(line, ","); tok && *tok; tok = strtok(NULL, ",\n")) {
    if (!--num) return tok;
  }
  return NULL;
}

int load_tables(const char *prefix) {
  for (int i = 0; i < 3; i++) {
    const char *type = types[i];
    FILE *file_handle;

    char file_name[256];
    snprintf(file_name, sizeof(file_name), "data/%s-%s.csv", prefix, type);

    printf("trying to read %s\n", file_name);
    file_handle = fopen(file_name, "r");
    if (file_handle == NULL) {
      printf("Unable to open file %s.\n", file_name);
      return 102;
    }

    char line[1024];
    while (fgets(line, 1024, file_handle)) {
      char *tmp = strdup(line);
      printf("Field 0 would be %s\n", getfield(tmp, 1));
      // NOTE strtok clobbers tmp
      free(tmp);
    }

    fclose(file_handle);
  }

  return 0;
}