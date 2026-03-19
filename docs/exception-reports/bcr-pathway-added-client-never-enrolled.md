---
front-matter-title: BCR Pathway Added Client Never Enrolled Exception Report
category: Exception Reports
source_file: code/exception-reports/bcr-pathway-added-client-never-enrolled.sql
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

# BCR Pathway Added Client Never Enrolled Exception Report

## Purpose

This exception report identifies cases where a client has been added to one or more Pathways without first being enrolled in a program. Pathway assignments should be made using the `PROVIDERPLACEMENT` form, but this report highlights instances where the assignment was incorrectly made using the `CLIENT` form.

## Logic Summary

- Flags Pathway records missing a corresponding enrollment by checking for null `PP.STARTINGDATE`.
- Uses `Q_CLIENT_BHN` to exclude test clients.
- Joins `PATHWAYCLIENT`, `PROVIDERPLACEMENT`, and `PATHWAYEVENTCLIENT` using both direct serial number matches and fallback logic:
  - `PP.CLIENTNUMBER = PC.CLIENTNUMBER`
  - `PP.PATHWAY = PC.PARENTDOCSERNO`
  - `PP.STARTINGDATE = PC.STARTDATE`
- Filters to BCR referrals only (`PE.SHORTDESCRIPTION = 'BCR Referral'`).
- Targets Pathway assignments with `PC.PARENTDOCSERNO = 55320240917145557321`.

## Usage Notes

- Intended for internal review or staff remediation.
- Helps identify misassigned Pathways that bypass proper enrollment workflows.
- Supports remediation by surfacing affected clients and relevant form metadata.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

- **2025-09-18**: Adds `exception-logic` tag and front-matter-title.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-14**: Adds initial Markdown documentation. Uses `Q_CLIENT_BHN` in place of `Q_CLIENT` to filter out test clients.
- **2025-05-16**: Adds initial SQL query.
<!---CHANGELOG-END--->
