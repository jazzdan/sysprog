#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// TODO soft delete
// TODO write test for deleting course + then saving
// TODO handle growing the number of students instead of just allocating 1024

const char *types[3];

struct Course {
  int id;
  char *title;
  int year;
  char semester;
  bool deleted;
};

struct Student {
  int id;
  char *name;
  int enrollment_year;
  bool deleted;
};

struct Enrollment {
  int student_id;
  int course_id;
  bool deleted;
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
  if (c->deleted) {
    return 0;
  }
  return fprintf(fh, "%d,%s,%d,%c\n", c->id, c->title, c->year, c->semester);
}

void print_courses() {
  printf("We think there are %d courses\n", current_course_index);
  for (int i = 0; i < current_course_index; i++) {
    struct Course *c = current_courses[i];
    printf("{%d,%s,%d,%c,%d}\n", c->id, c->title, c->year, c->semester,
           c->deleted);
  }
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

char **parse(char *line, char *delim) {
  // strip trailing newline
  int len = strlen(line);
  if (line[len - 1] == '\n') line[len - 1] = '\0';

  char **ap;
  static char *argv[4];
  for (ap = argv; (*ap = strsep(&line, delim)) != NULL;)
    if ((**ap != '\0') && (++ap >= &argv[4])) break;
  return argv;
}

struct Course *csv_to_course(char *line) {
  char **fields = parse(line, ",");

  struct Course *c = malloc(sizeof(struct Course));
  c->id = atoi(fields[0]);
  c->title = strdup(fields[1]);
  c->year = atoi(fields[2]);
  c->semester = fields[3][0];
  c->deleted = false;

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
        struct Course *c = csv_to_course(tmp);
        current_courses[current_course_index] = c;
        printf("Loaded course #%d from file\n", current_course_index);
        current_course_index++;
        printf("current_course_index is now %d\n", current_course_index);
      }
      free(tmp);
    }

    fclose(file_handle);
  }

  return 0;
}

int add_course(int id, const char *title, int year, char semester) {
  struct Course *c = malloc(sizeof(struct Course));
  c->id = id;
  c->title = strdup(title);
  c->year = year;
  c->semester = semester;
  c->deleted = false;

  current_courses[current_course_index] = c;
  printf("Added course #%d in memory\n", current_course_index);
  current_course_index++;
  printf("current course index is now %d\n", current_course_index);

  return 0;
}

int delete_course(int id) {
  for (int i = 0; i < current_course_index; i++) {
    struct Course *c = current_courses[i];
    if (c->id == id && !c->deleted) {
      c->deleted = true;
      return 0;
    }
  }

  return 1;
}