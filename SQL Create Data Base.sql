-- Дизайн бази даних:

-- 1. Створення бази даних та таблиць.
CREATE DATABASE IF NOT EXISTS stepproject;
USE stepproject;

CREATE TABLE IF NOT EXISTS teachers (teacher_no INT PRIMARY KEY AUTO_INCREMENT,
 teacher_name VARCHAR(255), phone_no VARCHAR(15));
 
CREATE TABLE IF NOT EXISTS courses (course_no INT PRIMARY KEY AUTO_INCREMENT, 
course_name VARCHAR(255), start_date DATE, end_date DATE);

CREATE TABLE IF NOT EXISTS students (student_no INT PRIMARY KEY AUTO_INCREMENT, 
teacher_no INT, course_no INT, student_name VARCHAR(255), email VARCHAR(255), birth_date DATE,
    FOREIGN KEY (teacher_no) REFERENCES teachers(teacher_no),
    FOREIGN KEY (course_no) REFERENCES courses(course_no));


-- 2.Додавання даних.
START TRANSACTION;

INSERT INTO teachers (teacher_name, phone_no) VALUES
('John Doe', '123-456-7890'),
('Jane Smith', '987-654-3210');

INSERT INTO courses (course_name, start_date, end_date) VALUES
('Introduction to Programming', '2024-01-01', '2024-03-01'),
('Database Management', '2024-02-01', '2024-04-01');

INSERT INTO students (teacher_no, course_no, student_name, email, birth_date) VALUES
(1, 1, 'Alice Johnson', 'alice@example.com', '2000-05-15'),
(1, 1, 'Bob Smith', 'bob@example.com', '2001-07-20'),
(2, 2, 'Charlie Brown', 'charlie@example.com', '1999-03-10');
COMMIT;


-- 3. Кількість студентів для кожного викладача.
SELECT t.teacher_no, t.teacher_name, COUNT(s.student_no) AS students_count FROM teachers AS t
JOIN students s ON t.teacher_no = s.teacher_no
GROUP BY t.teacher_no, t.teacher_name;


-- 4. Дублювання рядків та їх виявлення.
INSERT INTO students (teacher_no, course_no, student_name, email, birth_date)
SELECT teacher_no, course_no, student_name, email, birth_date FROM students
LIMIT 3;

SELECT DISTINCT teacher_no, course_no, student_name, email, birth_date FROM students
WHERE (teacher_no, course_no, student_name, email, birth_date) IN (SELECT teacher_no, course_no, student_name, email, birth_date FROM students
    GROUP BY teacher_no, course_no, student_name, email, birth_date
    HAVING COUNT(*) > 1);


-- 5. Виведення дублюючих рядків без використання віконних функцій.
SELECT DISTINCT teacher_no, course_no, student_name, email, birth_date FROM students
WHERE (teacher_no, course_no, student_name, email, birth_date) IN (SELECT teacher_no, course_no, student_name, email, birth_date FROM students
    GROUP BY teacher_no, course_no, student_name, email, birth_date
    HAVING COUNT(*) > 1);
