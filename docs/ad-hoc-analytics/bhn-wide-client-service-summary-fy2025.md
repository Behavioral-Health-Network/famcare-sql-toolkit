---
front-matter-title: Distinct Client Service Summary Across BHN Programs FY25
category: ad-hoc-analytics
category-label: Ad Hoc Analytics
source_file: code/ad-hoc-analytics/bhn-wide-client-service-summary-fy2025.sql
last_updated: 2026-03-18
status: active
lifecycle: experimental
tags:
  - grant-support
  - enrollment-analysis
  - demographics
program-scope: multi
programs:
  - BHN-wide
dependencies:
  - name: Q_BHNWIDE_PATHCLIENT_ENROLLMENTS
    type: view
    repo: famcare-sql-toolkit
  - name: Q_CLIENT_BHN
    type: view
    repo: famcare-sql-toolkit
change_control:
  - low-risk
  - documentation-only
schema_version: 1.0
---

# Distinct Client Service Summary Across BHN Programs FY25

## Purpose

This ad hoc analytic query was developed to support a grant application requiring a summary of clients served during the FY2025 state fiscal year (2024‑07‑01 through 2025‑06‑30).  
The query produces a single‑row summary containing:

- total distinct clients served  
- number and percent of clients residing in the City of St. Louis  
- number and percent of clients aged 60+ who also reside in the City of St. Louis  
- list of ZIP Codes served within the City of St. Louis (this is not time-aligned as the current address for each client is joined regardless of residence at the time of enrollment if different)
- list of counties represented among all clients served  

The logic is designed for one‑time reporting and is not intended as a recurring extract or program management report.

## Logic Summary

- Filters enrollments to Pathway Event forms representing program entry (`%Referral` or `%Roster`).  
- Limits to enrollments with a starting date within FY2025.  
- Joins to client demographic data to obtain birth date, ZIP Code, and county.  
- Calculates age at enrollment and flags clients who were 60+ at any enrollment during the fiscal year.  
- Flags clients as City of St. Louis residents only when `COUNTY_DESCRIPTION = 'ST. LOUIS CITY'`.  
- Aggregates to one row per client per fiscal year (`CLIENT_FY`) using MAX() over flags.  
- Produces final summary metrics using conditional aggregation and distinct lists of ZIP Codes and counties.

## Output Description

The final query returns a single row with the following fields:

- `TOTAL_CLIENTS` — distinct clients served in FY2025  
- `CITY_CLIENTS` — clients with county recorded as St. Louis City  
- `CITY_CLIENTS_PCT` — proportion of total clients residing in the city  
- `CITY_60PLUS_CLIENTS` — clients aged 60+ and residing in the city  
- `CITY_60PLUS_CLIENTS_PCT` — proportion of total clients meeting both criteria  
- `CITY_ZIP_CODES` — comma‑separated list of ZIP Codes served within the city  
- `COUNTIES_SERVED` — comma‑separated list of counties represented among all clients  

## Usage Notes

- This query is intended for one‑time grant support and is not part of a recurring reporting workflow.  
- Address history is not time‑aligned to enrollment; ZIP and county reflect best‑available client address.  
- NULL county values are retained and appear as `UNKNOWN` in the county list.  
- The logic for identifying city residents is intentionally strict to avoid misclassification of county addresses with St. Louis mailing ZIPs.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!-- CHANGELOG:START -->
<!-- CHANGELOG:END -->
