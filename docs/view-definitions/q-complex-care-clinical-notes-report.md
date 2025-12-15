---
front-matter-title: Q_COMPLEX_CARE_CLINICAL_NOTES_REPORT
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-complex-care-clinical-notes-report.sql
last_updated: 2025-12-09
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - complex-care
tags:
  - sql-view
  - summation-view
  - program-docs
dependencies:
  - name: pwcomplexcareclinicalnotes
    type: html
    repo: famcare-html-form-code
  - name: pwcomplexcareclinicalnotes
    type: table
    repo: none
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
  - name: q-complex-care-pathclient-enrollments
    type: sql
    repo: famcare-sql-toolkit
  - name: q-complex-care-roster
    type: sql
    repo: famcare-sql-toolkit
  - name: q-complex-care-pathclient-enrollments
    type: sql
    repo: famcare-sql-toolkit
  - name: q-complex-care-mercy-beacn-benchmarks
    type: sql
    repo: famcare-sql-toolkit
  - name: q-complex-care-active-housing-status
    type: sql
    repo: famcare-sql-toolkit
  - name: q-complex-care-active-payor-source
    type: sql
    repo: famcare-sql-toolkit
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-12-09
last_reviewed: 2025-12-09
schema_version: 1.0
---

# Q_COMPLEX_CARE_CLINICAL_NOTES_REPORT

## Purpose

Provides a full record of notes on patients referred for Mercy BEACN cohort consideration to the Complex Care Clinical Committee. Includes fields to capture decision, rationale for the decision, the reasons for ineligibility (if relevant), other outcomes, and notes. Also includes various required metrics from the Mercy BEACN Benchmark form, including enrollment date, admission date, treatment team assignment date. This data is supplemented with the latest housing status on record for the client and the latest payor source recorded. This will support program management for Mercy BEACN.

## Description

- Built on `Q_COMPLEX_CARE_CLINICAL_NOTES` with joins to roster, benchmarks, housing, and payor source views.  
- Filters to current records (`DOCREVNO = '0'`) to exclude revised/voided forms.  
- Produces one row per client enrollment episode, combining committee notes with program enrollment and status data.  
- Provides traceability through `DOCSERNO`, `PARENTDOCSERNO`, and `TIEDENROLLMENT`.  
- Ensures latest housing and payor source statuses are included for context.

### Logic Summary

- **Source Tables/Views:**  
  - `PWCOMPLEXCARECLINICALNOTES` (clinical notes form)  
  - `Q_COMPLEX_CARE_PATHCLIENT_ENROLLMENTS` (episode of care referral data based on FAMCare enrollment metadata)  
  - `Q_COMPLEX_CARE_ROSTER` (cohort selection date)  
  - `Q_COMPLEX_CARE_MERCY_BEACN_BENCHMARKS` (program enrollment, admission, treatment team assignment)  
  - `Q_COMPLEX_CARE_ACTIVE_HOUSING_STATUS` (latest housing status)  
  - `Q_COMPLEX_CARE_ACTIVE_PAYOR_SOURCE` (latest payor source)  
  - `Q_CLIENT_BHN` (client demographics and identifiers)  
- **Joins:**  
  - Episode linkage via `CLIENT_NUMBER` and `DOCSERNO`/`PARENTDOCSERNO`/`TIEDENROLLMENT`.  
  - Left joins to roster, housing, payor, and notes views to enrich benchmark data.  
- **Output:**  
  - Client demographics and identifiers.  
  - Cohort and program enrollment dates.  
  - Admission and treatment team assignment dates.  
  - Clinical committee meeting metadata, decision, rationale, reasons, other outcomes, and notes.  
  - Latest housing and payor source statuses.

## Output Fields

| Field Name                          | Description |
|-------------------------------------|-------------|
| `CLIENT_NUMBER`                     | Unique client identifier |
| `CLIENT_LAST`, `CLIENT_FIRST`       | Client name |
| `DOB`                               | Date of birth |
| `MRN_MERCY`                         | Mercy medical record number |
| `DATE OF CLINICAL NOTE`             | Committee meeting date |
| `CLINICAL_COMMITTEE_DECISION`       | Committee decision regarding cohort selection |
| `COMPLEX_CARE_CLINICAL_COMMITTEE_RATIONALE` | Rationale for decision |
| `COMPLEX_CARE_REASONS_INELIGIBLE`   | Reasons for ineligibility |
| `COMPLEX_CARE_OTHER_OUTCOMES`       | Other outcomes beyond cohort selection |
| `CLINICAL_COMMITTEE_NOTES`          | Free-text notes from committee |
| `ADDED_COHORT_DATE`                 | Date client was added to cohort roster |
| `ENROLLMENT_DATE`                   | Mercy BEACN enrollment date |
| `ADMISSION_DATE`                    | Admission service date |
| `TREATMENT_TEAM_ASSIGNMENT_DATE`    | Date treatment team was assigned |
| `ADDRESS`, `ZIP_CODE`               | Client address information |
| `CURRENT_HOUSING_STATUS`            | Latest housing status (housed, unhoused, unknown) |
| `CURRENT_PAYOR_SOURCE`              | Latest payor source (insured, uninsured, unknown) |

## Maintenance Notes

- **Form Updates:** Update view if new fields are added to `PWCOMPLEXCARECLINICALNOTES` or related active status views.  
- **Episode Integrity:** Ensure joins on `DOCSERNO`/`PARENTDOCSERNO`/`TIEDENROLLMENT` continue to enforce one-to-one episode linkage.  
- **Audit Integrity:** Continue filtering on `DOCREVNO = '0'` to exclude superseded records.  
- **Dependencies:** Changes to roster, benchmarks, housing, or payor source views may affect output consistency.

## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

</details>

<details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

- **2025-12-09**: Initial view definition to support program management of Mercy BEACN Complex Care program. Adds initial Markdown documentation file.

</details>
</details>
