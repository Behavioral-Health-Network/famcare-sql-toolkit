---
front-matter-title: ere-famcare-updates-to-enter-into-caremanager
category: compliance-reports
category-label: Compliance Reports
source_file: code/compliance-reports/ere-famcare-updates-to-enter-into-caremanager.sql
last_updated: 2026-02-17
status: active
lifecycle: production
program_scope: single
programs:
  - ere
tags:
  - pathway-event
  - ere-referral
  - ere-ihna
  - ere-3-month
  - ere-6-month
dependencies:
  - name: q-ere-pathclient-enrollments
    type: sql
    repo: famcare-sql-toolkit
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
change_control: internal-review-required
last_reviewed: 2025-08-21
schema_version: 1.0
---

# ERE FAMCare Updates to Enter Into CareManager

## Purpose

This report identifies ERE clients with completed Pathway Event forms that must be entered into CareManager. It surfaces milestone-based form completions—including Referral, IHNA, 3 Month, and 6 Month events—linked to enrollment periods.

## Compliance Scope

- Supports internal tracking of required CareManager updates for ERE clients.
- Ensures timely documentation of milestone forms tied to enrollment.
- Used to fulfill internal compliance workflows and data integrity checks.

## Usage Notes

- Filters by visit date range using form-level datepickers.
- Aggregates milestone dates using conditional logic and MAX() functions.
- Intended for internal compliance review and CareManager data entry coordination.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-02-17**: Adds initial SQL view definition. Adds initial Markdown documentation file. Transitions query logic from the report to a view definition so that the compliance report query itself may filter to visit dates for the four forms in CareManager AFTER aggregation instead of before aggregation.

</details>

details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

- **2025-11-12**: Updates the `WHERE` clause to include 'Re-Referred' to the dismissal reasons to be filtered out.
- **2025-11-04**: Adds `EENROLL.DISMISSAL_REASON_DESCRIPTION` field and updates the `WHERE` clause to filter out values of 'Reconnect' since they are irrelevant in CareManager Wwhile ensuring that those with `EENROLL.ENROLLMENT_ENDING_DATE` are not `NULL` to retain active clients not reconnected.
- **2025-09-18**: Relocates and reformats `tags:` field.
- **2025-08-21**: Adds initial SQL query for ERE compliance reporting into CareManager. Adds initial Markdown documentation.

</details>
</details>
<!---CHANGELOG-END--->
