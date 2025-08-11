# EPICC IC Opioids of Use Hidden Fields Null.sql

**Category:** Exception Reports  
**Source File:** `code/exception-reports/epicc-ic-opioids-of-use-hidden-fields-null.sql`  
**Last Updated:** 2025-07-31  
**Author:** BHN Data Team  

---

## Purpose  

Flags Initial Contact records where the JavaScript function `updateReportFields()` failed to execute, resulting in missing binary values for opioid use fields. These cases suggest that `EPICC_OPIOIDS_OF_USE` was selected, but the pivoted fields (`OPIOID_OF_USE_*`) remain `NULL`.

Affected records retain values in `EPICC_OPIOIDS_OF_USE` but show `NULL` in one or more corresponding pivot fields, leading to incomplete or misleading data downstream.

## Exception Criteria

| Condition | Description |
|----------|-------------|
| `DOCREVNO = ' 0 '` | Indicates original form version |
| `EPICC_OPIOIDS_OF_USE IS NOT NULL` | Multi-select field was used |
| Any pivot field is `NULL` | Suggests JS did not populate binary values |

## Logic Summary

This query identifies Initial Contact records where opioid use was selected via the multi-select field `EPICC_OPIOIDS_OF_USE`, but the corresponding binary fields (`OPIOID_OF_USE_*`) remain `NULL`. These fields are expected to be populated by the JavaScript function `updateReportFields()`.

The logic filters for:

- Original form submissions (`DOCREVNO = ' 0 '`)
- Non-null values in `EPICC_OPIOIDS_OF_USE`, indicating user selection
- Missing values in one or more pivoted fields:
  - `OPIOID_OF_USE_FENTANYL`
  - `OPIOID_OF_USE_PRESCRIPTION_OPIATES`
  - `OPIOID_OF_USE_HEROIN`
  - `OPIOID_OF_USE_SUBOXONE_MAT`

This pattern suggests that the pivoting logic failed to execute, likely due to form load timing issues or user navigation that bypassed expected triggers. A mutation observer was coded to handle this, and it appears to have worked, but this report will be useful to spot check periodically just in case.

The query joins to `Q_CLIENT_BHN` for client context and returns identifying details along with the raw and pivoted opioid use fields.

## Usage Notes

- Intended for internal review for Data Team staff remediation.
- For any form with NULL values in the hidden fields, enter the form and click to save it. This prompts updateReportFields() to pivot the data.

## Changelog

- **2025-05-19**: Initial SQL query authored.

## Related Assets

- Base Table: `PWEPICCINITIALCONTACT`  
- View: `Q_CLIENT_BHN`
- Security Groups: GVT, System Administrator  
  