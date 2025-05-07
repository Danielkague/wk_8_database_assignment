-- Create the database (if not already using it)
CREATE DATABASE IF NOT EXISTS student_records;
USE student_records;

-- Table: students
-- Stores basic student information
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other', 'Prefer not to say') NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(255),
    enrollment_date DATE NOT NULL,
    status ENUM('Active', 'Graduated', 'On Leave', 'Withdrawn') NOT NULL DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: teachers
-- Stores information about teachers/professors
CREATE TABLE teachers (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    department VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL,
    status ENUM('Active', 'On Leave', 'Retired') NOT NULL DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: departments
-- Stores academic departments
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    department_code CHAR(4) NOT NULL UNIQUE,
    chair_name VARCHAR(100)
);

-- Table: courses
-- Stores information about available courses
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(10) NOT NULL UNIQUE,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    credits TINYINT NOT NULL CHECK (credits > 0 AND credits <= 6),
    department_id INT NOT NULL,
    teacher_id INT NOT NULL,
    semester ENUM('Fall', 'Spring', 'Summer') NOT NULL,
    year YEAR NOT NULL,
    max_enrollment INT NOT NULL DEFAULT 30,
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

-- Table: enrollments
-- Tracks student enrollment in courses
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Enrolled', 'Withdrawn', 'Completed') NOT NULL DEFAULT 'Enrolled',
    UNIQUE (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Table: grades
-- Stores grade information for each student enrollment
CREATE TABLE grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL UNIQUE,
    midterm_grade DECIMAL(5,2),
    final_grade DECIMAL(5,2),
    letter_grade CHAR(2),
    comments TEXT,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
);

-- Insert sample data for departments
INSERT INTO departments (department_name, department_code, chair_name) VALUES
('Computer Science', 'CSCI', 'Dr. David Anderson'),
('Mathematics', 'MATH', 'Dr. Elizabeth Taylor'),
('English', 'ENGL', 'Dr. Robert Wilson');

-- Insert sample data for teachers
INSERT INTO teachers (first_name, last_name, email, phone, department, hire_date, status) VALUES
('David', 'Anderson', 'david.anderson@university.edu', '555-987-6543', 'Computer Science', '2015-08-15', 'Active'),
('Elizabeth', 'Taylor', 'elizabeth.taylor@university.edu', '555-876-5432', 'Mathematics', '2010-01-10', 'Active'),
('Robert', 'Wilson', 'robert.wilson@university.edu', '555-765-4321', 'English', '2018-06-20', 'Active');

-- Insert sample data for students
INSERT INTO students (first_name, last_name, date_of_birth, gender, email, phone, address, enrollment_date, status) VALUES
('John', 'Smith', '2000-05-15', 'Male', 'john.smith@email.com', '555-123-4567', '123 College Ave, University City, CA 92101', '2022-09-01', 'Active'),
('Emma', 'Johnson', '2001-07-22', 'Female', 'emma.j@email.com', '555-234-5678', '456 Campus Drive, University City, CA 92102', '2022-09-01', 'Active'),
('Michael', 'Williams', '1999-03-10', 'Male', 'michael.w@email.com', '555-345-6789', '789 Scholar Street, University City, CA 92103', '2021-09-01', 'Active');

-- Insert sample data for courses
INSERT INTO courses (course_code, title, description, credits, department_id, teacher_id, semester, year, max_enrollment) VALUES
('CSCI101', 'Introduction to Programming', 'Fundamental concepts of programming using Python.', 3, 1, 1, 'Fall', 2023, 30),
('MATH101', 'Calculus I', 'Limits, derivatives, and basic integration.', 4, 2, 2, 'Fall', 2023, 35),
('ENGL101', 'Composition I', 'Introduction to academic writing and rhetoric.', 3, 3, 3, 'Fall', 2023, 25),
('CSCI201', 'Data Structures', 'Advanced data structures and algorithms.', 4, 1, 1, 'Spring', 2024, 25),
('MATH201', 'Linear Algebra', 'Vector spaces, matrices, and linear transformations.', 3, 2, 2, 'Spring', 2024, 30);

-- Insert sample data for enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date, status) VALUES
(1, 1, '2023-08-15', 'Completed'), -- John in CSCI101
(1, 2, '2023-08-15', 'Completed'), -- John in MATH101
(1, 3, '2023-08-15', 'Completed'), -- John in ENGL101
(2, 1, '2023-08-10', 'Completed'), -- Emma in CSCI101
(2, 2, '2023-08-10', 'Completed'), -- Emma in MATH101
(3, 2, '2023-08-05', 'Completed'), -- Michael in MATH101
(3, 3, '2023-08-05', 'Completed'), -- Michael in ENGL101
(1, 4, '2024-01-05', 'Enrolled'), -- John in CSCI201
(1, 5, '2024-01-05', 'Enrolled'), -- John in MATH201
(2, 4, '2024-01-06', 'Enrolled'); -- Emma in CSCI201

-- Insert sample data for grades
INSERT INTO grades (enrollment_id, midterm_grade, final_grade, letter_grade, comments) VALUES
(1, 85.5, 91.2, 'A-', 'Excellent work on final project'),
(2, 78.0, 82.5, 'B', 'Good progress throughout the semester'),
(3, 92.0, 94.5, 'A', 'Outstanding writing skills'),
(4, 75.0, 79.0, 'C+', 'Struggled with some concepts but improved'),
(5, 84.0, 88.5, 'B+', 'Consistent performance'),
(6, 79.0, 81.0, 'B-', 'Improvement shown after midterm'),
(7, 90.0, 91.5, 'A-', 'Very creative writing assignments');

-- Create a simple view to see student enrollments with grades
CREATE VIEW student_course_grades AS
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    c.course_code,
    c.title AS course_title,
    CONCAT(t.first_name, ' ', t.last_name) AS teacher_name,
    e.status,
    g.final_grade,
    g.letter_grade
FROM 
    students s
JOIN 
    enrollments e ON s.student_id = e.student_id
JOIN 
    courses c ON e.course_id = c.course_id
JOIN 
    teachers t ON c.teacher_id = t.teacher_id
LEFT JOIN 
    grades g ON e.enrollment_id = g.enrollment_id
ORDER BY 
    s.last_name, s.first_name, c.semester, c.year;

