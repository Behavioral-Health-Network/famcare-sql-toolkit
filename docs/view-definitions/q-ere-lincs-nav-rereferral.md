---
front-matter-title: Q_ERE_LINCS_NAV_REREFERRAL
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-ere-lincs-nav-rereferral.sql
last_updated: 2026-03-14
status: active
lifecycle: production
program_scope: single
programs:
  - ere
tags:
  - rereferral
  - pathway-join-view
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# Q_ERE_LINCS_NAV_REREFERRAL

## Purpose

Provides a cross-program, client-level summary of ERE and LINCS NAV referral episodes and agency-wide referral history, designed to be consumed directly by a Quick Report (`SELECT * FROM Q_ERE_LINCS_NAV_REREFERRAL`) while encapsulating the complex join and aggregation logic in a reusable view.

## Description

- Produces **one row per client** representing the latest ERE or LINCS NAV referral episode.
- Anchored in `Q_BHNWIDE_PATHCLIENT_ENROLLMENTS` to leverage the agency-wide enrollment and Pathway spine.
- Restricts to ERE and LINCS NAV Pathways and referral events:
  - Pathway IDs: `55320250326123001961` (ERE), `55320240905123251861` (LINCS NAV).
  - Events: `ERE Referral`, `LINCS NAV Referral`.
- Enriches referral episodes with:
  - Referral source, reason, and patient location from `Q_ERE_REFERRAL` and `Q_LINCS_NAV_REFERRAL`.
  - Housing status from `Q_ERE_ACTIVE_HOUSING_STATUS` and NAV referral forms.
  - Agency-wide referral metrics from `Q_PROVIDERPLACEMENT_BHN`.
- Designed as the **supporting asset** for a Quick Report, avoiding the limitations of the Quick Report editor by centralizing the logic in a view.

### Logic Summary

- **CTE: `ERE_NAV_EVENTS`**
  - Filters `Q_BHNWIDE_PATHCLIENT_ENROLLMENTS` to ERE and LINCS NAV Pathways and referral events.
  - Captures enrollment episode context and `REFERRAL_EVENT_DATE` (from `PE_DATE_ACCOMPLISHED`).

- **CTE: `ERE_REF_WITH_FORM`**
  - LEFT JOINs `Q_ERE_REFERRAL` on:
    - `CLIENT_NUMBER`
    - `TIEDENROLLMENT = PC_DOCSERNO`
    - `EVENT_NAME = PWY_EVENT`
  - Adds ERE referral form metadata (referring agency, reason, patient location, form DOCSERNO, PATHWAY_DATE).

- **CTE: `NAV_REF_FORM`**
  - LEFT JOINs `Q_LINCS_NAV_REFERRAL` on:
    - `CLIENT_NUMBER`
    - `PATHWAY_DATE = REFERRAL_EVENT_DATE`
  - Filters to LINCS NAV referral events only.
  - Adds NAV referral form metadata.

- **CTE: `ALL_ERE_LINCS_NAV_REFS`**
  - Combines ERE and NAV referral episodes using `UNION` to avoid duplication when the same episode is reachable via multiple paths.
  - Represents the unified set of ERE/LINCS NAV referral episodes for downstream aggregation.

- **CTE: `AGENCY_REF`**
  - Aggregates `Q_PROVIDERPLACEMENT_BHN` by `CLIENT_NUMBER` to compute:
    - `TOTAL_BHN_REFERRALS`
    - `LAST_BHN_REREFERRAL_DATE`
  - Provides an agency-wide referral baseline independent of Pathway events.

- **CTE: `FINAL_WITH_RN`**
  - Joins `ALL_ERE_LINCS_NAV_REFS` to:
    - `Q_ERE_ACTIVE_HOUSING_STATUS` for ERE housing status.
    - `Q_LINCS_NAV_REFERRAL` for NAV housing status (via referral form DOCSERNO).
    - `AGENCY_REF` for agency-wide referral metrics.
  - Derives:
    - `LATEST_REFERRAL_PROGRAM` (ERE vs LINCS NAV).
    - `LATEST_HOUSING_STATUS` (ERE first, NAV fallback, then Unknown).
    - Client-level ERE+NAV referral metrics:
      - `TOTAL_ERE_PLUS_NAV_REFERRALS` (episode count).
      - `LAST_ERE_OR_NAV_REFERRAL_DATE` (latest enrollment start date across ERE/NAV).
  - Uses `ROW_NUMBER()` partitioned by `CLIENT_NUMBER`, ordered by `ENROLLMENT_STARTING_DATE DESC`, to select the latest referral episode per client.

- **Final SELECT**
  - Filters to `RN = 1` to return a single, latest-referral row per client, suitable for direct Quick Report consumption.

## Maintenance Notes

- If additional programs are added to the re-referral logic, extend `ERE_NAV_EVENTS` to include new Pathway IDs and events, and update `LATEST_REFERRAL_PROGRAM` accordingly.
- If ERE or LINCS NAV referral form structures change (e.g., new housing fields, renamed columns), update the joins and selected metadata in `ERE_REF_WITH_FORM` and `NAV_REF_FORM`.
- The use of `UNION` in `ALL_ERE_LINCS_NAV_REFS` is intentional to prevent duplicate episodes when upstream structures evolve; avoid reverting to `UNION ALL` without a clear deduplication strategy.
- Any changes to `Q_BHNWIDE_PATHCLIENT_ENROLLMENTS` join logic should be validated against this view, as it relies on that asset for accurate episode-level attribution.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-03-14**: Updates `ERE_REF_WITH_FORM` `CTE` to `SELECT` `R.REFERRING_AGENCY_CODE`. `Q_ERE_REFERRAL` was updated to rename `REFERRING_AGENCY` to `REFERRING_AGENCY_CODE`.
- **2026-03-12**: Renames `AGENCY_REF` `CTE` as `BHN_REF`. Renames `TOTAL_AGENCY_REFERRALS` and `LAST_AGENCY_REREFERRAL_DATE` as `TOTAL_BHN_REFERRALS` and `LAST_BHN_REREFERRAL_DATE`.
- **2026-03-09**: Adds initial Markdown documentation.
- **2026-03-06**: Adds initial view definition.

</details>
</details>
<!---CHANGELOG-END--->
