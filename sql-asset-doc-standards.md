# Style Guide for SQL Queries and Other Assets (Markdown-Based)

This guide defines the canonical Markdown documentation structure for all SQL assets in the `FAMCare-SQL-Toolkit` repository. Every `.sql` file in `/code/<category>/` should have a matching `.md` file in `/docs/<category>/`. The Markdown file is the single source of truth for purpose, logic, usage and history—no full comments belong in the SQL itself. Instead, a standardized SQL comment header should be used. Templates for the documentation files may be located below.

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

See docs/view-definitions/q-bcr-client-counseling-sessions.md for full documentation.
*/
```

---

## Standardized Markdown Frontmatter YAML

### Schema Version Tag Reference

Use `schema_version:` in the frontmatter to indicate which version of the documentation schema is being used. This tracks changes to the structure of the YAML itself—not the SQL asset or table.

Increment when:

- New frontmatter fields are introduced (e.g., `dependencies`, `program_scope`).
- Field names or conventions are updated.
- Contributor expectations or validation rules change.

> **Example:**

```yaml
schema_version: 1.0
```

This field supports future linting, backward compatibility, and contributor onboarding. It does **not** reflect changes to the SQL logic or table structure. Increment by whole numbers.

### Lifecycle Tag Reference

Use the `lifecycle:` field in Markdown frontmatter to indicate the operational status of a report or view.

|      Value     |                                Meaning                               |               Contributor Guidance              |
|:--------------:|:--------------------------------------------------------------------:|:-----------------------------------------------:|
| `production`   | Actively updated and used in live reporting workflows.               | Keep documentation current; test regularly.     |
| `deprecated`   | Superseded by a newer report/view but still available for reference. | Flag in changelog; avoid new dependencies.      |
| `retired`      | No longer in use; retained for historical or audit purposes.         | Do not modify; archive if appropriate.          |
| `experimental` | Under development or pilot use; not yet approved for production.     | Document clearly; coordinate with stakeholders. |

>_Note: Lifecycle tags should be updated whenever a report’s status changes due to program shifts, vendor transitions, or internal restructuring. Use backticks around the lifecyle tag in the header to visually distinguish these as controlled values._

---

### Change Control Tag Reference

Use the `change_control` field in Markdown frontmatter to indicate whether an asset has external constraints or internal review protocols that affect how it can be changed.  

|          Value           |                          Meaning                          |                        Example                       |
|:------------------------:|:---------------------------------------------------------:|:----------------------------------------------------:|
| `vendor-dependent`         | Changes may break vendor logic or require vendor approval.| HRFORM logic is tied to USERID assignments           |
| `requires-rollback-plan`   | Changes must be reversible and tested in staging.         | Maintenance scripts or form logic                    |
| `cross-repo-coordination`  | Changes affect multiple repos.                            | SQL views used in both reporting and form validation |
| `internal-review-required` | Must be reviewed by Data Team before publishing.          | Compliance reports or audit logic                    |
| `low-risk`                 | Freely editable with minimal impact.                      | Standalone documentation or exploratory queries      |

> _Note: Use of compound values is acceptable when more than one `change-control` constraint applies._

```yaml
change_control:
  - vendor-dependent
  - requires-rollback-plan
```

---

## Documentation Templates for Markdown Documentation

> See [Documentation Standards](https://github.com/Behavioral-Health-Network/BHN-Data-Team-Wiki/blob/main/docs/wiki-architecture/documentation-standards.md) for guidance on formatting changelogs.

---

## Exception Reports

```yaml
---
front-matter-title: asset-name
category: exception-reports
category-label: Exception Reports
source_file: code/exception-reports/file-name.sql
last_updated: YYYY-MM-DD
author: author
status: active
lifecycle: production
tags:
  - tag1
  - tag2
program-scope: single | multi
programs:
  - program1
  - program2 (if relevant)
dependencies:
  - name: value1
    type: type1
    repo: repo1
  - name: value2
    type: type2
    repo: repo2
change_control: value
reviewed_by:
  - name: name
  - date: YYYY-MM-DD
last_reviewed: YYYY-MM-DD
schema_version: 1.0
---
```

```markdown
# Report Name

## Purpose

Describe the exception being flagged (e.g. overlapping dates, missing forms, duplicated submissions).

## Logic Summary

- Identify key joins, filters, and logic used.
- Specify any thresholds (e.g. enrollment gaps > 90 days).

## Usage Notes

- Intended for internal review or staff remediation.

## Changelog

- **YYYY-MM-DD**: Adjusts filter to exclude dismissed clients.
- **YYYY-MM-DD**: Adds initial SQL query.
```

---

## Program Management Reports

```yaml
---
front-matter-title: asset-name
category: program-management-reports
category-label: Program Management Reports
source_file: code/program-management-reports/file-name.sql
last_updated: YYYY-MM-DD
status: active
lifecycle: production
tags:
  - tag1
  - tag2
program-scope: single | multi
programs:
  - program1
  - program2 (if relevant)
dependencies:
  - name: value1
    type: type1
    repo: repo1
  - name: value2
    type: type2
    repo: repo2
change_control: value
reviewed_by:
  - name: name
  - date: YYYY-MM-DD
last_reviewed: YYYY-MM-DD
schema_version: 1.0
---
```

```markdown
# Report Name

## Purpose
 
Summarize or segment data to support caseload tracking, grant monitoring, or service planning.

## Key Metrics

- Describe aggregation logic, counts, or grouping rules.

## Filters

- Note time-based or demographic constraints.

## Changelog

- **YYYY-MM-DD**: Adds agency filter logic.
- **YYYY-MM-DD**: Adds initial SQL query.
```

---

## Audit Reports

```yaml
---
front-matter-title: asset-name
category: audit-reports
category-label: Audit Reports
source_file: code/audit-reports/file-name.sql
last_updated: YYYY-MM-DD
author: author
status: active
lifecycle: production
tags:
  - tag1
  - tag2
program-scope: single | multi
programs:
  - program1
  - program2 (if relevant)
dependencies:
  - name: value1
    type: type1
    repo: repo1
  - name: value2
    type: type2
    repo: repo2
change_control: value
reviewed_by:
  - name: name
  - date: YYYY-MM-DD
last_reviewed: YYYY-MM-DD
schema_version: 1.0
---
```

```markdown
# Report Name

## Purpose

Validate procedural compliance, user actions, or documentation completeness.

## Audit Scope

- List tracked actions (e.g. form submissions, report runs).
- Define timeframes or actors under review.

## Changelog

- **YYYY-MM-DD**: Expands audit scope to include housing status forms.
- **YYYY-MM-DD**: Adds initial SQL query.
```

---

## Compliance Reports

```yaml
---
front-matter-title: asset-name
category: compliance-reports
category-label: Compliance Reports
source_file: code/compliance-reports/file-name.sql
last_updated: YYYY-MM-DD
status: active
lifecycle: production
tags:
  - tag1
  - tag2
program-scope: single | multi
programs:
  - program1
  - program2 (if relevant)
dependencies:
  - name: value1
    type: type1
    repo: repo1
  - name: value2
    type: type2
    repo: repo2
change_control: value
reviewed_by:
  - name: name
  - date: YYYY-MM-DD
last_reviewed: YYYY-MM-DD
schema_version: 1.0
---
```

```markdown
# Report Name

## Purpose

Fulfill contractual, policy-based, or regulatory requirements through structured exports.

## Compliance Scope

- Define the regulation, grant, or external party receiving the report.
- Indicate required fields, formatting, and timing.

## Usage Notes

- Often part of recurring obligations.
- May require formal approval before publishing.

## Changelog

- **YYYY-MM-DD**: Adds required eligibility field per updated policy.
- **YYYY-MM-DD**: Adds initial compliance report authored for [entity].
```

---

## External Data Sharing Reports

```yaml
---
front-matter-title: asset-name
category: external-data-sharing-reports
category-label: External Data Sharing Reports
source_file: code/external-data-sharing-reports/file-name.sql
last_updated: YYYY-MM-DD
author: author
status: active
lifecycle: production
tags:
  - tag1
  - tag2
program-scope: single | multi
programs:
  - program1
  - program2 (if relevant)
dependencies:
  - name: value1
    type: type1
    repo: repo1
  - name: value2
    type: type2
    repo: repo2
change_control: value
reviewed_by:
  - name: name
  - date: YYYY-MM-DD
last_reviewed: YYYY-MM-DD
schema_version: 1.0
---
```

```markdown
# Report Name

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

- **YYYY-MM-DD**: Renames demographic fields for consistency.
- **YYYY-MM-DD**: Adds initial SQL query for [partner agency].
```

---

## Extract Queries

```yaml
---
front-matter-title: asset-name
category: extract-queries
category-label: Extract Queries
source_file: code/extract-queries/file-name.sql
last_updated: YYYY-MM-DD
author: author  
status: active
lifecycle: production
tags:
  - tag1
  - tag2
program-scope: single | multi
programs:
  - program1
  - program2 (if relevant)
dependencies:
  - name: value1
    type: type1
    repo: repo1
  - name: value2
    type: type2
    repo: repo2
change_control: value
reviewed_by:
  - name: name
  - date: YYYY-MM-DD
last_reviewed: YYYY-MM-DD
schema_version: 1.0
---
```

```markdown
# Query Title

## Purpose

Export structured data for external analysis or flat-file delivery.

## Output Description

- List fields returned and their source tables.
- Indicate whether data is filtered or raw.

## Usage Notes

- Intended for dashboards or downstream pipelines.

## Changelog

- **YYYY-MM-DD**: Replaces something.
- **YYYY-MM-DD**: Adds initial SQL query.
```

---

## Maintenance Queries

```yaml
front-matter-title: asset-name
category: maintenance-queries
category-label: Maintenance Queries
source_file: `code/maintenance-queries/file-name.sql
last_updated: YYYY-MM-DD
author: author
status: active
lifecycle: production
tags:
  - tag1
  - tag2
program-scope: single | multi
programs:
  - program1
  - program2 (if relevant)
dependencies:
  - name: value1
    type: type1
    repo: repo1
  - name: value2
    type: type2
    repo: repo2
change_control: value
reviewed_by:
  - name: name
  - date: YYYY-MM-DD
last_reviewed: YYYY-MM-DD
schema_version: 1.0
---
```

```markdown

# Query Title

## Purpose

Examine system-level objects or metadata for troubleshooting, schema analysis, or performance review.

## Scope

- Review system tables, views, indexes, or procedures.
- Read-only access; no data modification.

## Usage Notes

- Used by developers and DBAs.
- Often paired with performance diagnostics.

## Changelog

- **YYYY-MM-DD**: Adds filtering for `sys.indexes` by object type.
- **YYYY-MM-DD**: Adds initial maintenance SQL query.
```

---

## Maintentance Scripts (e.g., UPDATE, DELETE, INSERT)

```yaml
front-matter-title: asset-name
category: maintenance-scripts
category-label: Maintenance Scripts
source_file: code/maintenance-scripts/file-name.sql
last_updated: YYYY-MM-DD
author: author
status: active
lifecycle: production
tags:
  - tag1
  - tag2
program-scope: single | multi
programs:
  - program1
  - program2 (if relevant)
dependencies:
  - name: value1
    type: type1
    repo: repo1
  - name: value2
    type: type2
    repo: repo2
change_control: value
reviewed_by:
  - name: name
  - date: YYYY-MM-DD
last_reviewed: YYYY-MM-DD
schema_version: 1.0
---
```

```markdown

# Script Title

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

- **YYYY-MM-DD**: Updates something.
- **YYYY-MM-DD**: Adds initial SQL script for [purpose].
```

---

## View Definitions

```yaml
---
front-matter-title: asset-name
category: view-definitions
category-label: View Definitions
source_file: code/view-definitions/file-name.sql
last_updated: YYYY-MM-DD
author: author
status: active
lifecycle: production
tags:
  - tag1
  - tag2
program-scope: single | multi
programs:
  - program1
  - program2 (if relevant)
dependencies:
  - name: value1
    type: type1
    repo: repo1
  - name: value2
    type: type2
    repo: repo2
change_control: value
reviewed_by:
  - name: name
  - date: YYYY-MM-DD
last_reviewed: YYYY-MM-DD
schema_version: 1.0
---
```

```markdown
# View Name

## Purpose

Encapsulate reusable logic for reporting or downstream joins.

## Description

- Summarize joins, calculated fields, and filters.
- State intended report dependencies.

## Maintenance Notes

- Document changes carefully—may affect multiple reports.

## Changelog

- **YYYY-MM-DD**: Fixes something.
- **YYYY-MM-DD**: Adds initial view definition.
```

---
