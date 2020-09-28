#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const char *types[3];

struct Course {
  int id;
  char *title;
  int year;
  char semester;
};

struct Student {
  int id;
  char *name;
  int enrollment_year;
};

struct Enrollment {
  int student_id;
  int course_id;
};

int current_course_index = 0;
struct Course *current_courses[1024];
int current_student_index = 0;
struct Student *current_students[1024];
int current_enrollment_index = 0;
struct Enrollment *current_enrollment[1024];

int init_database() {
  types[0] = "courses";
  types[1] = "students";
  types[2] = "enrollment";

  return 0;
}

int course_to_csv(struct Course *c, FILE *fh) {
  return fprintf(fh, "%d,%s,%d,%c\n", c->id, c->title, c->year, c->semester);
}

int courses_to_csv(FILE *fh) {
  for (int i = 0; i < current_course_index; i++) {
    if (course_to_csv(current_courses[i], fh) < 0) {
      printf("Failed to write to csv");
      return 1;
    }
  }

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

    if (i == 0) {
      if (courses_to_csv(file_handle) != 0) {
        return 103;
      }
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

struct Course csv_to_course(char *line) {
  struct Course c;
  c.id = atoi(getfield(line, 1));
  strcpy(c.title, getfield(line, 2));
  c.year = atoi(getfield(line, 3));
  c.semester = getfield(line, 4)[0];  // TODO not sure if this is right
  return c;
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
      if (i == 0) {
        struct Course c = csv_to_course(tmp);
        current_courses[current_course_index] = &c;
      }
      printf("Field 1 would be %s\n", getfield(tmp, 1));
      // NOTE strtok clobbers tmp
      free(tmp);
    }

    fclose(file_handle);
  }

  return 0;
}