# Comment Style Guide for SQL Queries (Markdown-Based)

This guide defines the canonical Markdown documentation structure for all SQL assets in the  
`FAMCare-SQL-Toolkit` repository. Every `.sql` file in `/code/<category>/` should have a  
matching `.md` file in `/docs/<category>/`. The Markdown file is the single source of truth  
for purpose, logic, usage and history—no full comments belong in the SQL itself. Instead, a standardized SQL comment header should be used. Templates for the documentation files may be located below.

## Standardized SQL File Header Block

Each `.sql` file should begin with a standardized comment block that identifies its asset type and links to related documentation.

| Asset Type             | Label Prefix     | Example                                   |
|------------------------|------------------|-------------------------------------------|
| Report Variant         | `Report Name:`   | `Report Name: yere-duplicate-pwy-forms`   |
| View Definition        | `View Name:`     | `View Name: q-bcr-client-counseling-sessions` |
| Extract / Maintenance Query | `Query Name:`     | `Query Name: extract-bcr-session-counts`    |
| Maintenance Script     | `Script Name:`   | `Script Name: rebuild-session-indexes`     |

### Example

```sql
/*
View Name: Q_BCR_CLIENT_COUNSELING_SESSIONS  
Category: View Definitions  

See docs/views/q-bcr-client-counseling-sessions.md for full documentation.
*/
```

---

## Documentation Templates for Markdown Documentation

---

## Exception Reports

```markdown
# [Report Name]

**Category:** Exception Reports  
**Source File:** `code/exception-reports/file-name.sql`  
**Last Updated:** 2025-07-31  
**Author:** BHN Data Team  

## Purpose

Describe the exception being flagged (e.g. overlapping dates, missing forms, duplicated submissions).

## Logic Summary

- Identify key joins, filters, and logic used.
- Specify any thresholds (e.g. enrollment gaps > 90 days).

## Usage Notes

- Intended for internal review or staff remediation.

## Changelog

- YYYY-MM-DD: Initial creation.
- YYYY-MM-DD: Adjusted filter to exclude dismissed clients.

```

---

## Program Management Reports

```markdown
# [Report Name]

**Category:** Program Management  
**Source File:** `code/program-management-reports/file-name.sql`  
**Last Updated:** 2025-07-31  
**Author:** BHN Data Team  

## Purpose

Summarize or segment data to support caseload tracking, grant monitoring, or service planning.

## Key Metrics

- Describe aggregation logic, counts, or grouping rules.

## Filters

- Note time-based or demographic constraints.

## Changelog

- YYYY-MM-DD: Initial version.
- YYYY-MM-DD: Added agency filter logic.

```

---

## Audit Reports

```markdown
# [Report Name]

**Category:** Audit Reports  
**Source File:** `code/audit-reports/file-name.sql`  
**Last Updated:** 2025-07-31  
**Author:** BHN Data Team  

## Purpose

Validate procedural compliance, user actions, or documentation completeness.

## Audit Scope

- List tracked actions (e.g. form submissions, report runs).
- Define timeframes or actors under review.

## Changelog

- YYYY-MM-DD: Initial version.
- YYYY-MM-DD: Expanded audit scope to include housing status forms.

```

---

## Compliance Reports

```markdown
# [Report Name]

**Category:** Compliance Reports  
**Source File:** `code/compliance-reports/file-name.sql`  
**Last Updated:** 2025-07-31  
**Author:** BHN Data Team  

## Purpose

Fulfill contractual, policy-based, or regulatory requirements through structured exports.

## Compliance Scope

- Define the regulation, grant, or external party receiving the report.
- Indicate required fields, formatting, and timing.

## Usage Notes

- Often part of recurring obligations.
- May require formal approval before publishing.

## Changelog

- YYYY-MM-DD: Initial compliance report authored for [entity].
- YYYY-MM-DD: Added required eligibility field per updated policy.

```

---

## External Data Sharing Reports

```markdown
# [Report Name]

**Category:** External Data Sharing Reports  
**Source File:** `code/external-data-sharing-reports/file-name.sql`  
**Last Updated:** 2025-07-31  
**Author:** BHN Data Team  

## Purpose

Provide structured data exports for approved non-contractual partners  
(e.g. research, coordination, voluntary sharing).

## Sharing Context

- Identify recipient agency or collaboration purpose.
- Clarify whether the request is recurring or ad hoc.

## Usage Notes

- Tailor filters and formatting to recipient needs.
- Ensure sharing complies with internal guidelines.

## Changelog

- YYYY-MM-DD: Initial version for [partner agency].
- YYYY-MM-DD: Renamed demographic fields for consistency.

```

---

## Extract Queries

```markdown
# [Query Title]

**Category:** Extract Queries  
**Source File:** `code/extract-queries/file-name.sql`  
**Last Updated:** 2025-07-31  
**Author:** BHN Data Team  

## Purpose

Export structured data for external analysis or flat-file delivery.

## Output Description

- List fields returned and their source tables.
- Indicate whether data is filtered or raw.

## Usage Notes

- Intended for dashboards or downstream pipelines.

## Changelog

- YYYY-MM-DD: Initial query authored.

```

---

## Maintenance Queries

```markdown
# [Query Title]

**Category:** Maintenance Queries  
**Source File:** `code/maintenance-queries/file-name.sql`  
**Last Updated:** 2025-07-31  
**Author:** BHN Data Team  

## Purpose

Examine system-level objects or metadata for troubleshooting, schema analysis, or performance review.

## Scope

- Review system tables, views, indexes, or procedures.
- Read-only access; no data modification.

## Usage Notes

- Used by developers and DBAs.
- Often paired with performance diagnostics.

## Changelog

- YYYY-MM-DD: Initial maintenance query created.
- YYYY-MM-DD: Added filtering for `sys.indexes` by object type.

```

---

## Maintentance Scripts (e.g., UPDATE, DELETE, INSERT)

```markdown
# [Script Title]

**Category:** Maintenance Scripts  
**Source File:** `code/maintenance-scripts/file-name.sql`  
**Last Updated:** 2025-07-31  
**Author:** BHN Data Team  

## Purpose

Apply data corrections or cleanup actions.

## Reasoning

- Explain why rows need updating or removal.
- Reference related validation queries or reports.

## Affected Rows

- Describe filter criteria and estimated scope.

## Execution Notes

- Run in staging prior to production deployment.

## Changelog

- YYYY-MM-DD: Script created for FY25 onboarding cleanup.

```

---

## View Definitions

```markdown
# [View Name]

**Category:** View Definitions  
**Source File:** `code/view-definitions/file-name.sql`  
**Last Updated:** 2025-07-31  
**Author:** BHN Data Team  

## Purpose

Encapsulate reusable logic for reporting or downstream joins.

## Description

- Summarize joins, calculated fields, and filters.
- State intended report dependencies.

## Maintenance Notes

- Document changes carefully—may affect multiple reports.

## Changelog

- YYYY-MM-DD: Initial view definition authored.

```

---
