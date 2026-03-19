---
front-matter-title: Complex Care Clinical Notes View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-complex-care-clinical-notes.sql
last_updated: 2025-01-16
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
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# Complex Care Clinical Notes View Definition

## Purpose

Provides a full record of notes on patients referred for Mercy BEACN cohort consideration to the Complex Care Clinical Committee. Includes fields to capture decision, rationale for the decision, the reasons for ineligibility (if relevant), other outcomes, and notes. This will support reporting on the patient selection process for Mercy BEACN.

## Description

- Built on `PWCOMPLEXCARECLINICALNOTES`.  
- Filters to current records (`DOCREVNO = '0'`).  
- Outputs key cohort selection indicators.  
- Provides traceability through `DOCSERNO`, `PARENTDOCSERNO`, and visit metadata.

### Logic Summary

- **Source Table:** `PWCOMPLEXCARECLINICALNOTES`.  
- **Client Join:** `CLIENTNUMBER` aligns with `Q_CLIENT_BHN`.  
- **Filters:** `DOCREVNO = '0'` excludes revised/voided records.  
- **Output:**  
  - Visit metadata (`VISIT_DATE`, `VISITTM`, `USERID`).  
  - Pathway Date.  
  - Clinical Committee meeting date.  
  - Committee decision, rationale for decision, reason for ineligibility, and other outcomes.  
  - Free text field for notes.  
  - Tie‑to‑enrollment indicator (`TIEDENROLLMENT`).  

## Output Fields

| Field Name                                  | Description |
|---------------------------------------------|-------------|
| `ID`                                        | Internal record identifier |
| `DOCSERNO`                                  | Document serial number |
| `VISIT_DATE`, `VISITTM`, `USERID`           | Metadata for audit and traceability |
| `PARENTDOCSERNO`                            | Parent form reference |
| `CLIENT_NUMBER`                             | Unique client identifier |
| `PATHWAY_DATE`                              | Date of pathway form |
| `CLINICAL_COMMITTEE_MEETING_DATE`           | Date the client was discussed at the clinical meeting |
| `DECISION`                                  | Commitee decision regarding cohort selection |
| `COMPLEX_CARE_CLINICAL_COMMITTEE_RATIONALE` | Rationale given for decision |
| `COMPLEX_CARE_REASONS_INELIGIBLE`           | Reasons for ineligibility (when relevant) |
| `COMPLEX_CARE_OTHER_OUTCOMES`               | Other possible outcomes for the patient beyond cohort selection |
| `CLINICAL_NOTES`                            | Notes on meeting and discussion |
| `TIEDENROLLMENT`                            | Join key for Pathway and enrollment |

## Maintenance Notes

- **Form Updates:** If new fields are added to `PWCOMPLEXCARECLINICALNOTES`, update this view accordingly.  
- **Client Scope:** Confirm linkage to Complex Care clients remains valid.  
- **Audit Integrity:** Continue filtering on `DOCREVNO = '0'` to exclude superseded records.  

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-01-15**: Changes alias `COMPRAT` to `COMRAT` since this represents `COMPLEX_CARE_CLINICAL_COMMITTEE_RATIONALE`. There is no 'P'. Adds `C.CLIENT_NAME` from `Q_CLIENT_BHN` so that Quick Reports can add a parameter to filter on this column.

</details>

<details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

- **2025-12-16**: Adds joins to master tables using `LEFT JOIN COMPLEX_CARE_CLINICAL_COMMITTEE_RATIONALE AS [COMPRAT]`, `LEFT JOIN COMPLEX_CARE_REASONS_INELIGIBLE AS [COMPINELIGIBLE]`, `LEFT JOIN COMPLEX_CARE_OTHER_OUTCOMES AS [COMPOTHOUT]`.
- **2025-12-09**: Adds initial view definition to support patient selection reporting for Complex Care clients. Adds initial Markdown documentation.

</details>
</details>
<!---CHANGELOG-END--->
