---
front-matter-title: Duplicate YERE Needs Forms When Comparing Youth / Family Needs vs Client or Caregiver Exception Report
category: Exception Reports
source_file: code/exception-reports/dup-yere-needs-forms-youth-family-vs-client-caregiver.sql
last_updated: 2026-07-07
status: active
lifecycle: production
program-scope: single
programs:
  - yere
tags:
  - exception-logic
  - client-needs
  - caregiver-needs
  - client-family-needs
change_control: cross-repo-coordination
schema_version: 1.0
---

# Duplicate YERE Needs Forms When Comparing Youth / Family Needs vs Client or Caregiver

## Purpose

Identify YERE enrollments where more than one **Needs** form has been submitted for the same `TIEDENROLLMENT`.  
Each enrollment is allowed to have one client **or** one caregiver needs form, but they cannot also have a youth / family needs form at the same time.
Vise versa, each enrollment is allowed to have one youth / family needs form, but they cannot also have either a client **or** caregiver needs form.
Multiple submissions indicate a documentation error that can distort reporting, summations, and program performance metrics.

Client and caregiver needs forms were introduced at the beginning of FY26. Youth / Family needs forms were introduced at the beginning of FY27. 
Ideally all client and caregiver needs forms would be changed into a youth / family needs form, but that is a large task.
Instead, any active or re-referred clients will have their client and caregiver needs forms replaced by a youth / family needs form.
Once a youth / family needs form exists for a client, at an enrollment / case level, the client and / or caregiver needs forms need to be deleted.

This exception report supports YERE program data quality review and remediation.

## Description

This query evaluates the relationship between:

- YERE enrollments (`Q_YERE_PATHCLIENT_ENROLLMENTS`)
- client demographic records (`Q_CLIENT_BHN`)
- youth client needs forms (`Q_YERE_CLIENT_NEEDS`)
- youth caregiver needs forms (`Q_YERE_CAREGIVER_NEEDS`)
- youth / family needs forms (`Q_YERE_CLIENT_FAMILY_NEEDS`)

The logic:

- Joins client needs forms to enrollments using both `CLIENT_NUMBER` and `PARENTDOCSERNO` to ensure the forms belongs to the correct episode of care.
- Filters for clients that have a `TIEDENROLLMENT` value, have a client and / or caregiver needs form, and youth / family needs form
- Returns only those enrollments where all three of the filters described above are present

This identifies cases where staff submitted multiple youth needs forms for the same enrollment, which violates the expected workflow and may require correction in FAMCare.

## Output Columns

| Field Name                     | Description |
|--------------------------------|-------------|
| `CLIENT_NUMBER`                | Unique BHN client identifier. |
| `TIEDENROLLMENT`               | Unique identifier for the YERE enrollment episode. |
| `Client Needs Present`         | DOCSERNO of the Client Needs Form, if present. |
| `Caregiver Needs Present`      | DOCSERNO of the Caregiver Needs Form, if present. |
| `Youth / Family Needs Present` | DOCSERNO of the Youth / Family Needs Form. |

## Maintenance Notes

- This report depends on the stability of `Q_YERE_PATHCLIENT_ENROLLMENTS`, `Q_YERE_CLIENT_NEEDS`, `Q_YERE_CAREGIVER_NEEDS`, and `Q_YERE_CLIENT_FAMILY_NEEDS`. Any changes to Pathway Event logic, form structure, or parent/child relationships may require updates.
- Duplicate needs forms may result from staff resubmissions, incorrect form selection, or workflow inconsistencies. Program staff should review and resolve duplicates directly in FAMCare.
- If YERE introduces new needs workflows or modifies form behavior, the join and filter logic may need revision.
- The query intentionally does not filter on completion dates; it flags all duplicate submissions regardless of status.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-07-07**: Initial upload.

</details>
</details>
<!---CHANGELOG-END--->
