# Q_EPICC_LATEST_SU_TX_AGENCY

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-epicc-latest-su-tx-agency.sql`  
**Last Updated:** **2025-08-10**  
**Author:** Bradley Wing  
**Lifecycle:** `Production`

---

## Purpose

Returns the most recent substance use treatment agency referral record for each EPICC client. Supports reporting and analysis based on the latest available referral data, including inferred parent form linkage for imported records.

## Description

- Built on `PWSUBROADTREATMENTAGENCY`, filtered to current records (`DOCREVNO = ' 0 '`).
- Uses `Q_CLIENT_BHN` to exclude test clients.
- Enriches agency codes with descriptions via `EPICC_SU_TX_AGENCY`.
- Infers missing `PARENTDOCSERNO` for imported records using form-matching logic.
- Applies tie-breaking logic to ensure one record per client based on `VISITDT`, `DOCSERNO`, and `PARENTDOCSERNO`.
- Includes `SU_TX_INTAKE` indicator for whether client attended intake with `INTAKE_NOT_COMPLETED` for the reason if the client did not attend intake and `SU_TX_DATE` if the client did attend intake.
- Includes `COACH_ATTEND_INTAKE` and `CES_ATTEND_INTAKE` indicator columns.

### Logic Summary

- **FORM_MATCH CTE**
  - Matches `START_DATE` to `PATHWAY_DATE` across EPICC forms to infer `DOCSERNO`.

- **INFERREDSUTX CTE**
  - Applies `COALESCE` logic to resolve missing `PARENTDOCSERNO` for imported records.

- **LATESTVISITDATE CTE**
  - Identifies the most recent `VISITDT` per client.

- **LATESTSUTXRECORD CTE**
  - Filters to records with the latest visit date and joins to agency descriptions.

- **FINALSELECTION CTE**
  - Applies final tie-breaking using max `DOCSERNO` and `PARENTDOCSERNO`.

## Output Fields

| Field Name                         | Description |
|------------------------------------|-------------|
| `CLIENT_NUMBER`                    | Unique client identifier |
| `DOCSERNO`                         | Document reference for the referral |
| `PARENT_DOCSERNO`                  | Reporting interval form (inferred if needed) |
| `VISITDT`                          | Date of referral entry |
| `EPICC_SU_TX_AGENCY_CODE`         | Referral agency code |
| `EPICC_SU_TX_AGENCY_DESCRIPTION`  | Human-readable agency name |
| `USERID`                           | User who entered the record |

## Maintenance Notes

- **Form Expansion**: Update `FORM_MATCH` if new EPICC forms are added to the workflow.
- **Agency Lookup**: Ensure `EPICC_SU_TX_AGENCY` remains aligned with form codes.
- **Test Client Filtering**: Confirm `Q_CLIENT_BHN` continues to exclude test clients reliably.
- **Parent Inference Logic**: This view does not persist inferred values; consider a data patch routine if needed.

## Changelog

- **2025-08-14**: Adds `SU_TX_INTAKE`, `INTAKE_NOT_COMPLETED`, `SU_TX_DATE`, `COACH_ATTEND_INTAKE`, and `CES_ATTEND_INTAKE`.
- **2025-08-10**: Initial Markdown documentation authored.  
- **2025-05-06**: View created to support reporting on latest substance use treatment referrals for EPICC clients.
