---
front-matter-title: Complex Care Alerting Follow-Up View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-complex-care-alerting-follow-up.sql
last_updated: 2026-06-15
status: active
lifecycle: production
program_scope: single
programs:
  - complex-care
tags:
  - clinical-notes
  - alerting-follow-up
  - complex-care
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# Complex Care Alerting Follow-Up View Definition

## Purpose

Provides a one‑row‑per‑enrollment view of **Alerting Follow‑up** notes documented by the contracted treatment provider for patients selected for the cohort in the **Clinical BEACN Complex Care** program.  
This view supports weekly operational workflows in which the program manager reviews Admission, Transfer, and Discharge (ATD) alerts from the PointClickCare HIE and verifies whether outreach was attempted for high‑alert‑volume clients.

If outreach was **not** attempted, the program manager documents the reason.  
This view surfaces those follow‑up records for reporting, monitoring, and quality‑improvement analysis.

## Description

- Extracts **Alerting Follow‑up** notes from `PWCOMPLEXCARECLINICALNOTES`, which now contains branching logic separating:
  - **Referral / Cohort Selection** notes  
  - **Alerting Follow‑up** notes  
- Ensures **one row per enrollment** by filtering to `NOTE_TYPE = 'Alerting Follow-up'` and `DOCREVNO = ' 0 '`.
- Joins to `Q_CLIENT_BHN` to provide standardized client metadata.
- Joins to `COMPLEX_CARE_REASON_NO_OUTREACH` to surface descriptive text for documented non‑outreach reasons.
- Complements `Q_COMPLEX_CARE_CLINICAL_NOTES`, which handles the referral/cohort‑selection branch.

### Logic Summary

- **Source Table:**  
  - `PWCOMPLEXCARECLINICALNOTES` (`CNOTE`)

- **Joins:**  
  - `INNER JOIN Q_CLIENT_BHN` (`C`) on `CLIENT_NUMBER`  
  - `LEFT JOIN COMPLEX_CARE_REASON_NO_OUTREACH` (`CNOOUTREASON`) for descriptive reason text

- **Key Filters:**  
  - `DOCREVNO = ' 0 '` (current version only)  
  - `NOTE_TYPE = 'Alerting Follow-up'`  

- **Output Fields:**  
  - Client identifiers and name  
  - Visit and meeting dates  
  - Alerting follow‑up metadata  
  - Outreach response and reason codes/descriptions  
  - Enrollment linkage (`TIEDENROLLMENT`)

## Columns Returned

| Column | Description |
|--------|-------------|
| `CLIENT_NUMBER` | Unique BHN client identifier |
| `CLIENT_NAME` | Full client name from `Q_CLIENT_BHN` |
| `VISIT_DATE` | Date of the alerting follow‑up note |
| `VISIT_TIME` | Time of the alerting follow‑up note |
| `USERID` | User who entered the follow‑up note |
| `PARENT_DOCSERNO` | Parent document serial number |
| `PATHWAY_DATE` | Date the client was added to the cohort |
| `MEETING_DATE` | Date of the clinical committee meeting (if applicable) |
| `NOTE_TYPE` | Note type (always `Alerting Follow-up` in this view) |
| `PCC_NOTIFICATION` | Whether a PCC alert was received |
| `NUM_PCC_ALERTS` | Number of PCC alerts for the client |
| `OUTREACH_RESPONSE` | Documented outreach attempt or response |
| `REASON_NO_OUTREACH_CODE` | Code indicating why outreach was not attempted |
| `REASON_NO_OUTREACH_DESCRIPTION` | Description of the non‑outreach reason |
| `OTHER_REASON_NO_OUTREACH` | Free‑text explanation when the coded reason is insufficient |
| `TIEDENROLLMENT` | Enrollment identifier linking the note to the current cohort episode |

## Maintenance Notes

- This view must remain aligned with the branching logic in `PWCOMPLEXCARECLINICALNOTES`.  
  If additional note types are added, update filters accordingly.
- `Q_CLIENT_BHN` provides standardized client metadata; ensure upstream logic remains stable.
- If new non‑outreach reasons are added, ensure `COMPLEX_CARE_REASON_NO_OUTREACH` remains synchronized.
- This view is designed for **one‑to‑one cardinality** with the current enrollment.  
  Do not introduce joins that would multiply rows.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
<!---CHANGELOG-END--->
