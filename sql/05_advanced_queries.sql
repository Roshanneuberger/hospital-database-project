-- MySQL 5.7 Advanced Queries 

-- 1. Doctor Revenue Ranking 
SELECT 
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    d.specialization,
    COUNT(a.appointment_id) AS total_visits,
    SUM(a.amount) AS total_revenue,
    ROUND(AVG(a.amount), 2) AS avg_revenue_per_visit,
    @rank := @rank + 1 AS revenue_rank
FROM doctor d
LEFT JOIN appointment a ON d.doctor_id = a.doctor_id,
(SELECT @rank := 0) r
WHERE a.doctor_id IS NOT NULL
GROUP BY d.doctor_id, d.first_name, d.last_name, d.specialization
ORDER BY total_revenue DESC;

-- 2. Department Performance (Simple & Working)
SELECT 
    dep.dept_name,
    COUNT(DISTINCT d.doctor_id) AS doctor_count,
    COUNT(a.appointment_id) AS total_appointments,
    SUM(a.amount) AS dept_revenue,
    ROUND(AVG(a.amount), 2) AS avg_amount
FROM department dep
LEFT JOIN doctor d ON dep.dept_id = d.dept_id
LEFT JOIN appointment a ON d.doctor_id = a.doctor_id
GROUP BY dep.dept_id, dep.dept_name
HAVING total_appointments > 0
ORDER BY dept_revenue DESC;

-- 3. Top Doctors by Appointment Count (Subquery)
SELECT 
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    COUNT(a.appointment_id) AS appt_count,
    SUM(a.amount) AS revenue
FROM doctor d
LEFT JOIN appointment a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name
HAVING appt_count > (
    SELECT AVG(appt_count) 
    FROM (
        SELECT COUNT(*) AS appt_count 
        FROM appointment 
        GROUP BY doctor_id
    ) avg_doctors
)
ORDER BY revenue DESC;

-- 4. High-Spending Patients (Correlated Subquery)
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    COUNT(a.appointment_id) AS visit_count,
    SUM(a.amount) AS total_spent,
    ROUND(AVG(a.amount), 2) AS avg_spent
FROM patient p
INNER JOIN appointment a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name
HAVING AVG(a.amount) > (
    SELECT AVG(amount) FROM appointment
)
ORDER BY total_spent DESC;

-- 5. Payment Dashboard (CASE + GROUP BY)
SELECT 
    pay_status,
    COUNT(*) AS appointment_count,
    SUM(amount) AS total_amount,
    ROUND(AVG(amount), 2) AS avg_amount,
    ROUND(100.0 * SUM(CASE WHEN pay_status = 'Paid' THEN 1 ELSE 0 END) / COUNT(*), 1) AS paid_percentage
FROM appointment
GROUP BY pay_status
ORDER BY total_amount DESC;

-- 6. Doctors with Most Revenue (Simple Ranking)
SELECT 
    doctor_id,
    SUM(amount) AS total_revenue,
    COUNT(*) AS appointment_count,
    @row_number := @row_number + 1 AS revenue_rank
FROM appointment, (SELECT @row_number := 0) r
GROUP BY doctor_id
ORDER BY total_revenue DESC;

-- 7. Department vs Individual Doctor Performance
SELECT 
    dep.dept_name,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    COUNT(a.appointment_id) AS appointments,
    SUM(a.amount) AS revenue,
    ROUND(AVG(a.amount), 2) AS avg_amount
FROM department dep
INNER JOIN doctor d ON dep.dept_id = d.dept_id
LEFT JOIN appointment a ON d.doctor_id = a.doctor_id
GROUP BY dep.dept_id, dep.dept_name, d.doctor_id, d.first_name, d.last_name
HAVING appointments > 0
ORDER BY revenue DESC;
