---
front-matter-title: BCR PHQ-DASS Behavioral Health Referral Placed With Demographics View Definition
category: view-definitions
category-label: View Definitions
source_file: code/view-definitions/q-bcr-phq-dass-bh-ref-placed-w-demographics.sql
last_updated: 2025-11-24
status: active
lifecycle: production
program_scope: single
programs:
  - bcr
tags:
  - bcr-phq-dass
  - behavioral-health-referrals
  - demographics
  - counseling-sessions
  - housing-status
  - payor-source
dependencies:
  - name: q-bcr-pathclient-enrollments
    type: sql
    repo: famcare-sql-toolkit
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
  - name: pwbcrinitialcontact
    type: html
    repo: famcare-html-form-code
  - name: pwbcrinitialcontact
    type: table
    repo: none
  - name: q-bcr-ic
    type: sql
    repo: famcare-sql-toolkit
  - name: pwbcrreferralsplaced
    type: html
    repo: famcare-html-form-code
  - name: pwbcrreferralsplaced
    type: table
    repo: none
  - name: q-bcr-ref-placed
    type: sql
    repo: famcare-sql-toolkit
  - name: pwbcrclientcounselingsessions
    type: html
    repo: famcare-html-form-code
  - name: pwbcrclientcounselingsessions
    type: table
    repo: none
  - name: bcr-grant
    type: table
    repo: none
  - name: bcr-counseling-agencies
    type: table
    repo: none
  - name: q-bcr-client-counseling-sessions
    type: sql
    repo: famcare-sql-toolkit
  - name: q-bcr-active-housing-status
    type: sql
    repo: famcare-sql-toolkit
  - name: pwhousingstatus
    type: html
    repo: famcare-html-form-code
  - name: pwhousingstatus
    type: table
    repo: none
  - name: q-bcr-all-housing-status
    type: sql
    repo: famcare-sql-toolkit
  - name: q-bcr-active-payor-source
    type: sql
    repo: famcare-sql-toolkit
  - name: pwpayorsource
    type: html
    repo: famcare-html-form-code
  - name: pwpayorsource
    type: table
    repo: none
change_control:
  - cross-repo-coordination
  - internal-review-required
schema_version: 1.0
---

# BCR PHQ-DASS Behavioral Health Referral Placed With Demographics View Definition

## Purpose

Provides a consolidated view of BCR clients who completed PHQ‑9 and DASS assessments at initial contact, had behavioral health referrals placed, and are enriched with demographic, housing, payor source, and counseling session data. Supports evaluation of referral placement outcomes in relation to client demographics and service engagement.

## Description

- Built on `Q_BCR_PATHCLIENT_ENROLLMENTS` to identify BCR clients and enrollment metadata.
- Filters **Initial Contact** events to those with non‑null PHQ‑9 and DASS scores.
- Filters **Referrals Placed** events to those with behavioral health referrals (`BH_REF_PLACED = '1'`).
- Aggregates counseling session counts from `Q_BCR_CLIENT_COUNSELING_SESSIONS`.
- Enriches with demographic attributes from `Q_CLIENT_BHN`.
- Joins to active housing status (`Q_BCR_ACTIVE_HOUSING_STATUS`) and payor source (`Q_BCR_ACTIVE_PAYOR_SOURCE`) for current social determinants of health context.

### Logic Summary

- **INITIAL_CONTACTS CTE**  
  - Selects clients with valid PHQ‑9 and DASS scores at initial contact.  
  - Includes demographics and enrollment dates.  

- **REFERRALS_PLACED CTE**  
  - Selects clients with behavioral health referrals placed.  
  - Includes counseling referral flag and ties to enrollment.  

- **CLIENT_COUNSELING CTE**  
  - Aggregates total counseling sessions per client.  

- **Final SELECT**  
  - Combines initial contact, referral placement, counseling counts, housing status, and payor source.  
  - Produces a demographic‑enriched dataset for outcome analysis.

## Output Fields

| Field Name | Description |
|------------|-------------|
| `CLIENT_NUMBER` | Unique client identifier |
| `CLIENT_LAST`, `CLIENT_FIRST` | Client name fields |
| `ENROLLMENT_STARTING_DATE`, `ENROLLMENT_ENDING_DATE` | Enrollment period |
| `BIRTH_DATE`, `GENDER_DESCRIPTION`, `RACE_DESCRIPTION`, `ETHNICITY_DESCRIPTION` | Demographic attributes |
| `ZIP_CODE`, `COUNTY_DESCRIPTION` | Geographic attributes |
| `PHQ9_SCORE`, `DASS_SCORE_IC` | Assessment scores at initial contact |
| `BH_REF_PLACED` | Flag indicating behavioral health referral placed |
| `COUNSELING_REF_PLACED` | Flag indicating counseling referral placed |
| `COUNT_COUNSELING_SESSIONS` | Total counseling sessions recorded |
| `HOUSING_STATUS_*` | Housing status categories (stably housed, institutionally housed, precariously housed, unhoused, unknown) |
| `HOMELESS_HOUSING_INSECURE_ETO` | Flag for homelessness/housing insecurity |
| `PAYOR_SOURCE_*` | Payor source categories (private insurance, Medicaid, Medicare, dual eligible, uninsured, unknown/refused) |

## Maintenance Notes

- **Assessment Completeness**: Only clients with both PHQ‑9 and DASS scores at initial contact are included.  
- **Referral Placement**: Only clients with `BH_REF_PLACED = '1'` are included in referral CTE.  
- **Counseling Sessions**: Aggregated counts may need QA for session duplication or missing records.  
- **Housing/Payor Sources**: Ensure active status tables are refreshed and aligned with client records.  
- **QA Workflow**:  
  - Validate that clients with referrals placed also appear in counseling session counts.  
  - Spot‑check demographic distributions (e.g., race, ethnicity, payor source) for anomalies.  
  - Investigate clients with missing housing or payor source data.

## Governance Notes

- This view is intended for **program evaluation and reporting**, not transactional use.  
- Contributors should document any changes to referral placement logic or assessment completeness criteria.  
- Ensure alignment with data dictionary definitions for PHQ‑9, DASS, housing status, and payor source fields.  
- Indexing may be required on `CLIENT_NUMBER` and `TIEDENROLLMENT` for performance in downstream joins.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
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

- **2025-11-24**: Adds initial Markdown documentation. Adds view definition, which includes Initial Contact, Referrals Placed, Counseling Sessions, Housing Status, and Payor Source joins.  

</details>
</details>
<!---CHANGELOG-END--->
