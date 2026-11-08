-- =====================================================================
-- CPU4:103 Introduction to Database  |  Crownfield Eye Hospital
-- File 02_individual_queries.sql  -  Part C individual SQL (queries 1-4)
-- Student : Iulian Mucuta   (individual work)
-- Requires : 01_schema.sql and 01b_sample_data.sql already executed
-- =====================================================================
USE crownfield_eye_hospital;


SELECT  c.ClinicianID,
        c.FullName                       AS Clinician,
        COALESCE(s.SpecialtyName, 'No specialty recorded') AS Specialty,
        COUNT(a.AppointmentID)           AS TotalAppointments,
        COUNT(DISTINCT a.PatientID)      AS DistinctPatients,
        MIN(a.AppointmentDateTime)       AS FirstVisit,
        MAX(a.AppointmentDateTime)       AS LastVisit
FROM    clinicians c
JOIN    appointments a   ON a.ClinicianID = c.ClinicianID
LEFT JOIN specialties s  ON s.SpecialtyID = c.SpecialtyID
GROUP BY c.ClinicianID, c.FullName, s.SpecialtyName
HAVING  COUNT(a.AppointmentID) >= 3
ORDER BY TotalAppointments DESC, Clinician;


-- =====================================================================
-- QUERY 2
-- =====================================================================
SELECT  a.AppointmentID,
        DATE_FORMAT(a.AppointmentDateTime, '%d %b %Y %H:%i') AS VisitDateTime,
        p.PatientID,
        p.FullName        AS Patient,
        c.FullName        AS Clinician,
        s.SpecialtyName   AS Specialty,
        cl.ClinicName     AS Clinic,
        a.Notes
FROM    appointments a
INNER JOIN patients    p  ON p.PatientID    = a.PatientID
INNER JOIN clinicians  c  ON c.ClinicianID  = a.ClinicianID
INNER JOIN specialties s  ON s.SpecialtyID  = c.SpecialtyID
INNER JOIN clinics     cl ON cl.ClinicID    = a.ClinicID
WHERE   a.AppointmentDateTime >= '2026-10-01'
AND     a.AppointmentDateTime <  '2026-11-01'
ORDER BY a.AppointmentDateTime;


-- =====================================================================
-- QUERY 3
-- =====================================================================
SELECT  a.AppointmentID,
        p.PatientID,
        p.FullName                    AS Patient,
        DATE(a.AppointmentDateTime)   AS VisitDate,
        CASE WHEN r.PrescriptionID IS NULL THEN 'No prescription' ELSE 'Prescribed' END AS PrescriptionStatus,
        CASE WHEN f.FollowUpID     IS NULL THEN 'No follow-up plan' ELSE f.Status    END AS FollowUpStatus
FROM    appointments a
JOIN    patients     p ON p.PatientID     = a.PatientID
LEFT JOIN prescription r ON r.AppointmentID = a.AppointmentID
LEFT JOIN FollowUp     f ON f.AppointmentID = a.AppointmentID
WHERE   r.PrescriptionID IS NULL
   OR   f.FollowUpID     IS NULL
GROUP BY a.AppointmentID, p.PatientID, p.FullName, a.AppointmentDateTime, r.PrescriptionID, f.FollowUpID, f.Status
ORDER BY a.AppointmentDateTime;


-- =====================================================================
-- QUERY 4 
-- =====================================================================
WITH open_plans AS (
    SELECT  f.FollowUpID, f.AppointmentID, f.DueDate, f.Priority, f.Status,
            a.PatientID, a.ClinicianID
    FROM    FollowUp f
    JOIN    appointments a ON a.AppointmentID = f.AppointmentID
    WHERE   f.Status IN ('Pending', 'Scheduled')
)
SELECT  op.FollowUpID,
        p.PatientID,
        p.FullName                             AS Patient,
        c.FullName                             AS Clinician,
        op.DueDate,
        op.Priority,
        op.Status,
        DATEDIFF(CURDATE(), op.DueDate)        AS DaysOverdue,
        (SELECT COUNT(*) FROM appointments a2
          WHERE a2.PatientID = op.PatientID)   AS PatientTotalVisits
FROM    open_plans op
JOIN    patients   p ON p.PatientID   = op.PatientID
JOIN    clinicians c ON c.ClinicianID = op.ClinicianID
WHERE   op.DueDate < CURDATE()
ORDER BY FIELD(op.Priority, 'Urgent', 'High', 'Routine'), DaysOverdue DESC;
