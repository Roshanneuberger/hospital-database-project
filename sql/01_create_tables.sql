-- MySQL 5.7 Compatible Hospital Database Schema
-- Complete CREATE TABLE statements with constraints and indexes

-- 1. Department Table
CREATE TABLE department (
    dept_id VARCHAR(10) PRIMARY KEY,
    dept_name VARCHAR(50)
);

-- 2. Doctor Table
CREATE TABLE doctor (
    doctor_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    dept_id VARCHAR(10) NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id),
    UNIQUE KEY uk_doctor_email (email)
);

-- 3. Patient Table
CREATE TABLE patient (
    patient_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(10) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    UNIQUE KEY uk_patient_email (email)
);

-- 4. Diagnosis Table 
CREATE TABLE diagnosis (
    diagnosis_id VARCHAR(10) PRIMARY KEY,
    diagnosis_condition VARCHAR(100) NOT NULL,
    UNIQUE KEY uk_diagnosis_condition (diagnosis_condition)
);

-- 5. Medical Record Table
CREATE TABLE medical_record (
    record_id VARCHAR(10) PRIMARY KEY,
    diagnosis_id VARCHAR(10) NOT NULL,
    prescription VARCHAR(100) NOT NULL,
    record_condition VARCHAR(100),
    FOREIGN KEY (diagnosis_id) REFERENCES diagnosis(diagnosis_id)
);

-- 6. Appointment Table (Core transaction table)
CREATE TABLE appointment (
    appointment_id VARCHAR(15) PRIMARY KEY,
    doctor_id VARCHAR(10) NOT NULL,
    patient_id VARCHAR(10) NOT NULL,
    record_id VARCHAR(10) NOT NULL,
    insurance_type VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL,
    amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    pay_date DATE,
    method VARCHAR(20),
    pay_status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    
    FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id),
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
    FOREIGN KEY (record_id) REFERENCES medical_record(record_id),
    UNIQUE KEY uk_appointment_doctor_patient (doctor_id, patient_id)
);

-- Performance Indexes for common queries
CREATE INDEX idx_appointment_doctor ON appointment(doctor_id);
CREATE INDEX idx_appointment_patient ON appointment(patient_id);
CREATE INDEX idx_appointment_status ON appointment(status);
CREATE INDEX idx_appointment_payment ON appointment(pay_status);
CREATE INDEX idx_doctor_dept ON doctor(dept_id);
CREATE INDEX idx_record_diagnosis ON medical_record(diagnosis_id);

-- Verification: List all constraints
SELECT 
    tc.CONSTRAINT_NAME, 
    tc.TABLE_NAME, 
    tc.CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
WHERE tc.TABLE_SCHEMA = DATABASE();
