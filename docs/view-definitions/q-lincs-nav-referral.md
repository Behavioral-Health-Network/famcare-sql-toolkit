---
front-matter-title: LINCS NAV Referral Form View View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-lincs-nav-referral.sql
last_updated: 2026-01-26
status: active
lifecycle: production
program_scope: single
programs:
  - lincs-nav
tags:
  - view-layer
  - exception-logic
change_control:
  - cross-repo-coordination
schema_version: 1.0
---
# LINCS NAV Referral Form View Definition

## Purpose

Provides a structured, analyst‑ready extract of **LINCS Navigator Referral Form** submissions. Supports referral‑source reporting, client pathway validation, and operational monitoring of referral activity across agencies and programs.

## Description

- Pulls raw referral form entries from `PWLINCSNAVREFERRALFORM`.
- Joins to `Q_CLIENT_BHN` to obtain canonical client identity fields.
- Enriches agency and status codes (CMHC, ADA, referral sources) with descriptive text.
- Normalizes date fields using `CAST(... AS DATE)` for consistency across reporting tools.
- Restricts to the current revision of the form (`DOCREVNO = ' 0 '`).

### Logic Summary

- **Client Join**
  - Uses `CLIENTNUMBER` from the NAV referral table to join to `Q_CLIENT_BHN.CLIENT_NUMBER`.
  - Includes client name fields (`CLIENT_LAST`, `CLIENT_FIRST`) for direct reporting.

- **Referral Source and Agency Lookups**
  - `REFERRING_AGENCY` resolved via `PROGRAM_REFERRAL_SOURCES`.
  - CMHC status and CMHC agency resolved via `CIMOR_STATUS` and `CMHC_AGENCY`.
  - ADA substance‑use status and ADA agency resolved via `CIMOR_STATUS` and `ADA_SU_AGENCY`.

- **Date Normalization**
  - Converts `VISITDT` and `PATHWAY_DATE` to `DATE` to remove time components.

- **Event Labeling**
  - Hard‑codes `EVENT_NAME = 'LINCS NAV Referral'` for downstream grouping.

- **Revision Filter**
  - Includes only records where `DOCREVNO = ' 0 '`, ensuring analysts work with the active version of the form.

## Output Fields

Returns one row per referral form submission. Key fields include:

| Field Name | Description |
|------------|-------------|
| `ID`, `DOCSERNO` | Unique identifiers for the NAV referral record |
| `VISIT_DATE`, `VISIT_TIME` | Date and time of the referral encounter |
| `USERID` | Staff member who entered the record |
| `EVENT_NAME` | Constant label for event classification |
| `CLIENT_NUMBER`, `CLIENT_LAST`, `CLIENT_FIRST` | Canonical client identifiers and name fields |
| `PATHWAY_DATE` | Date the referral pathway event occurred |
| `PATIENT_LOCATION_REFERRAL` | Client location at time of referral |
| `ANSWERFIRST_CASE_NUM` | Case number from AnswerFirst |
| `CONTACT_METHOD_AT_REFERRAL` | How the referral contact was initiated |
| `CALLER_NAME`, `CALLERS_DIRECT_NUM` | Caller identity and contact information |
| `REFERRING_AGENCY_CODE`, `REFERRING_AGENCY_DESCRIPTION` | Agency initiating the referral |
| `REFERRAL_METHOD` | Method by which the referral was made |
| `HOUSING_STATUS_REFERRAL` | Housing status at time of referral |
| `CMHC_STATUS_CODE`, `CMHC_STATUS_DESCRIPTION` | CMHC status and description |
| `CIMOR_CMHC_AGENCY_CODE`, `CIMOR_CMHC_AGENCY_DESCRIPTION` | CMHC agency details |
| `OTHER_CMHC_AGENCY` | Free‑text CMHC agency |
| `ADA_SU_STATUS_CODE`, `ADA_SU_STATUS_DESCRIPTION` | ADA substance‑use status and description |
| `CIMOR_ADA_SU_AGENCY_CODE` | ADA agency code |
| `OTHER_ADA_SU_AGENCY` | Free‑text ADA agency |
| `DD_STATUS`, `DM3700_STATUS` | Developmental disability and DM3700 indicators |
| `EMPLOYMENT_STATUS_REFERRAL`, `MILITARY_STATUS` | Employment and military status |
| `REFERRAL_REASON`, `OTHER_REFERRAL_REASON` | Reason for referral |
| `PRESENTING_SU_CONCERN` | Substance‑use concerns at referral |
| `NUM_HOSP_PAST_THREE_MONTHS_REF`, `NUM_PRIOR_INPATIENT_HOSP_REF`, `NUM_ER_VISITS_PAST_THREE_MONTHS_REF` | Recent utilization history |
| `HISTORY_SERIOUS_MENTAL_ILLNESS` | SMI history indicator |
| `LEO_INVOLVEMENT_THIS_VISIT` | Law enforcement involvement |
| `CLIENT_DEAF_OR_HARD_OF_HEARING` | Hearing status |
| `OUTREACH_ADDITIONAL_INFO` | Additional outreach notes |
| `CLIENT_PARTICIPATION`, `PROGRAM_PARTICIPATION` | Participation indicators |
| `INELIGIBLE_REASON`, `INELIGIBLE_OTHER_REASON` | Ineligibility details |
| `PRESENTING_NOTES_REFERRAL` | Narrative notes |
| `ImportID` | Import identifier for ETL lineage |

## Usage Notes

- **Agency Descriptions**: All agency and status codes are enriched with descriptions; downstream tools should use the description fields for reporting.
- **Date Consistency**: All dates are cast to `DATE` to avoid time‑based mismatches in Power BI or Excel.
- **Revision Filtering**: Only revision `' 0 '` is included; if additional revisions are introduced, update the filter accordingly.
- **Client Identity**: `CLIENT_NUMBER` is authoritative; NAV’s `CLIENTNUMBER` should not be used downstream.

## Maintenance Notes

- **Agency Tables**: CMHC, ADA, and referral source tables must remain synchronized with NAV code sets; update joins if new tables or codes are introduced.
- **Form Revisions**: Monitor `DOCREVNO` usage; if new revisions are deployed, consider versioning logic or including a `LATEST` filter.
- **Field Expansion**: NAV forms evolve frequently; review this view after form updates to ensure new fields are captured.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026‑01‑26**: Adds initial view definition of LINCS NAV Referral form. Adds initial Markdown documentation file for the view definition.

</details>
</details>
<!---CHANGELOG-END--->
