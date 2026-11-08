-- =====================================================================
-- CPU4:103 Introduction to Database  |  Crownfield Eye Hospital
-- File 03_procedure_and_trigger.sql  -  Part C queries 5 and 6
-- Student : Iulian Mucuta   (individual work)
-- Requires : 01_schema.sql and 01b_sample_data.sql already executed
-- =====================================================================
USE crownfield_eye_hospital;

-- =====================================================================
-- QUERY 5  -  Stored procedure with an INPUT parameter
-- Question : "Show me the complete ophthalmology history of patient X"
--            - every visit with clinician, clinic, diagnoses, medicines
--            and follow-up - from one call: CALL sp_patient_history('OP001');
-- Why correct: the parameter drives the WHERE clause; GROUP_CONCAT folds
--            many diagnoses / medicines per visit into one readable row
--            (the opposite of the unnormalised sheet - the data is stored
--            atomically and only PRESENTED together). An unknown patient
--            raises a clear error instead of silently returning nothing.
-- =====================================================================
DROP PROCEDURE IF EXISTS sp_patient_history;
DELIMITER $$
CREATE PROCEDURE sp_patient_history (IN p_patient_id VARCHAR(10))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM patients WHERE PatientID = p_patient_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'sp_patient_history: patient id does not exist';
    END IF;

    SELECT  p.PatientID,
            p.FullName                                   AS Patient,
            a.AppointmentID,
            a.AppointmentDateTime,
            c.FullName                                   AS Clinician,
            cl.ClinicName                                AS Clinic,
            COALESCE(GROUP_CONCAT(DISTINCT d.Diagnosisname ORDER BY d.DID SEPARATOR '; '), '-') AS Diagnoses,
            COALESCE(GROUP_CONCAT(DISTINCT CONCAT(m.MedicineName, ' ', r.Dose, ' ', r.Frequency)
                                  ORDER BY m.MedicineName SEPARATOR '; '), 'No prescription') AS Prescription,
            COALESCE(CONCAT(f.DueDate, ' (', f.Priority, ', ', f.Status, ')'), 'No plan') AS FollowUp
    FROM    appointments a
    JOIN    patients     p  ON p.PatientID    = a.PatientID
    JOIN    clinicians   c  ON c.ClinicianID  = a.ClinicianID
    JOIN    clinics      cl ON cl.ClinicID    = a.ClinicID
    LEFT JOIN Diagnosis    d ON d.AppointmentID = a.AppointmentID
    LEFT JOIN prescription r ON r.AppointmentID = a.AppointmentID
    LEFT JOIN medicines    m ON m.MedicineID    = r.MedicineID
    LEFT JOIN FollowUp     f ON f.AppointmentID = a.AppointmentID
    WHERE   a.PatientID = p_patient_id
    GROUP BY p.PatientID, p.FullName, a.AppointmentID, a.AppointmentDateTime,
             c.FullName, cl.ClinicName, f.DueDate, f.Priority, f.Status
    ORDER BY a.AppointmentDateTime;
END$$
DELIMITER ;

-- Evidence: the Appendix patient with two visits
CALL sp_patient_history('OP001');
-- Evidence: a patient with a prescription-free visit
CALL sp_patient_history('OP003');
-- Expected to FAIL (run alone for screenshot): CALL sp_patient_history('OP999');


-- =====================================================================
-- QUERY 6  -  Trigger that ENFORCES a business rule
-- Rule     : A follow-up plan's due date must be AFTER the date of the
--            appointment that generated it (a plan due before the visit
--            is a data-entry error that a plain CHECK cannot catch because
--            the two dates live in different tables).
-- Why correct: a BEFORE INSERT trigger looks up the parent
--            appointment and SIGNALs an error, so the bad row never lands.
--            Valid rows are untouched (tested below).
-- =====================================================================
DROP TRIGGER IF EXISTS trg_followup_due_after_visit_ins;
DELIMITER $$
CREATE TRIGGER trg_followup_due_after_visit_ins
BEFORE INSERT ON FollowUp
FOR EACH ROW
BEGIN
    DECLARE v_visit DATE;
    SELECT DATE(AppointmentDateTime) INTO v_visit
    FROM   appointments WHERE AppointmentID = NEW.AppointmentID;
    IF NEW.DueDate <= v_visit THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Follow-up DueDate must be after the appointment date';
    END IF;
END$$
DELIMITER ;

-- Evidence 6a: a VALID plan for appointment 18 (visit 2026-10-20) is accepted
INSERT INTO FollowUp (AppointmentID, DueDate, Priority) VALUES (18, '2026-12-15', 'Routine');
SELECT * FROM FollowUp WHERE AppointmentID = 18;

-- Evidence 6b: expected to FAIL - due date before the visit (run alone):
-- INSERT INTO FollowUp (AppointmentID, DueDate) VALUES (21, '2026-10-01');

SHOW PROCEDURE STATUS WHERE Db = 'crownfield_eye_hospital';
SHOW TRIGGERS FROM crownfield_eye_hospital;
