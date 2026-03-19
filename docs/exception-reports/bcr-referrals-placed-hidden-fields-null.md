---
front-matter-title: BCR Referrals Placed Hidden Fields Null Exception Report
category: Exception Reports
source_file: code/exception-reports/bcr-referrals-placed-hidden-fields-null.sql
last_updated: 2025-08-14
status: active
lifecycle: production
program-scope: single
programs:
  - bcr
tags:
  - exception-logic
  - tag2
dependencies:
  - value1
  - value2
change_control: value
schema_version: 1.0
---

# BCR Referrals Placed Hidden Fields Null Exception Report

## Purpose  

Flags BCR Referrals Placed records where the JavaScript function responsible for populating binary fields failed to execute, resulting in missing values for referral subtypes. These cases suggest that a multi-select field was used (e.g., `BCR_TYPE_REF_PLACED` or subtype fields), but the corresponding binary fields remain `NULL`.

This pattern indicates that the pivoting logic did not run, likely due to form load timing issues or user navigation that bypassed expected triggers.

## Exception Criteria

| Condition | Description |
|----------|-------------|
| `DOCREVNO = ' 0 '` | Indicates original form version |
| Multi-select field is not null | Indicates user made a selection |
| Any corresponding binary field is `NULL` | Suggests JS did not populate hidden fields |

## Logic Summary

This query identifies BCR Referrals Placed forms where:

- A multi-select field (e.g., `BCR_TYPE_REF_PLACED`, `BCR_REF_PLACED_*_SUBTYPE`) is populated
- One or more corresponding binary fields are `NULL`, indicating a failure in the JavaScript pivoting logic

The logic checks for:

- Behavioral health subtypes (e.g., `CMHC_REF_PLACED`, `SU_REF_PLACED`)
- Housing subtypes (e.g., `RENT_ASSIST_REF_PLACED`, `UTILITY_ASSIST_REF_PLACED`)
- Physical health subtypes (e.g., `PRIMARY_CARE_REF_PLACED`, `DENTAL_REF_PLACED`)
- Social services subtypes (e.g., `FOOD_REF_PLACED`, `TRANSPORT_REF_PLACED`)

Joins to `Q_CLIENT_BHN` provide client context for remediation.

## Usage Notes

- Intended for internal review by Data Team staff.
- For any form with `NULL` values in the hidden fields, open the form and click save to trigger the pivot logic.
- Spot check periodically to ensure mutation observer continues to function as expected.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

- **2025-09-18**: Adds `exception-logic` tag and front-matter-title.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-14**: Adds initial Markdown documentation.
- **2025-04-15**: Adds initial SQL query.
<!---CHANGELOG-END--->
