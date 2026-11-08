# Crownfield Eye Hospital – Ophthalmology Database

**Module:** CPU4:103 Introduction to Database (Level 4, June 2025 cohort)
**Student:** Iulian Mucuta
**Group:** Iulian Mucuta · Petter Junior · Marilene Dukaj
**DBMS:** MySQL Community Server 8.0.16 or later (tested on 9.7.4, Windows 11, MySQL Workbench 8.0)

A fictional teaching scenario: a relational prototype that replaces the paper / Word / Excel
records of an eye hospital's outpatient service with a normalised MySQL database, including
roles, hashed credentials, transactions and injection-safe query examples.

---

## Repository structure

| File | Purpose | Ownership |
|---|---|---|
| [`SQL/01_schema.sql`](SQL/01_schema.sql) | Part B – `CREATE DATABASE`, 10 tables, PK/FK/UNIQUE/NOT NULL/DEFAULT/CHECK, `ALTER TABLE` | Group schema, implemented by Iulian Mucuta |
| [`SQL/01b_sample_data.sql`](SQL/01b_sample_data.sql) | Part B – Appendix 1 rows + at least 10 additional synthetic rows per main table, controlled `UPDATE`/`DELETE`, synthetic and total counts, orphan check | Iulian Mucuta |
| [`SQL/02_individual_queries.sql`](SQL/02_individual_queries.sql) | Part C queries 1–4: GROUP BY/HAVING, 5-table INNER JOIN, LEFT JOIN, CTE + subquery | **Individual – Iulian Mucuta** |
| [`SQL/03_procedure_and_trigger.sql`](SQL/03_procedure_and_trigger.sql) | Part C queries 5–6: `sp_patient_history(IN)` and a trigger enforcing the follow-up due-date rule | **Individual – Iulian Mucuta** |
| [`SQL/04_security.sql`](SQL/04_security.sql) | Part D: 4 roles + access matrix, users, row-filtered patient view, salted SHA-256, SQL-injection demo with prepared statements, transactions | **Individual – Iulian Mucuta** |
| [`05_ERD/Crownfield_Workbench_Model.mwb`](05_ERD/Crownfield_Workbench_Model.mwb) | Editable MySQL Workbench model built in the workshop | Group |
| [`05_ERD/Workbench_EER_workshop_version.png`](05_ERD/Workbench_EER_workshop_version.png) | Group ER diagram of the nine clinical tables (Part A2) | Group |

The individual report, presentation slides and recording are submitted separately through Moodle,
not as part of this code repository.

## Setup and execution order

**Use a disposable teaching server.** `SQL/01_schema.sql` drops and recreates
`crownfield_eye_hospital`, including any existing data. `SQL/04_security.sql` drops and recreates
named MySQL users and roles and modifies the sample data. Back up first; do not run these scripts on
a shared or production server.

1. Install MySQL Server 8.0.16+ and MySQL Workbench. Connect as `root` or a DBA account with
   permission to manage the database, its objects, users, roles and grants.
2. Run the five files in the order shown above. In Workbench, open each file from `SQL/` using
   *File ▸ Open SQL Script*, then execute it. Alternatively, from the repository root in Windows
   Command Prompt (`cmd`, not PowerShell), run:

   ```cmd
   mysql -u root -p < SQL\01_schema.sql
   mysql -u root -p < SQL\01b_sample_data.sql
   mysql -u root -p < SQL\02_individual_queries.sql
   mysql -u root -p < SQL\03_procedure_and_trigger.sql
   mysql -u root -p < SQL\04_security.sql
   ```

3. Examples intended to fail are commented out in the sample-data and procedure/trigger scripts.
   Run them individually in Workbench when checking the errors.
4. After the security script, connect as a demonstration user such as `dr.shah` or `op001.amina`.
   The demo passwords are defined in `SQL/04_security.sql`. For example, when connected as `dr.shah`,
   attempting `DELETE FROM crownfield_eye_hospital.patients WHERE PatientID = 'OP012';` should be
   denied with error 1142.

The procedure/trigger script inserts a valid follow-up, and the security script commits a demo
patient. Rebuild from the first script to restore the starting dataset; some query results also
depend on the current date.

## Database overview

Ten InnoDB tables (`utf8mb4`): `patients`, `clinicians`, `specialties`, `clinics`,
`appointments`, `Diagnosis`, `medicines`, `prescription`, `FollowUp`, `UserAccounts`. The nine
clinical tables evolved from the group's workshop model. The workshop ERD is an earlier design,
so some relationships differ from the final implementation in `SQL/01_schema.sql`. `UserAccounts`
is a Part D support table (salted password hashes) and is not part of the clinical ERD.

Key integrity controls: three NOT NULL FKs on `appointments`; `UNIQUE (ClinicianID, AppointmentDateTime)`
(no double booking); `UNIQUE (AppointmentID, MedicineID)` (one line per medicine per visit);
`UNIQUE FollowUp.AppointmentID` (zero-or-one plan); CHECK vocabularies on `Priority`, `Status`,
`Role` and the `OPnnn` patient-id pattern; `ON DELETE CASCADE` on visit children, `RESTRICT` on master data.

## Assumptions

* Each Appendix 1 row is one appointment; a surrogate `AppointmentID` is introduced. Date and
  time are stored as one `DATETIME`.
* `PatientID` (`OPnnn`) is the natural key of a patient.
* "Latanoprost | Timolol" is two prescription items; dose, route, frequency and duration were not
  supplied and are coherent synthetic values.
* "None" under Medicines means no prescription; it is represented by the absence of rows.
* Follow-up `DueDate` = appointment date + the interval given (e.g. 05 Oct 2026 + 6 weeks =
  16 Nov 2026). `Priority` ∈ {Routine, High, Urgent}; `Status` ∈ {Pending, Scheduled, Completed, Cancelled}.
* A clinician *may* have one specialty, so `SpecialtyID` is nullable.
* The names, identifiers, addresses and passwords in the sample database are synthetic. Passwords
  in the scripts are public teaching-demo values only and must not be used in a real system.

## Personal contribution (Iulian Mucuta)

Built the Workbench model with the group in the workshop; redesigned the `prescription` and
`Diagnosis` tables (surrogate keys, per-item attributes, removal of redundant FKs); wrote the
dependency analysis and 3NF schema; implemented and tested every SQL file in this repository;
wrote the six individual queries, the trigger, the stored procedure,
the role model and the security demonstrations.
