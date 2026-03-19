---
front-matter-title: Clients With Multiple Active Pathways Sharing Same Start Date Exception Report
category: Exception Reports
source_file: code/exception-reports/clients-with-multiple-active-pathways-sharing-same-start-date.sql
last_updated: 2025-07-21
status: active
lifecycle: production
program_scope: multi
programs:
  - bcr
  - complex-care
  - epicc
  - ere
  - yere
tags:
  - exception-logic
  - tag2
dependencies:
  - value1
  - value2
change_control: value
schema_version: 1.0
---

# Clients With Multiple Active Pathways Sharing Same Start Date Exception Report

## Purpose

Identifies clients who have multiple active Pathways that share the same start date. This report helps surface potential data entry errors or structural duplication in Pathway assignment workflows.

## Logic Summary

- Constructs a CTE (`DuplicateStartDates`) that groups PathwayClient rows by `CLIENTNUMBER` and `STARTDATE`, retaining only cases where the same start date appears more than once for the same client (`COUNT(*) > 1`).  
- Filters for original document revisions (`DOCREVNO = ' 0 '`) in both `PATHWAYCLIENT` and `PATHWAY`.  
- Joins the duplicate start date results to full Pathway, ProviderPlacement, Provider, and Client metadata.  
- Returns one row per Pathway instance matching the duplicated start date for the same client.

## Usage Notes

- Used as a source view for Quick Reports to flag possible duplication across Pathway assignments.  
- Review flagged rows for clients with multiple concurrent Pathways sharing identical start dates.  
- Useful for data cleanup, staff follow-up, and resolving overlapping assignment logic.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

- **2025-09-18**: Adds `exception-logic` tag and front-matter-title.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-07-21**: Adds initial Markdown documentation.  
- **2025-07-08**: Adds initial SQL query authored and view definition.
<!---CHANGELOG-END--->
