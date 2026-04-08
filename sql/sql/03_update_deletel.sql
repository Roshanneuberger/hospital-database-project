-- UPDATE and DELETE Operations for Hospital Database
-- Using  data

-- ===============================================
-- UPDATE EXAMPLES (Realistic Scenarios)
-- ===============================================

-- 1. Update patient phone number
UPDATE patient 
SET phone = '+49 152 1122999' 
WHERE patient_id = 'DE-33102';

-- 2. Mark appointment as paid (bulk update)
UPDATE appointment 
SET pay_status = 'Paid', pay_date = CURDATE(), method = 'SEPA'
WHERE pay_status = 'Pending' AND amount > 0;

-- 3. Change doctor department assignment
UPDATE doctor 
SET dept_id = 'ORTHO-03'
WHERE doctor_id = 'DOC-DE-007';

-- 4. Update appointment status from Scheduled → Completed
UPDATE appointment 
SET status = 'Completed', amount = 95.00
WHERE appointment_id = 'APP-2026-016';

-- 5. Update multiple fields (patient moved)
UPDATE patient 
SET phone = '+49 176 1234567', 
    address = 'Neue Adresse 123, 80331 München',
    email = 'julian.neumann@newemail.de'
WHERE patient_id = 'DE-33102';

-- ===============================================
-- DELETE EXAMPLES (Safe Operations)
-- ===============================================

-- 1. Delete cancelled appointments (status = 'Cancelled')
DELETE FROM appointment 
WHERE status = 'Cancelled';

-- 2. Delete No-Show appointments with no billing
DELETE FROM appointment 
WHERE status = 'No-Show' AND amount = 0;

-- 3. Delete test appointments (safe pattern)
DELETE FROM appointment 
WHERE appointment_id LIKE 'TEST%';

-- 4. CASCADE DELETE - Remove patient with no appointments first
-- Step 1: Check if patient has appointments
SELECT COUNT(*) FROM appointment WHERE patient_id = 'DE-TEST01';

-- Step 2: Delete if count = 0
DELETE FROM patient WHERE patient_id = 'DE-TEST01';

-- 5. Delete old medical records (older than 2 years, no active appointments)
DELETE mr FROM medical_record mr
LEFT JOIN appointment a ON mr.record_id = a.record_id
WHERE a.appointment_id IS NULL 
  AND DATE_SUB(CURDATE(), INTERVAL 2 YEAR) > NOW();

-- ===============================================
-- SAFE OPERATIONS with Transactions
-- ===============================================

-- Always use transactions for critical updates/deletes:
START TRANSACTION;

-- Safe update with backup
CREATE TEMPORARY TABLE appointment_backup AS 
SELECT * FROM appointment WHERE status = 'No-Show';

-- Update No-Show to Cancelled
UPDATE appointment 
SET status = 'Cancelled', amount = 25.00
WHERE status = 'No-Show';

-- Verify results
SELECT COUNT(*) FROM appointment WHERE status = 'Cancelled';

-- If good → COMMIT, else → ROLLBACK
COMMIT;
-- ROLLBACK;  -- Use this if something goes wrong

-- ===============================================
-- Verification Queries (Always run after UPDATE/DELETE)
-- ===============================================

-- Check update worked:
SELECT appointment_id, status, pay_status, amount 
FROM appointment 
WHERE status IN ('Completed', 'Cancelled');

-- Check counts before/after operations:
SELECT 
    'Total Appointments' as metric, COUNT(*) as count FROM appointment
UNION ALL
    SELECT 'Paid', COUNT(*) FROM appointment WHERE pay_status = 'Paid'
UNION ALL
    SELECT 'Pending', COUNT(*) FROM appointment WHERE pay_status = 'Pending';
