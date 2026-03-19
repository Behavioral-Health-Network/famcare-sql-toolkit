---
front-matter-title: ERE and LINCS NAV Re-Referrals Program Management Report
category: program-management-reports
category_label: Program Management Reports
source_file: code/program-management/ere-lincs-nav-rereferrals.sql
last_updated: 2026-03-09
status: active
lifecycle: production
program_scope: single
programs: 
  - ere
tags:
  - rereferral
  - program-management
  - pathway
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# ERE and LINCS NAV Re‑Referrals Program Management Report

## Purpose

Provides program managers with a unified, client-level view of referral activity across the **ERE** and **LINCS NAV** programs, including:

- The **latest referral episode** for each client  
- The **total number of ERE + LINCS NAV referral episodes**  
- The client’s **agency-wide referral history**  
- The **referral source**, **referral reason**, and **housing status** at the time of the latest referral  

This report supports operational monitoring and re-referral analysis.

## Description

This report is backed by the view `Q_ERE_LINCS_NAV_REREFERRAL`, which encapsulates all complex logic required to:

- Identify ERE and LINCS NAV referral episodes  
- Join to Pathway metadata and referral forms  
- Resolve housing status from both programs  
- Compute client-level referral metrics  
- Select the **latest** referral episode per client  

The Quick Report itself is a simple:

```sql
SELECT *
FROM Q_ERE_LINCS_NAV_REREFERRAL;
```

The complexity is intentionally pushed into the view due to the limitations of the Quick Report editor.

### Key Features

- **Cross-program referral tracking**  
  Combines ERE and LINCS NAV referral episodes into a single client-level summary.

- **Episode-level accuracy**  
  Counts **referral episodes**, not Pathway events, ensuring alignment with agency-wide enrollment counts.

- **Latest referral attribution**  
  Identifies whether the most recent referral was to ERE or LINCS NAV.

- **Unified housing status**  
  Uses ERE housing status when available, falling back to LINCS NAV referral housing status when ERE data is absent.

- **Agency-wide context**  
  Includes total agency referrals and the date of the most recent agency enrollment episode.

- **Form metadata integration**  
  Pulls referral source, reason, and patient location from ERE and LINCS NAV referral forms when available.

### Data Sources

- `Q_ERE_LINCS_NAV_REREFERRAL` (primary view)
- `Q_BHNWIDE_PATHCLIENT_ENROLLMENTS` (agency-wide Pathway spine)
- `Q_ERE_REFERRAL` (ERE referral form)
- `Q_LINCS_NAV_REFERRAL` (LINCS NAV referral form)
- `Q_ERE_ACTIVE_HOUSING_STATUS` (ERE housing status)
- `Q_PROVIDERPLACEMENT_BHN` (agency-wide enrollment episodes)

### Output Fields (Summary)

- **Client Information**
  - `CLIENT_NUMBER`, `CLIENT_LAST`, `CLIENT_FIRST`

- **Latest Referral Episode**
  - `LATEST_REFERRAL_PROGRAM` (ERE or LINCS NAV)
  - `LATEST_REFERRING_AGENCY`
  - `LATEST_REFERRAL_REASON`
  - `LATEST_REFERRAL_FORM_DOCSERNO`
  - `LAST_ERE_OR_NAV_REFERRAL_DATE`

- **Housing Status**
  - `LATEST_HOUSING_STATUS`

- **Referral Metrics**
  - `TOTAL_ERE_PLUS_NAV_REFERRALS`
  - `TOTAL_AGENCY_REFERRALS`
  - `LAST_AGENCY_REFERRAL_DATE`

## Usage Notes

- This report is intended for **program managers**, **supervisors**, and **leadership** who need a consolidated view of referral activity across ERE and LINCS NAV.
- The report is **client-level**, not episode-level; each client appears once.
- Referral counts are based on **enrollment episodes**, not Pathway events.
- Referral metadata (source, reason, patient location) is only available when a referral form exists.

## Maintenance Notes

- If new referral event types are introduced for ERE or LINCS NAV, update the `ERE_NAV_EVENTS` `CTE` in the backing view.
- If additional programs are added to the re-referral workflow, extend the Pathway ID list and update `LATEST_REFERRAL_PROGRAM`.
- If housing status logic changes, update the `CASE` expression in `FINAL_WITH_RN`.
- Ensure `Q_BHNWIDE_PATHCLIENT_ENROLLMENTS` remains stable, as this report depends on its episode-level attribution.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>Report Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-03-09**: Adds initial SQL query. Adds initial Markdown documentation.

</details>
</details>
<!---CHANGELOG-END--->
