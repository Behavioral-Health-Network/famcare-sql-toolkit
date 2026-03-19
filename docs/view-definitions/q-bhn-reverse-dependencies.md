---
front-matter-title: BHN Reverse Dependencies View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-bhn-reverse-dependencies.sql
last_updated: 2026-03-17
status: active
lifecycle: production
program_scope: none
programs:
  - none
tags:
  - view-layer
  - dependency-mapping
dependencies:
  - Q_BHN_FULL_DEPENDENCY_LINEAGE
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# BHN Reverse Dependencies View Definition

## Purpose

Provides a *reverse* mapping of dependencies, identifying which upstream assets depend on a given SQL object or saved query.  
This view supports change‑impact analysis by answering the question:

> **“If this object changes, what breaks?”**

## Description

`Q_BHN_REVERSE_DEPENDENCIES` aggregates the recursive lineage data produced by  
`Q_BHN_FULL_DEPENDENCY_LINEAGE` and inverts the direction of dependency flow.

For each `NORMALIZED_OBJECT` (the *base object*), the view returns:

- The **root asset** that depends on it  
- The **type** of that root asset  
- The **minimum lineage depth** required to reach the dependency  

This allows governance tooling to quickly identify direct and indirect consumers of any SQL object, saved query, or documentation asset.

## SQL Definition

```sql
--ALTER VIEW dbo.Q_BHN_REVERSE_DEPENDENCIES AS 
SELECT DISTINCT
    NORMALIZED_OBJECT AS [BASE_OBJECT],
    ROOT_SOURCE_TYPE,
    ROOT_SOURCE_NAME,
    MIN(LINEAGE_LEVEL) AS [MIN_LINEAGE_LEVEL]
FROM dbo.Q_BHN_FULL_DEPENDENCY_LINEAGE
GROUP BY
    NORMALIZED_OBJECT,
    ROOT_SOURCE_TYPE,
    ROOT_SOURCE_NAME;
```

## Columns Returned

|       Field       |                                         Description                                         |   |
|:-----------------:|:-------------------------------------------------------------------------------------------:|---|
| `BASE_OBJECT`       | The normalized object being depended upon                                                   |   |
| `ROOT_SOURCE_TYPE`  | Type of the upstream asset (`SQL_OBJECT`, `SAVEDQUERY`, `DOCUMENTATION`)                          |   |
| `ROOT_SOURCE_NAME`  | Name of the upstream asset that depends on the base object                                  |   |
| `MIN_LINEAGE_LEVEL` | The shortest dependency path from the root asset to the base object (1 = direct dependency) |   |

## Behavior Notes

- A single base object may have multiple upstream dependents.
- `MIN_LINEAGE_LEVEL = 1` indicates a direct dependency.
- Higher lineage levels indicate indirect dependencies discovered through recursive expansion.
- This view is intentionally non‑recursive; all recursion is handled by `Q_BHN_FULL_DEPENDENCY_LINEAGE`.

## Maintenance Notes

- Ensure `Q_BHN_FULL_DEPENDENCY_LINEAGE` remains stable, as this view depends entirely on its structure.
- If lineage depth rules change (e.g., increasing the recursion cap), this view will automatically reflect those changes.
- This view is used by governance dashboards and change‑scope workflows to surface impact analysis.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026‑03‑17**: Adds initial Markdown documentation file documentation. Confirms compatibility with program metadata model.
- **2026‑03‑10**: Adds initial SQL view definition of reverse dependency look up for change impact workflows.

</details>
</details>
<!---CHANGELOG-END--->
