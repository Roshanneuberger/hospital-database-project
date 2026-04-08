-- COMPLEX SELECT QUERIES with 3+ table JOINs
-- Using  hospital database with real sample data

-- ===============================================
-- 1. DOCTOR → APPOINTMENT → PATIENT (3 tables)
-- Revenue per Doctor + Patient Details
-- ===============================================
SELECT 
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    d.specialization,
    COUNT(a.appointment_id) AS total_appointments,
    SUM(a.amount) AS total_revenue,
    AVG(a.amount) AS avg_amount,
    COUNT(DISTINCT a.patient_id) AS unique_patients,
    GROUP_CONCAT(DISTINCT p.first_name, ' ', p.last_name SEPARATOR ', ') AS patients
FROM doctor d
INNER JOIN appointment a ON d.doctor_id = a.doctor_id
INNER JOIN patient p ON a.patient_id = p.patient_id
GROUP BY d.doctor_id, d.first_name, d.last_name, d.specialization
ORDER BY total_revenue DESC;

-- ===============================================
-- 2. DEPARTMENT → DOCTOR → APPOINTMENT (3 tables)  
-- Department Performance Report
-- ===============================================
SELECT 
    dep.dept_id,
    dep.dept_name,
    COUNT(DISTINCT d.doctor_id) AS doctors_count,
    COUNT(a.appointment_id) AS total_appointments,
    SUM(a.amount) AS dept_revenue,
    AVG(a.amount) AS avg_appointment_value,
    MAX(a.amount) AS highest_amount
FROM department dep
INNER JOIN doctor d ON dep.dept_id = d.dept_id
INNER JOIN appointment a ON d.doctor_id = a.doctor_id
GROUP BY dep.dept_id, dep.dept_name
HAVING total_appointments > 0
ORDER BY dept_revenue DESC;

-- ===============================================
-- 3. APPOINTMENT → PATIENT → MEDICAL_RECORD (3 tables)
-- Patient Treatment Summary
-- ===============================================
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    COUNT(a.appointment_id) AS visit_count,
    GROUP_CONCAT(DISTINCT mr.prescription SEPARATOR ' | ') AS all_prescriptions,
    SUM(a.amount) AS total_spent,
    AVG(a.amount) AS avg_visit_cost
FROM patient p
INNER JOIN appointment a ON p.patient_id = a.patient_id
INNER JOIN medical_record mr ON a.record_id = mr.record_id
GROUP BY p.patient_id, p.first_name, p.last_name
ORDER BY total_spent DESC;

-- ===============================================
-- 4. 4 TABLES: DEPT → DOCTOR → APPOINTMENT → PATIENT
-- Complete Revenue Analysis
-- ===============================================
SELECT 
    dep.dept_name,
    d.specialization,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    COUNT(a.appointment_id) AS appointments,
    SUM(a.amount) AS revenue,
    COUNT(DISTINCT p.patient_id) AS patients_served,
    ROUND(AVG(a.amount), 2) AS avg_revenue_per_visit
FROM department dep
INNER JOIN doctor d ON dep.dept_id = d.dept_id
INNER JOIN appointment a ON d.doctor_id = a.doctor_id
INNER JOIN patient p ON a.patient_id = p.patient_id
WHERE a.status = 'Completed'
GROUP BY dep.dept_id, dep.dept_name, d.doctor_id, d.specialization, d.first_name, d.last_name
HAVING revenue > 50
ORDER BY revenue DESC;

-- ===============================================
-- 5. 5 TABLES: Full Patient Journey (DEPT→DOC→APP→REC→DIAG)
-- Complete Patient Treatment History
-- ===============================================
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.patient_id,
    dep.dept_name,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    d.specialization,
    dia.diagnosis_condition,
    mr.prescription,
    a.status,
    a.amount,
    a.pay_status
FROM patient p
INNER JOIN appointment a ON p.patient_id = a.patient_id
INNER JOIN doctor d ON a.doctor_id = d.doctor_id
INNER JOIN department dep ON d.dept_id = dep.dept_id
INNER JOIN medical_record mr ON a.record_id = mr.record_id
INNER JOIN diagnosis dia ON mr.diagnosis_id = dia.diagnosis_id
ORDER BY p.patient_id, a.appointment_id;

-- ===============================================
-- 6. Insurance Analysis (APPOINTMENT → PATIENT → DOCTOR)
-- Insurance Type vs Revenue
-- ===============================================
SELECT 
    a.insurance_type,
    COUNT(*) AS appointment_count,
    SUM(a.amount) AS total_revenue,
    AVG(a.amount) AS avg_amount,
    COUNT(DISTINCT p.patient_id) AS unique_patients,
    COUNT(DISTINCT d.doctor_id) AS doctors_served
FROM appointment a
INNER JOIN patient p ON a.patient_id = p.patient_id
INNER JOIN doctor d ON a.doctor_id = d.doctor_id
GROUP BY a.insurance_type
ORDER BY total_revenue DESC;

-- ===============================================
-- 7. Payment Status Dashboard (4 tables)
-- ===============================================
SELECT 
    a.pay_status,
    COUNT(*) AS count,
    SUM(a.amount) AS total_amount,
    ROUND(AVG(a.amount), 2) AS avg_amount,
    d.specialization,
    dep.dept_name
FROM appointment a
INNER JOIN doctor d ON a.doctor_id = d.doctor_id
INNER JOIN department dep ON d.dept_id = dep.dept_id
GROUP BY a.pay_status, d.specialization, dep.dept_name
ORDER BY total_amount DESC;
