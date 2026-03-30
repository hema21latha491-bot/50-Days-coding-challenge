create database college;
use college;

create table students (
 student_id INT PRIMARY KEY,
 student_name VARCHAR(50),
 gender VARCHAR(10),
 city VARCHAR(50),
 join_year INT
);


INSERT INTO students (student_id, student_name, gender, city, join_year) VALUES
(1, 'Anu', 'F', 'Tumakuru', 2024),
(2, 'Ravi', 'M', 'Bengaluru', 2023),
(3, 'Kiran', 'M', 'Tumakuru', 2024),
(4, 'Sneha', 'F', 'Mysuru', 2023),
(5, 'Manu', 'M', 'Tumakuru', 2022)


CREATE TABLE courses (
 course_id INT PRIMARY KEY,
 course_name VARCHAR(100),
 department VARCHAR(50)
);


INSERT INTO courses (course_id, course_name, department) VALUES
(101, 'SQL Basics', 'Computer Science'),
(102, 'Excel for Analysts', 'Commerce'),
(103, 'Statistics', 'Mathematics');


CREATE TABLE marks (
  mark_id INT PRIMARY KEY,
  student_id INT,
  course_id INT,
  marks INT,
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

insert into marks (mark_id, student_id, course_id, marks) VALUES
(1, 1, 101, 85),
(2, 2, 101, 72),
(3, 3, 101, 90),
(4, 4, 102, 88),
(5, 5, 103, 67),
(6, 1, 103, 79),
(7, 2, 102, 81);


select * from students; 

select student_name,city from students;


select course_name from courses;


SELECT *
FROM students
WHERE city = 'Tumakuru';


select * from students where join_year = 2024


select * from students where gender = "F";

select * from marks where marks > 80;

select * from courses where course_name = "commerce";


SELECT course_name
FROM courses
WHERE department = 'Commerce';


SELECT *
FROM students
WHERE city <> 'Bengaluru';

SELECT marks
FROM marks
WHERE marks BETWEEN 70 AND 90;

SELECT *
FROM marks
ORDER BY marks DESC;


SELECT *
FROM students
ORDER BY  join_year DESC;


SELECT AVG(marks) AS average_marks
FROM marks;


SELECT MAX(marks) AS highest_marks
FROM marks;

SELECT min(marks) AS lowest_marks
FROM marks;

SELECT SUM(marks) AS total_marks
FROM marks;


