-- =====================================================================
-- CPU4:103 Introduction to Database  |  Crownfield Eye Hospital
-- File 01b_sample_data.sql  -  Part B data population + controlled
-- =====================================================================
USE crownfield_eye_hospital;

-- ---------------------------------------------------------------------
-- 1. LOOKUP TABLES
-- ---------------------------------------------------------------------
INSERT INTO specialties (SpecialtyName) VALUES
 ('Glaucoma'),                 -- 1  (Appendix)
 ('Retina'),                   -- 2  (Appendix)
 ('Cornea'),                   -- 3  (Appendix)
 ('Cataract'),                 -- 4
 ('Paediatric Ophthalmology'), -- 5
 ('Oculoplastics'),            -- 6
 ('Neuro-ophthalmology'),      -- 7
 ('Uveitis'),                  -- 8
 ('Emergency Eye Care'),       -- 9
 ('Orthoptics'),               -- 10
 ('Ocular Oncology'),          -- 11
 ('Ophthalmic Genetics'),      -- 12
 ('Low Vision');               -- 13

INSERT INTO clinicians (FullName, SpecialtyID) VALUES
 ('Dr Maya Shah',        1),   -- 1 (Appendix)
 ('Dr Leo Grant',        2),   -- 2 (Appendix)
 ('Dr Priya Nair',       3),   -- 3 (Appendix)
 ('Dr Samuel Adeyemi',   4),   -- 4
 ('Dr Hannah Clarke',    5),   -- 5
 ('Mr Tomasz Nowak',     6),   -- 6
 ('Dr Fatima Rahman',    7),   -- 7
 ('Dr James Whitfield',  8),   -- 8
 ('Dr Chloe Martin',     9),   -- 9
 ('Ms Aisha Begum',     10),   -- 10
 ('Dr Oliver Hughes',  NULL),  -- 11 locum: specialty optional (business rule "may")
 ('Dr Leila Hassan',    11),   -- 12
 ('Dr Nathan Evans',    12);   -- 13

INSERT INTO clinics (ClinicName, Location) VALUES
 ('City Road',  'London EC1V 2PD'),   -- 1 (Appendix)
 ('Bedford',    'Bedford MK40 2AW'),  -- 2 (Appendix)
 ('Croydon',    'Croydon CR0 1XX'),   -- 3 (Appendix)
 ('Ealing',     'London W5 2HL'),     -- 4
 ('Stratford',  'London E15 1XA'),    -- 5
 ('Ilford',     'Ilford IG1 1BA'),    -- 6
 ('Barnet',     'Barnet EN5 3DJ'),    -- 7
 ('Harrow',     'Harrow HA1 3UJ'),    -- 8
 ('Lewisham',   'London SE13 6LH'),   -- 9
 ('Watford',    'Watford WD18 0HB'),  -- 10
 ('Kingston',   'Kingston KT1 1EU'),  -- 11
 ('Richmond',   'London TW9 1DN'),    -- 12
 ('Bromley',    'Bromley BR1 1AA');   -- 13

INSERT INTO medicines (MedicineName) VALUES
 ('Latanoprost'),            -- 1 (Appendix)
 ('Timolol'),                -- 2 (Appendix)
 ('Aflibercept'),            -- 3 (Appendix)
 ('Sodium chloride drops'),  -- 4 (Appendix)
 ('Chloramphenicol'),        -- 5
 ('Prednisolone acetate'),   -- 6
 ('Cyclopentolate'),         -- 7
 ('Dexamethasone'),          -- 8
 ('Carmellose sodium'),      -- 9
 ('Dorzolamide'),            -- 10
 ('Atropine'),               -- 11
 ('Ranibizumab'),            -- 12
 ('Brimonidine'),            -- 13
 ('Travoprost');             -- 14

-- ---------------------------------------------------------------------
-- 2. PATIENTS  (OP001-OP004 from Appendix 1, then synthetic)
-- ---------------------------------------------------------------------
-- OP013 is reserved for the transaction demonstrations in 04_security.sql.
INSERT INTO patients (PatientID, FullName, Postcode) VALUES
 ('OP001', 'Amina Yusuf',     'NE1 4AB'),
 ('OP002', 'Daniel Reed',     'N16 7QP'),
 ('OP003', 'Sofia Bennett',   'E8 2LD'),
 ('OP004', 'Michael Okoro',   'SE6 3RT'),
 ('OP005', 'Grace Chen',      'SW9 8LL'),
 ('OP006', 'Harpreet Singh',  'UB1 1AA'),
 ('OP007', 'Elena Popescu',   'IG1 2AB'),
 ('OP008', 'Thomas Wright',   'EN5 5XY'),
 ('OP009', 'Fatou Diallo',    'HA1 1BB'),
 ('OP010', 'Liam O''Connor',  'SE13 5AB'),
 ('OP011', 'Noor Haddad',     'WD17 1AA'),
 ('OP012', 'George Taylor',   'E15 4BQ'),
 ('OP014', 'Isla Mitchell',   'KT1 2AB'),
 ('OP015', 'Arjun Patel',     'BR1 2CD');

-- ---------------------------------------------------------------------
-- 3. APPOINTMENTS  (IDs 1-5 = the five Appendix 1 rows, in order)
-- ---------------------------------------------------------------------
INSERT INTO appointments (PatientID, ClinicianID, ClinicID, AppointmentDateTime, Notes) VALUES
 ('OP001', 1, 1, '2026-10-05 09:00:00', 'Review IOP'),                        -- 1
 ('OP002', 2, 1, '2026-10-05 09:30:00', 'OCT before review'),                 -- 2
 ('OP001', 1, 2, '2026-11-16 10:15:00', 'Visual field test'),                 -- 3
 ('OP003', 1, 1, '2026-10-06 11:00:00', 'Monitor'),                           -- 4
 ('OP004', 3, 3, '2026-10-07 14:00:00', 'Corneal topography'),                -- 5
 ('OP005', 4, 4, '2026-10-08 09:00:00', 'Pre-operative cataract assessment'), -- 6
 ('OP006', 5, 5, '2026-10-08 10:30:00', 'Squint assessment'),                 -- 7
 ('OP007', 6, 6, '2026-10-09 11:00:00', 'Eyelid lesion review'),              -- 8
 ('OP008', 7, 7, '2026-10-12 14:30:00', 'Optic neuritis follow-up'),          -- 9
 ('OP009', 8, 8, '2026-10-13 09:15:00', 'Anterior uveitis flare'),            -- 10
 ('OP010', 9, 9, '2026-10-13 16:00:00', 'Emergency: corneal foreign body'),   -- 11
 ('OP011', 10, 10, '2026-10-14 10:00:00', 'Orthoptic assessment'),            -- 12
 ('OP012', 2, 1, '2026-10-15 09:00:00', 'Wet AMD - first injection'),         -- 13
 ('OP002', 2, 1, '2026-11-02 09:30:00', 'DMO review after OCT'),              -- 14
 ('OP005', 4, 4, '2026-11-05 08:30:00', 'Cataract surgery - day case'),       -- 15
 ('OP004', 3, 3, '2026-12-02 14:00:00', 'Topography review'),                 -- 16 (future)
 ('OP009', 8, 8, '2026-10-27 09:15:00', 'Uveitis review'),                    -- 17
 ('OP010', 11, 9, '2026-10-20 11:30:00', 'Post-removal check'),               -- 18
 ('OP012', 2, 1, '2026-11-12 09:00:00', 'Wet AMD - second injection'),        -- 19 (future)
 ('OP003', 1, 1, '2027-04-06 11:00:00', 'Six-month glaucoma review'),         -- 20 (future)
 ('OP007', 6, 6, '2026-11-04 11:00:00', 'Minor ops: lesion excision'),        -- 21
 ('OP008', 7, 7, '2026-11-09 14:30:00', 'MRI results discussion');            -- 22 (future)

-- ---------------------------------------------------------------------
-- 4. DIAGNOSIS  (0..many per appointment; future visits have none yet)
-- ---------------------------------------------------------------------
INSERT INTO Diagnosis (Diagnosisname, AppointmentID) VALUES
 ('Ocular hypertension',                     1),   -- Appendix
 ('Diabetic macular oedema',                 2),   -- Appendix
 ('Ocular hypertension',                     3),   -- Appendix
 ('Glaucoma suspect',                        4),   -- Appendix
 ('Keratoconus',                             5),   -- Appendix
 ('Age-related cataract',                    6),
 ('Dry eye disease',                         6),   -- 2nd diagnosis, same visit
 ('Convergent squint',                       7),
 ('Chalazion',                               8),
 ('Optic neuritis',                          9),
 ('Anterior uveitis',                        10),
 ('Corneal foreign body',                    11),
 ('Corneal abrasion',                        11),  -- 2nd diagnosis, same visit
 ('Intermittent exotropia',                  12),
 ('Wet age-related macular degeneration',    13),
 ('Diabetic macular oedema',                 14),
 ('Age-related cataract',                    15),
 ('Anterior uveitis',                        17),
 ('Corneal abrasion',                        18),
 ('Chalazion',                               21);

-- ---------------------------------------------------------------------
-- 5. PRESCRIPTION  (one row per medicine item; appointment 4 = "None")
-- ---------------------------------------------------------------------
INSERT INTO prescription (AppointmentID, MedicineID, Dose, Route, Frequency, Duration) VALUES
 (1,  1,  '1 drop (0.005%)',  'Topical - both eyes',                'Once daily at night', '6 weeks'),   -- Appendix
 (1,  2,  '1 drop (0.5%)',    'Topical - both eyes',                'Twice daily',         '6 weeks'),   -- Appendix
 (2,  3,  '2 mg (0.05 ml)',   'Intravitreal injection - right eye', 'Single dose',         'Once'),      -- Appendix
 (3,  1,  '1 drop (0.005%)',  'Topical - both eyes',                'Once daily at night', '12 weeks'),  -- Appendix
 (5,  4,  '1 drop (5%)',      'Topical - left eye',                 'Four times daily',    '8 weeks'),   -- Appendix
 (6,  7,  '1 drop (1%)',      'Topical - right eye',                'Once (dilation)',     '1 day'),
 (6,  9,  '1 drop (0.5%)',    'Topical - both eyes',                'Four times daily',    '4 weeks'),
 (8,  5,  '1 drop (0.5%)',    'Topical - left eye',                 'Four times daily',    '7 days'),
 (10, 6,  '1 drop (1%)',      'Topical - right eye',                'Every 2 hours',       '2 weeks'),
 (10, 7,  '1 drop (1%)',      'Topical - right eye',                'Three times daily',   '1 week'),
 (11, 5,  '1 drop (0.5%)',    'Topical - right eye',                'Four times daily',    '5 days'),
 (13, 3,  '2 mg (0.05 ml)',   'Intravitreal injection - left eye',  'Single dose',         'Once'),
 (14, 3,  '2 mg (0.05 ml)',   'Intravitreal injection - right eye', 'Single dose',         'Once'),
 (15, 8,  '1 drop (0.1%)',    'Topical - right eye',                'Four times daily',    '4 weeks'),
 (15, 5,  '1 drop (0.5%)',    'Topical - right eye',                'Four times daily',    '1 week'),
 (17, 6,  '1 drop (1%)',      'Topical - right eye',                'Four times daily',    '2 weeks'),
 (18, 9,  '1 drop (0.5%)',    'Topical - right eye',                'As required',         '4 weeks'),
 (19, 3,  '2 mg (0.05 ml)',   'Intravitreal injection - left eye',  'Single dose',         'Once'),
 (21, 5,  '1 cm ointment (1%)', 'Topical - left eyelid',            'Twice daily',         '5 days');

-- ---------------------------------------------------------------------
-- 6. FOLLOW-UP  (0..1 per appointment; DueDate = visit date + interval)
-- ---------------------------------------------------------------------
INSERT INTO FollowUp (AppointmentID, DueDate, Priority, Status) VALUES
 (1,  '2026-11-16', 'High',    'Scheduled'),   -- Appendix: 6 weeks  / High    -> booked as appt 3
 (2,  '2026-11-02', 'Urgent',  'Completed'),   -- Appendix: 4 weeks  / Urgent  -> seen at appt 14
 (3,  '2027-02-08', 'Routine', 'Pending'),     -- Appendix: 12 weeks / Routine
 (4,  '2027-04-06', 'Routine', 'Scheduled'),   -- Appendix: 26 weeks / Routine -> booked as appt 20
 (5,  '2026-12-02', 'Routine', 'Scheduled'),   -- Appendix: 8 weeks  / Routine -> booked as appt 16
 (6,  '2026-11-05', 'High',    'Completed'),
 (7,  '2026-11-05', 'Routine', 'Pending'),     -- overdue (visit 08 Oct + 4 weeks)
 (8,  '2026-11-04', 'Routine', 'Completed'),
 (9,  '2026-11-09', 'High',    'Scheduled'),
 (10, '2026-10-27', 'Urgent',  'Completed'),
 (11, '2026-10-20', 'High',    'Completed'),
 (12, '2026-10-28', 'High',    'Pending'),     -- overdue (visit 14 Oct + 2 weeks)
 (13, '2026-11-12', 'Urgent',  'Scheduled'),
 (14, '2026-11-30', 'Urgent',  'Pending'),
 (15, '2026-11-19', 'High',    'Pending'),
 (17, '2026-11-24', 'Routine', 'Cancelled');
-- appointments 16, 18, 19, 20, 21, 22 deliberately have NO follow-up plan

-- ---------------------------------------------------------------------
-- 7. USER ACCOUNTS  (salted SHA-256; plaintext passwords are demo only)
-- ---------------------------------------------------------------------
INSERT INTO UserAccounts (Username, Salt, PasswordHash, Role, PatientID, ClinicianID) VALUES
 ('admin',        'a1b2c3d4e5f60718', SHA2(CONCAT('a1b2c3d4e5f60718', 'Admin#2026'),   256), 'Administrator', NULL,    NULL),
 ('reception1',   '1f2e3d4c5b6a7980', SHA2(CONCAT('1f2e3d4c5b6a7980', 'Front#Desk1'),  256), 'Receptionist',  NULL,    NULL),
 ('reception2',   '0a9b8c7d6e5f4a3b', SHA2(CONCAT('0a9b8c7d6e5f4a3b', 'Front#Desk2'),  256), 'Receptionist',  NULL,    NULL),
 ('dr.shah',      'c0ffee1234567890', SHA2(CONCAT('c0ffee1234567890', 'Glaucoma!1'),   256), 'Doctor',        NULL,    1),
 ('dr.grant',     'deadbeef00112233', SHA2(CONCAT('deadbeef00112233', 'Retina!2'),     256), 'Doctor',        NULL,    2),
 ('dr.nair',      'feedface44556677', SHA2(CONCAT('feedface44556677', 'Cornea!3'),     256), 'Doctor',        NULL,    3),
 ('op001.amina',  '1234567890abcdef', SHA2(CONCAT('1234567890abcdef', 'Amina#001'),    256), 'Patient',       'OP001', NULL),
 ('op002.daniel', 'abcdef1234567890', SHA2(CONCAT('abcdef1234567890', 'Daniel#002'),   256), 'Patient',       'OP002', NULL),
 ('op003.sofia',  '0f1e2d3c4b5a6978', SHA2(CONCAT('0f1e2d3c4b5a6978', 'Sofia#003'),    256), 'Patient',       'OP003', NULL),
 ('op004.michael','9876543210fedcba', SHA2(CONCAT('9876543210fedcba', 'Michael#004'),  256), 'Patient',       'OP004', NULL);

-- =====================================================================
-- 8. CONTROLLED UPDATE  (Part B requirement)
-- =====================================================================
-- Before normalisation, changing Amina's postcode meant editing every
-- appointment row.  Now it is ONE row in ONE table; every appointment
-- automatically reflects it through the foreign key.
SELECT PatientID, FullName, Postcode FROM patients WHERE PatientID = 'OP001';

UPDATE patients
SET    Postcode = 'NE1 5CD'
WHERE  PatientID = 'OP001';

SELECT a.AppointmentID, a.AppointmentDateTime, p.FullName, p.Postcode
FROM   appointments a
JOIN   patients p ON p.PatientID = a.PatientID
WHERE  a.PatientID = 'OP001';

-- Restore the Appendix value so the reconstruction query in section 10 matches Appendix 1
UPDATE patients
SET    Postcode = 'NE1 4AB'
WHERE  PatientID = 'OP001';

-- =====================================================================
-- 9. CONTROLLED DELETE  (Part B requirement)
-- =====================================================================
-- 9a. Delete a CANCELLED follow-up plan: a leaf row, no children -> safe.
SELECT * FROM FollowUp WHERE AppointmentID = 17;
DELETE FROM FollowUp WHERE AppointmentID = 17 AND Status = 'Cancelled';
SELECT COUNT(*) AS followups_left_for_appt_17 FROM FollowUp WHERE AppointmentID = 17;

-- 9c. Referential integrity PROTECTS parents.  The statement below is
--     expected to FAIL with error 1451 (row is referenced by appointments).
--     Run it on its own in Workbench to capture the error for the test log:
--     DELETE FROM patients WHERE PatientID = 'OP003';

-- =====================================================================
-- 10. TEST LOG
-- =====================================================================
-- Appendix identifiers are fixed by the insertion order on a clean build.
-- UserAccounts has no Appendix rows. Every synthetic_count should be >= 10.
SELECT 'specialties' AS table_name, COUNT(*) AS synthetic_count FROM specialties WHERE SpecialtyID > 3
UNION ALL SELECT 'clinicians',   COUNT(*) FROM clinicians   WHERE ClinicianID > 3
UNION ALL SELECT 'patients',     COUNT(*) FROM patients     WHERE PatientID NOT IN ('OP001', 'OP002', 'OP003', 'OP004')
UNION ALL SELECT 'clinics',      COUNT(*) FROM clinics      WHERE ClinicID > 3
UNION ALL SELECT 'appointments', COUNT(*) FROM appointments WHERE AppointmentID > 5
UNION ALL SELECT 'Diagnosis',    COUNT(*) FROM Diagnosis    WHERE AppointmentID > 5
UNION ALL SELECT 'medicines',    COUNT(*) FROM medicines    WHERE MedicineID > 4
UNION ALL SELECT 'prescription', COUNT(*) FROM prescription WHERE AppointmentID > 5
UNION ALL SELECT 'FollowUp',     COUNT(*) FROM FollowUp     WHERE AppointmentID > 5
UNION ALL SELECT 'UserAccounts', COUNT(*) FROM UserAccounts;

SELECT 'specialties'  AS table_name, COUNT(*) AS row_count FROM specialties
UNION ALL SELECT 'clinicians',   COUNT(*) FROM clinicians
UNION ALL SELECT 'patients',     COUNT(*) FROM patients
UNION ALL SELECT 'clinics',      COUNT(*) FROM clinics
UNION ALL SELECT 'appointments', COUNT(*) FROM appointments
UNION ALL SELECT 'Diagnosis',    COUNT(*) FROM Diagnosis
UNION ALL SELECT 'medicines',    COUNT(*) FROM medicines
UNION ALL SELECT 'prescription', COUNT(*) FROM prescription
UNION ALL SELECT 'FollowUp',     COUNT(*) FROM FollowUp
UNION ALL SELECT 'UserAccounts', COUNT(*) FROM UserAccounts;

-- Orphan check: every FK value must exist in its parent (expect all zeros)
SELECT 'appointments -> patients' AS relationship, COUNT(*) AS orphan_count
FROM appointments a LEFT JOIN patients p ON p.PatientID = a.PatientID WHERE p.PatientID IS NULL
UNION ALL SELECT 'appointments -> clinicians', COUNT(*)
FROM appointments a LEFT JOIN clinicians c ON c.ClinicianID = a.ClinicianID WHERE c.ClinicianID IS NULL
UNION ALL SELECT 'prescription -> appointments', COUNT(*)
FROM prescription r LEFT JOIN appointments a ON a.AppointmentID = r.AppointmentID WHERE a.AppointmentID IS NULL
UNION ALL SELECT 'Diagnosis -> appointments', COUNT(*)
FROM Diagnosis d LEFT JOIN appointments a ON a.AppointmentID = d.AppointmentID WHERE a.AppointmentID IS NULL
UNION ALL SELECT 'FollowUp -> appointments', COUNT(*)
FROM FollowUp f LEFT JOIN appointments a ON a.AppointmentID = f.AppointmentID WHERE a.AppointmentID IS NULL
UNION ALL SELECT 'clinicians -> specialties', COUNT(*)
FROM clinicians c LEFT JOIN specialties s ON s.SpecialtyID = c.SpecialtyID WHERE c.SpecialtyID IS NOT NULL AND s.SpecialtyID IS NULL
UNION ALL SELECT 'appointments -> clinics', COUNT(*)
FROM appointments a LEFT JOIN clinics cl ON cl.ClinicID = a.ClinicID WHERE cl.ClinicID IS NULL
UNION ALL SELECT 'prescription -> medicines', COUNT(*)
FROM prescription r LEFT JOIN medicines m ON m.MedicineID = r.MedicineID WHERE m.MedicineID IS NULL
UNION ALL SELECT 'UserAccounts -> patients', COUNT(*)
FROM UserAccounts u LEFT JOIN patients p ON p.PatientID = u.PatientID WHERE u.PatientID IS NOT NULL AND p.PatientID IS NULL
UNION ALL SELECT 'UserAccounts -> clinicians', COUNT(*)
FROM UserAccounts u LEFT JOIN clinicians c ON c.ClinicianID = u.ClinicianID WHERE u.ClinicianID IS NOT NULL AND c.ClinicianID IS NULL;

-- Appendix 1 reconstructed from the normalised tables (proves no data lost)
SELECT p.PatientID, p.FullName, p.Postcode, c.FullName AS Clinician, s.SpecialtyName,
       cl.ClinicName, DATE(a.AppointmentDateTime) AS VisitDate, TIME(a.AppointmentDateTime) AS VisitTime,
       GROUP_CONCAT(DISTINCT d.Diagnosisname ORDER BY d.DID SEPARATOR '; ') AS Diagnoses,
       COALESCE(GROUP_CONCAT(DISTINCT m.MedicineName ORDER BY m.MedicineID SEPARATOR ', '), 'None') AS Medicines,
       f.DueDate, f.Priority, a.Notes
FROM   appointments a
JOIN   patients   p  ON p.PatientID    = a.PatientID
JOIN   clinicians c  ON c.ClinicianID  = a.ClinicianID
LEFT JOIN specialties s ON s.SpecialtyID = c.SpecialtyID
JOIN   clinics    cl ON cl.ClinicID    = a.ClinicID
LEFT JOIN Diagnosis    d ON d.AppointmentID = a.AppointmentID
LEFT JOIN prescription r ON r.AppointmentID = a.AppointmentID
LEFT JOIN medicines    m ON m.MedicineID    = r.MedicineID
LEFT JOIN FollowUp     f ON f.AppointmentID = a.AppointmentID
WHERE  a.AppointmentID <= 5
GROUP  BY a.AppointmentID, p.PatientID, p.FullName, p.Postcode, c.FullName, s.SpecialtyName,
       cl.ClinicName, a.AppointmentDateTime, f.DueDate, f.Priority, a.Notes
ORDER  BY a.AppointmentID;
