-- REALISTIC SAMPLE DATA for  hospital database
--

-- 1. Insert Departments
INSERT INTO department (dept_id, dept_name) VALUES
('CARD-01', 'Cardiology'),
('PED-05', 'Pediatrics'),
('NEUR-02', 'Neurology'),
('ORTHO-03', 'Orthopedics'),
('INT-10', 'Internal Medicine'),
('DERM-04', 'Dermatology');

-- 2. Insert Doctors
INSERT INTO doctor (doctor_id, first_name, last_name, specialization, phone, email, dept_id) VALUES
('DOC-DE-001', 'Stefan', 'Wagner', 'Cardiology', '+49 30 4593-101', 's.wagner@hospital-berlin.de', 'CARD-01'),
('DOC-DE-002', 'Anja', 'Peters', 'Pediatrics', '+49 40 6682-202', 'a.peters@klinikum-nord.de', 'PED-05'),
('DOC-DE-003', 'Bernd', 'Hartmann', 'Neurology', '+49 89 2104-303', 'hartmann.b@med-muenchen.de', 'NEUR-02'),
('DOC-DE-004', 'Elena', 'Fischer', 'Orthopedics', '+49 69 7531-404', 'e.fischer@ortho-ffm.de', 'ORTHO-03'),
('DOC-DE-005', 'Markus', 'Scholz', 'Internal Medicine', '+49 221 8890-505', 'm.scholz@koeln-klinik.de', 'INT-10'),
('DOC-DE-006', 'Julia', 'Lehmann', 'Dermatology', '+49 711 3341-606', 'j.lehmann@hautzentrum-stgt.de', 'DERM-04'),
('DOC-DE-007', 'Thomas', 'Schwarz', 'Orthopedics', '+49 341 9920-707', 't.schwarz@leipzig-med.de', 'ORTHO-03'),
('DOC-DE-008', 'Katrin', 'Voigt', 'Pediatrics', '+49 211 5567-808', 'k.voigt@duesseldorf-klinik.de', 'PED-05');

-- 3. Insert Patients 
INSERT INTO patient (patient_id, first_name, last_name, date_of_birth, gender, phone, email, address) VALUES
('DE-33102', 'Julian', 'Neumann', '1989-07-22', 'Male', '+49 152 1122998', 'j.neumann89@gmail.com', 'Ringstraße 45, 01067 Dresden'),
('DE-44921', 'Clara', 'Schwarz', '1998-04-30', 'Female', '+49 170 8877665', 'schwarz.clara@web.de', 'Domplatz 12, 90403 Nürnberg'),
('DE-11283', 'Paul', 'Zimmermann', '1974-06-18', 'Male', '+49 157 5544332', 'p.zimmermann@gmx.net', 'Parkweg 21, 04103 Leipzig'),
('DE-88374', 'Laura', 'Krüger', '1990-12-09', 'Female', '+49 174 2233449', 'l.krueger90@icloud.com', 'Luisenstr. 5, 68159 Mannheim'),
('DE-55291', 'David', 'Braun', '1955-02-25', 'Male', '+49 162 9900887', 'braun.david55@freenet.de', 'Waldstraße 9, 76133 Karlsruhe');

-- 4. Insert Diagnoses 
INSERT INTO diagnosis (diagnosis_id, diagnosis_condition) VALUES
('E119', 'Type 2 Diabetes'),
('J029', 'Acute Pharyngitis'),
('G439', 'Migraine'),
('S934', 'Ankle Sprain'),
('E780', 'Hypercholesterolemia'),
('L709', 'Acne Vulgaris'),
('M750', 'Frozen Shoulder'),
('I1090', 'Hypertension'),
('H669', 'Otitis Media'),
('G470', 'Insomnia'),
('M179', 'Knee Osteoarthritis'),
('L239', 'Contact Dermatitis');

-- 5. Insert Medical Records
INSERT INTO medical_record (record_id, diagnosis_id, prescription, record_condition) VALUES
('REC-102', 'E119', 'Metformin 850mg', 'Type 2 Diabetes'),
('REC-103', 'J029', 'Dorithricin', 'Acute Pharyngitis'),
('REC-104', 'G439', 'Sumatriptan 50mg', 'Migraine'),
('REC-105', 'S934', 'Arthrodesis Bandage', 'Ankle Sprain'),
('REC-106', 'E780', 'Simvastatin 20mg', 'Hypercholesterolemia');

-- 6. Insert Appointments
INSERT INTO appointment (appointment_id, doctor_id, patient_id, record_id, insurance_type, status, amount, pay_date, method, pay_status) VALUES
('APP-2026-001', 'DOC-DE-001', 'DE-33102', 'REC-102', 'Gesetzlich (GKV)', 'Completed', 85.50, '2026-04-02', 'SEPA', 'Paid'),
('APP-2026-002', 'DOC-DE-002', 'DE-44921', 'REC-103', 'Privat (PKV)', 'Completed', 45.00, '2026-04-03', 'Cash', 'Paid'),
('APP-2026-003', 'DOC-DE-003', 'DE-11283', 'REC-104', 'Gesetzlich (GKV)', 'Cancelled', 0.00, NULL, NULL, 'N/A'),
('APP-2026-004', 'DOC-DE-004', 'DE-88374', 'REC-105', 'Gesetzlich (GKV)', 'Completed', 120.00, '2026-04-03', 'Credit Card', 'Paid'),
('APP-2026-005', 'DOC-DE-005', 'DE-55291', 'REC-106', 'Privat (PKV)', 'Completed', 65.20, NULL, 'Invoice', 'Pending');
