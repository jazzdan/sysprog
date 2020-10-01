#!/usr/bin/python
import os

os.system("redo-ifchange all")

def teardown():
    print(os.getcwd())
    os.system("git checkout data/test-courses.csv data/test-students.csv data/test-enrollment.csv")

def fail(msg):
    print(msg)
    teardown()
    exit(1)

def run():
    return os.system("./main")

status = run()
if status != 0:
    fail("failed to run main")

expected_courses = """1,test,1920,f
3,hello3,1921,f
"""

courses_file = open("data/test-courses.csv", "r")
actual_courses = courses_file.read()

if actual_courses != expected_courses:
    fail("Expected course file to be:\n%s\nGot:\n%s" % (expected_courses, actual_courses))

expected_students = """1,dan,2009
"""

students_file = open("data/test-students.csv", "r")
actual_students = students_file.read()

if actual_students != expected_students:
    fail("Expected students file to be:\n%s\nGot:\n%s" % (expected_students, actual_students))


teardown()