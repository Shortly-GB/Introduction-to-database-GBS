-- =====================================================================
-- CPU4:103 Introduction to Database  |  Crownfield Eye Hospital
-- File 04_security.sql  -  Part D security, data protection, transactions
-- Student : Iulian Mucuta   (individual work)
-- Requires : 01, 01b, 03 already executed.  Run as root / DBA.
-- =====================================================================
USE crownfield_eye_hospital;

-- Remove the test patient from any earlier run so the demos below start clean
DELETE FROM appointments WHERE PatientID = 'OP013';
DELETE FROM patients     WHERE PatientID = 'OP013';

DROP ROLE IF EXISTS r_admin, r_doctor, r_receptionist, r_patient;
CREATE ROLE r_admin, r_doctor, r_receptionist, r_patient;

-- Administrator: full data control inside this schema only (not the server)
GRANT ALL PRIVILEGES ON crownfield_eye_hospital.* TO r_admin;

-- Doctor: read clinical data, record clinical outcomes, never delete
GRANT SELECT ON crownfield_eye_hospital.patients      TO r_doctor;
GRANT SELECT ON crownfield_eye_hospital.clinicians    TO r_doctor;
GRANT SELECT ON crownfield_eye_hospital.specialties   TO r_doctor;
GRANT SELECT ON crownfield_eye_hospital.clinics       TO r_doctor;
GRANT SELECT                   ON crownfield_eye_hospital.appointments TO r_doctor;
GRANT SELECT, INSERT, UPDATE   ON crownfield_eye_hospital.Diagnosis    TO r_doctor;
GRANT SELECT, INSERT, UPDATE   ON crownfield_eye_hospital.prescription TO r_doctor;
GRANT SELECT, INSERT           ON crownfield_eye_hospital.medicines    TO r_doctor;
GRANT SELECT, INSERT, UPDATE   ON crownfield_eye_hospital.FollowUp     TO r_doctor;

-- Receptionist: manage people and bookings, no access to clinical detail
GRANT SELECT, INSERT, UPDATE   ON crownfield_eye_hospital.patients     TO r_receptionist;
GRANT SELECT ON crownfield_eye_hospital.clinicians    TO r_receptionist;
GRANT SELECT ON crownfield_eye_hospital.specialties   TO r_receptionist;
GRANT SELECT ON crownfield_eye_hospital.clinics       TO r_receptionist;
GRANT SELECT, INSERT, UPDATE   ON crownfield_eye_hospital.appointments TO r_receptionist;

-- Patient: sees ONLY their own records through a row-filtered view
CREATE OR REPLACE SQL SECURITY DEFINER VIEW v_my_appointments AS
SELECT  a.AppointmentID, a.AppointmentDateTime, c.FullName AS Clinician, cl.ClinicName,
        d.Diagnosisname, m.MedicineName, r.Dose, r.Frequency, r.Duration,
        f.DueDate AS FollowUpDue, f.Priority, f.Status
FROM    UserAccounts u
JOIN    appointments a  ON a.PatientID    = u.PatientID
JOIN    clinicians   c  ON c.ClinicianID  = a.ClinicianID
JOIN    clinics      cl ON cl.ClinicID    = a.ClinicID
LEFT JOIN Diagnosis    d ON d.AppointmentID = a.AppointmentID
LEFT JOIN prescription r ON r.AppointmentID = a.AppointmentID
LEFT JOIN medicines    m ON m.MedicineID    = r.MedicineID
LEFT JOIN FollowUp     f ON f.AppointmentID = a.AppointmentID
WHERE   u.Username = SUBSTRING_INDEX(USER(), '@', 1);   -- row-level filter
-- USER() (not CURRENT_USER()) is required: inside a DEFINER view
-- CURRENT_USER() would return the view's creator, not the logged-in patient.

GRANT SELECT ON crownfield_eye_hospital.v_my_appointments TO r_patient;

-- Database logins (MySQL 8+/9 default auth = caching_sha2_password)
DROP USER IF EXISTS 'admin'@'localhost', 'dr.shah'@'localhost',
                    'reception1'@'localhost', 'op001.amina'@'localhost';
CREATE USER 'admin'@'localhost'       IDENTIFIED BY 'Admin#2026';
CREATE USER 'dr.shah'@'localhost'     IDENTIFIED BY 'Glaucoma!1';
CREATE USER 'reception1'@'localhost'  IDENTIFIED BY 'Front#Desk1';
CREATE USER 'op001.amina'@'localhost' IDENTIFIED BY 'Amina#001';

GRANT r_admin        TO 'admin'@'localhost';
GRANT r_doctor       TO 'dr.shah'@'localhost';
GRANT r_receptionist TO 'reception1'@'localhost';
GRANT r_patient      TO 'op001.amina'@'localhost';

SET DEFAULT ROLE ALL TO 'admin'@'localhost', 'dr.shah'@'localhost',
                        'reception1'@'localhost', 'op001.amina'@'localhost';

-- Evidence for the report
SHOW GRANTS FOR r_doctor;
SHOW GRANTS FOR r_receptionist;
SHOW GRANTS FOR r_patient;
SHOW GRANTS FOR 'dr.shah'@'localhost' USING r_doctor;


-- Data protection: passwords are stored only as a salted SHA-256 hash
SELECT Username, Role, Salt, PasswordHash FROM UserAccounts;


SET @malicious = CONCAT('OP001', CHAR(39), ' OR ', CHAR(39), '1', CHAR(39), '=', CHAR(39), '1');
SELECT @malicious AS attacker_input;

-- (a) VULNERABLE: string concatenation -> returns all 14 baseline patients
SET @unsafe_sql = CONCAT('SELECT PatientID, FullName FROM patients WHERE PatientID = ''', @malicious, '''');
SELECT @unsafe_sql AS query_actually_executed;
PREPARE bad FROM @unsafe_sql;
EXECUTE bad;
DEALLOCATE PREPARE bad;

-- (b) SECURE: parameter placeholder -> input is treated as DATA, 0 rows
PREPARE good FROM 'SELECT PatientID, FullName FROM patients WHERE PatientID = ?';
EXECUTE good USING @malicious;          -- 0 rows: no patient has that id
SET @legit = 'OP001';
EXECUTE good USING @legit;              -- 1 row: Amina Yusuf
DEALLOCATE PREPARE good;


-- =====================================================================
-- D3.  TRANSACTIONS  (ACID behaviour: atomicity and rollback)
-- =====================================================================
-- (a) Manual transaction with explicit ROLLBACK: nothing persists
START TRANSACTION;
    INSERT INTO patients VALUES ('OP013', 'Rollback Test', 'ZZ1 1ZZ');
    SELECT COUNT(*) AS patients_inside_txn FROM patients;   -- 15
ROLLBACK;
SELECT COUNT(*) AS patients_after_rollback FROM patients;   -- 14

-- (b) Manual transaction with COMMIT: the new patient persists
START TRANSACTION;
    INSERT INTO patients VALUES ('OP013', 'Priya Raman', 'HA2 7LX');
COMMIT;
SELECT PatientID, FullName FROM patients WHERE PatientID = 'OP013';
