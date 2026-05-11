---
front-matter-title: BCR Referral Entered But No IC Entered View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-bcr-referral-entered-no-ic.sql
last_updated: 2026-04-08
status: active
lifecycle: production
program_scope: single
programs:
  - bcr
tags:
  - view-layer
  - exception-logic
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# BCR Referral Entered But No Initial Contact Entered View Definition

## Purpose

Identifies BCR enrollments where a **Referral** form has been entered but the corresponding **Initial Contact (IC)** form is missing. Supports exception reporting, workflow monitoring, and timely follow‑up by surfacing incomplete referral episodes.

## Description

- Built on `Q_BCR_PATHCLIENT_ENROLLMENTS` and `Q_BCR_REFERRAL`.
- Uses two CTEs:
  - **BCR_REF**: all BCR Referral events with valid form entries.
  - **BCR_IC_MISSING**: all BCR Initial Contact events with valid form entries.
- Performs an anti‑join (`LEFT JOIN … WHERE right.key IS NULL`) to identify referrals that do **not** have a matching IC form.
- Returns one row per referral missing its IC.

### Logic Summary

- **Referral Event Filter**
  - Includes only rows where `PWY_EVENT = 'BCR Referral'`.
  - Requires a non‑NULL `PWY_FORMS_DOCSERNO` to ensure the referral form was actually entered.
  - Restricts to enrollments starting on or after **2025‑07‑01**.

- **Initial Contact Event Filter**
  - Includes only rows where `PWY_EVENT = 'BCR Initial Contact'`.
  - Requires a non‑NULL `PWY_FORMS_DOCSERNO` to ensure the IC form was entered.
  - Uses the same enrollment date threshold for alignment.

- **Anti‑Join Logic**
  - `LEFT JOIN` on `TIEDENROLLMENT`.
  - `WHERE BCR_IC_MISSING.TIEDENROLLMENT IS NULL` ensures only referrals **without** a matching IC are returned.

- **Column Disambiguation**
  - Referral and IC `TIEDENROLLMENT` values are explicitly aliased (`REF_TIEDENROLLMENT`, `IC_TIEDENROLLMENT`) to maintain unique column names and avoid SQL Server error 4506.

## Output Fields

| Field Name            | Description |
|-----------------------|-------------|
| `CLIENT_NUMBER`       | Client identifier |
| `CLIENT_LAST`, `CLIENT_FIRST` | Client name fields |
| `ENROLLMENT_STARTING_DATE` | Enrollment start date for the episode |
| `REF_PATHWAY_DATE`    | Pathway date associated with the Referral event |
| `REF_TIEDENROLLMENT`  | Enrollment key for the Referral event |
| `IC_TIEDENROLLMENT`   | Enrollment key for the IC event (always NULL in this view) |

## Usage Notes

- **Exception Reporting**: Designed to feed dashboards or scheduled reports that monitor incomplete referral workflows.
- **Ad Hoc Compatibility**: Implemented as a view to support tools that do not allow CTEs.
- **Program Scope**: Applies only to the BCR program; logic is aligned with BCR event naming conventions.
- **Data Quality Insight**: Rows returned indicate a Referral form was entered but the IC form was not — typically requiring staff follow‑up.

## Maintenance Notes

- **Event Naming Consistency**: Ensure `PWY_EVENT` values (`'BCR Referral'`, `'BCR Initial Contact'`) remain stable; update if program terminology changes.
- **Enrollment Date Threshold**: Review the `'2025‑07‑01'` cutoff periodically to confirm alignment with reporting periods.
- **Join Integrity**: The anti‑join depends on consistent `TIEDENROLLMENT` values across Referral and IC events; investigate discrepancies if unexpected rows appear.
- **Form Presence Logic**: The requirement that `PWY_FORMS_DOCSERNO IS NOT NULL` ensures only true form entries are considered; adjust if form‑entry rules evolve.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
<!---CHANGELOG-END--->
