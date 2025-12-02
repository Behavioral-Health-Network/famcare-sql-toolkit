---
front-matter-title: EPICC Candidates for Re-Engagement or Dismissal
category: Program Management Reports
source_file: code/program-management-reports/epicc-candidates-reengagement-dismissal.sql
last_updated: 2025-12-01
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - epicc
tags: [value1, value2]
dependencies:
  - value1
  - value2
change_control: value
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# EPICC Candidates for Re-Engagement or Dismissal

## Purpose

Identifies EPICC clients who are candidates for either dismissal or re-engagement based on milestone participation, client status, and treatment path progression. Supports program management decision-making by surfacing clients who may require outreach to re-engage or closure, in alignment with contractual obligations and workflow expectations.

## Key Metrics

- Aggregates program participation and client status across Referral, Initial Contact, 2-Week, 30-Day, 3-Month, and 6-Month milestones.
- Includes staff assignment and enrollment start date for follow-up context.
- Includes most recent treatment path for context.
- Surfaces milestone-specific program participation and client status fields to assist with identifying appropriate candidates for transfer to re-engagement and those whose enrollment should be dismissed.
- Uses `HAVING` clause to flexibly include clients with partial milestone completion.

## Filters

- Includes only active enrollments (`ENROLLMENT_ENDING_DATE IS NULL`) for EPICC Pathway ID `55320240807113504583`.
- Excludes test clients via `Q_CLIENT_BHN`.
- Uses `HAVING` clause to apply tiered milestone logic and re-engagement detection. See Logic section below for details.

## Logic

Clients are included if any of the following conditions have been met:

1. Has 6-Month program participation recorded
    - `ESIXM.PROGRAM_PARTICIPATION_SIXM_DESCRIPTION` is not `NULL`
2. OR has 3-Month program participation recorded but the client is not 'Engaged' and is not both: 'Not Engaged' and client status in ('Outreaching', 'Transfer To Re-Engagement Specialist')
    - `ESIXM.PROGRAM_PARTICIPATION_SIXM_DESCRIPTION` is `NULL`
    - `ETHREEM.PROGRAM_PARTICIPATION_ETHREEM_DESCRIPTION` is not `NULL`
    - `ETHREEM.PROGRAM_PARTICIPATION_THREEM_DESCRIPTION` not in (`'Engaged'`, `'Engaged With EPICC'`)
    - Not (
      - `ETHREEM.PROGRAM_PARTICIPATION_THREEM_DESCRIPTION` in (`'Not Engaged'`, `'Not Participating In EPICC Program'`)
      - `ETHREEM.CLIENT_STATUS_THREE_MONTH` in (`'Outreaching'`, `'Transfer to Re-Engagement Specialist'`)
    )
3. OR has 30-Day program participation recorded but the client is not 'Engaged' but and not both: 'Not Engaged' and client status in ('Outreaching', 'Transfer To Re-Engagement Specialist')
    - `ESIXM.PROGRAM_PARTICIPATION_SIXM_DESCRIPTION` is `NULL`
    - `ETHREEM.PROGRAM_PARTICIPATION_ETHREEM_DESCRIPTION` is `NULL`
    - `ETHIRTYD.PROGRAM_PARTICIPATION_THIRTYD_DESCRIPTION` is not `NULL`
    - `ETHIRTYD.PROGRAM_PARTICIPATION_THIRTYD_DESCRIPTION` not in (`'Engaged'`, `'Engaged With EPICC'`)
    - Not (
      - `ETHIRTYD.PROGRAM_PARTICIPATION_THIRTYD_DESCRIPTION` in (`'Not Engaged'`, `'Not Participating In EPICC Program'`)
      - `ETHIRTYD.CLIENT_STATUS_THIRTY_DAY` in (`'Outreaching'`, `'Transfer to Re-Engagement Specialist'`)
    )
4. OR has 2-Week program participation recorded but the program participation is neither 'Engaged' nor 'Not Engaged'
    - `ESIXM.PROGRAM_PARTICIPATION_SIXM_DESCRIPTION` is `NULL`
    - `ETHREEM.PROGRAM_PARTICIPATION_ETHREEM_DESCRIPTION` is `NULL`
    - `ETHIRTYD.PROGRAM_PARTICIPATION_THIRTYD_DESCRIPTION` is `NULL`
    - `ETWOW.PROGRAM_PARTICIPATION_TWOW_DESCRIPTION` is not `NULL`
    - `ETWOW.PROGRAM_PARTICIPATION_TWOW_DESCRIPTION` is not in (`'Engaged'`, `'Engaged With EPICC'`, `'Not Engaged'`, `'Not Participating In EPICC Program'`)
5. OR has Initial Contact program participation recorded and this program participation is neither 'Enrolled With EPICC' nor 'Unable To Contact/Locate'
    - `ESIXM.PROGRAM_PARTICIPATION_SIXM_DESCRIPTION` is `NULL`
    - `ETHREEM.PROGRAM_PARTICIPATION_ETHREEM_DESCRIPTION` is `NULL`
    - `ETHIRTYD.PROGRAM_PARTICIPATION_THIRTYD_DESCRIPTION` is `NULL`
    - `ETWOW.PROGRAM_PARTICIPATION_TWOW_DESCRIPTION` is `NULL`
    - `EIC.PROGRAM_PARTICIPATION_IC_DESCRIPTION` is not in (`'Enrolled With EPICC'`, `'Unable To Contact/Locate'`)
6. OR has Referral program participation recorded but the program participation is not 'Eligible For Services'
    - `ESIXM.PROGRAM_PARTICIPATION_SIXM_DESCRIPTION` is `NULL`
    - `ETHREEM.PROGRAM_PARTICIPATION_ETHREEM_DESCRIPTION` is `NULL`
    - `ETHIRTYD.PROGRAM_PARTICIPATION_THIRTYD_DESCRIPTION` is `NULL`
    - `ETWOW.PROGRAM_PARTICIPATION_TWOW_DESCRIPTION` is `NULL`
    - `EIC.PROGRAM_PARTICIPATION_IC_DESCRIPTION` is `NULL`
    - `EREF.PROGRAM_PARTICIPATION_REFERRAL_DESCRIPTION` <> `'Eligible For Services'`
7. OR has Initial Contact program participation recorded as either 'Enrolled With EPICC' or is 'Already Enrolled In SUD Services' and is flagged for re-engagement at Thirty-Day based because program participation is 'Transfer to Re-Engagement Specialist' with missing subsequent follow-up forms and with the 3-month program participation descriptions being `NULL`
    - `EIC.PROGRAM_PARTICIPATION_IC_DESCRIPTION` `LIKE 'Enrolled%'`
    - `ETHIRTYD.CLIENT_STATUS_THIRTY_DAY` = `'Transfer To Re-Engagement Specialist'`
    - `ETHREEM.PROGRAM_PARTICIPATION_THREEM_DESCRIPTION`

## Changelog

- **2025-12-01**: Updates logic to normalize program participation values across legacy (`'Engaged'`, `'Not Engaged'`) and current (`'Engaged With EPICC'`, `'Not Participating In EPICC Program'`). Updates all logic to treat these pairs equivalently in the `HAVING` clause. Clarifies Condition 7 to require only that 3‑Month program participation descriptions to be NULL when IC program participation is either `'Enrolled With EPICC'` or `'Already Enrolled In SUD Services'` and client status at 30-day interval is `'Transfer To Re-Engagement Specialist'`, preventing rows where this is true from dropping out because the report previously required program participation at 30-day to be `NULL` and simplifying the logic given that program participation at 6-month is irrelevant if the program participation at 3-month is `NULL`.
- **2025-11-04**: Adds extended logic breakdown to the documentation file.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-12**: Merges dismissal and re-engagement logic back into unified report at the request of EPICC leadership staff; added re-engagement detection condition to the `HAVING` clause; updated joins to use `Q_PROVIDERPLACEMENT_BHN` with `LEFT JOIN` to accommodate imported rows. `ENROLLMENT_STARTING_DATE` and other columns were updated to reflect the naming in the view.
- **2025-08-06**: Fixes problematic joins to `PATHWAYCLIENT` and `PATHWAYEVENTCLIENT` by copying the join logic from `Q_EPICC_PATHCLIENT_ENROLLMENTS`. The original join to `PATHWAYCLIENT` was not capable of accurately distinguishing between imported enrollments and enrollments begun using the front-end `PROVIDERPLACEMENT` form, and at least one `PROGRAM_PARTICIPATION_IC` value from a different enrollment was being joined into another enrollment, resulting in a false positive showing; also adds `PP.ENDINGDATE IS NULL` to ensure that only clients with active enrollments may be considered for dismissal.
- **2025-08-01**: Adds changelog and documentation Markdown.
- **2025-07-29**: Refactors SQL query to exclude candidates for re-engagement in favor of focusing on candidates for dismissal-only and including all milestones through the six-month follow-up, again per specifications from the Data Team staff.
- **2025-05-13**: Adds initial SQL query intended to include candidates for re-engagement or dismissal but looking only through the thirty-day follow-up per specifications from the Data Team staff.
