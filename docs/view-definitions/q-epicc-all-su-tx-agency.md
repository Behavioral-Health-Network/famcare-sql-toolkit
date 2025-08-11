# Q_EPICC_ALL_SU_TX_AGENCY

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-epicc-all-su-tx-agency.sql`  
**Last Updated:** **2025-08-10**  
**Author:** BHN Data Team  

## Purpose

Returns all substance use treatment agency referral records for EPICC clients.  
Supports longitudinal tracking of referrals, intake outcomes, and agency engagement across multiple forms.

## Description

- Built on `PWSUBROADTREATMENTAGENCY`, which includes only EPICC records.
- Filters to current records (`DOCREVNO = ' 0 '`).
- Joins with `Q_CLIENT_BHN` to exclude test clients.
- Enriches agency codes with descriptions via `EPICC_SU_TX_AGENCY`.
- Uses `CTE_FORM_MATCH` to infer missing `PARENTDOCSERNO` for imported records.

### Logic Summary

- **Client Join**
  - Uses `Q_CLIENT_BHN` to exclude test clients based on last name variants.

- **Agency Description**
  - Joins to `EPICC_SU_TX_AGENCY` for both referral and PFH facility descriptions.

- **Parent Form Inference**
  - Uses `CTE_FORM_MATCH` to infer `PARENTDOCSERNO` when missing and `USERID LIKE 'import%'`.

- **Date Casting**
  - Casts all relevant dates to `DATE` format for consistency.

## Output Fields

| Field Name                             | Description |
|----------------------------------------|-------------|
| `CLIENT_NUMBER`, `PATHWAY_DATE`, `START_DATE`, `END_DATE` | Referral timing and linkage |
| `PARENT_DOCSERNO`                      | Reporting interval form (inferred if needed) |
| `EPICC_SU_TX_AGENCY_CODE`, `EPICC_SU_TX_AGENCY_DESCRIPTION` | Referral agency |
| `PFH_TX_FACILITY_CODE`, `PFH_TX_FACILITY_DESCRIPTION`       | PFH facility |
| `SU_TX_INTAKE_DATE`, `SU_TX_INTAKE`    | Intake date and status |
| `WAS_INTAKE_COMPLETED`, `INTAKE_NOT_COMPLETED`, `INTAKE_NOT_COMPLETED_OTHER` | Intake outcome |
| `COACH_ATTEND_INTAKE`, `CES_ATTEND_INTAKE`, `COACH_NOT_ATTEND_INTAKE`, `CES_NOT_ATTEND_INTAKE` | Attendance flags |
| `IF_OTHER_SPECIFY`                     | Free-text agency specification |

## Maintenance Notes

- **Form Expansion**: Update `CTE_FORM_MATCH` if new EPICC forms are added to the workflow.
- **Agency Lookup**: Ensure `EPICC_SU_TX_AGENCY` remains aligned with form codes.
- **Test Client Filtering**: Confirm `Q_CLIENT_BHN` continues to exclude test clients reliably.
- **Parent Inference Logic**: This view does not persist inferred values; consider a data patch routine if needed.

## Changelog

- **2025-08-10**: Initial Markdown documentation authored.  
- **2025-06-09**: View created to support full referral tracking to substance use treatment agencies for EPICC clients.
