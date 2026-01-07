---
front-matter-title: ERE Duplicate PWY Forms W Child Sum Joins
category: Exception Reports
source_file: code/exception-reports/ere-duplicate-pwy-forms-w-child-sum-joins.sql
last_updated: 2025-12-22
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - ere
tags:
  - sql-view
  - exception-logic
dependencies:
  - name: q-ere-pathclient-enrollments
    type: sql
    repo: famcare-sql-toolkit
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-11-03
last_reviewed: 2025-11-03
schema_version: 1.0
---

# ERE Duplicate PWY Forms W Child Sum Joins

## Purpose

Identify duplicate ERE Pathway forms (Referral, IHNA, Follow-Up, etc.) submitted for the same enrollment. This query flags potential duplicates requiring manual review to determine which version should be retained. Non-authoritative versions should be deleted with caution. To facilitate this assessment, the views `Q_ERE_ALL_HOUSING_STATUS` and `Q_ERE_ALL_PAYOR_SOURCE` have been joined so that the `DOCSERNO` of the parent forms that are duplicated may be compared to the `PARENTDOCSERNO` on the summation records.

## Logic Summary

- **Common table expression `DUPES`**
  - Select completed enrollments (`TIEDENROLLMENT IS NOT NULL`) from `Q_ERE_PATHCLIENT_ENROLLMENTS`.
  - Duplicate check groups by `CLIENT_NUMBER`, `PWY_START_DATE`, `PWY_EVENT`, `EVENT_START_DATE`, and `TIEDENROLLMENT`.
  - Counts distinct `PWY_FORMS_DOCSERNO` values within each group.
  - Return only groups with count of `PWY_FORMS_DOCSERNO` greater than 1, indicating duplicate form submissions.
- **Common table expression `DUPES_DETAIL`**
  - Carries `PWY_FORMS_DOCSERNO` separately so that this field may be joined with the results of the `DUPES CTE`
- **Common table expressions `HOUSE_CHILD` and `PAY_CHILD`**
  - Select `CLIENT_NUMBER`, `PARENT_DOCSERNO`, and `PARENT_PWY_EVENT`
- **Outer `SELECT`**
  - Left joins `HOUSING_CHILD` and `PAY_CHILD` to `DUPES_DETAIL` to add the `PARENT_DOCSERNO` from each child summation record.
  - Inner joins `DUPES` to reduce the result set to those `HAVING COUNT(EREENROLL.PWY_FORMS_DOCSERNO) > 1`.

### Query Flow Diagram

```js
DUPES (aggregate duplicates check)
        │
        └──> DUPES_DETAIL (row-level duplicate forms, includes DOCSERNO)
                  │
                  ├── LEFT JOIN HOUSE_CHILD (Housing Status child forms)
                  │
                  ├── LEFT JOIN PAY_CHILD (Payor Source child forms)
                  │
                  └── INNER JOIN DUPES (to carry duplicate count)
                              │
                              ▼
                     Result (parent form + child linkages + dupe count)
```

## Output Fields

| Field Name             | Description                                                |
|------------------------|------------------------------------------------------------|
| `CLIENT_NUMBER`        | Unique client identifier                                   |
| `DUPE_COUNT`           | Number of duplicate Pathway Event forms for the enrollment |
| `PARENT_PWY_EVENT`     | Pathway Event type of the duplicated parent form           |
| `PARENT_VISIT_DATE`    | Visit date of the duplicated parent form                   |
| `PARENT_VISIT_TIME`    | Visit time of the duplicated parent form                   |
| `PARENT_DOCSERNO`      | Document serial number of the duplicated parent form       |
| `HOUSE_CHILD_DOCSERNO` | Child Housing Status form linked to the parent DOCSERNO    |
| `HOUSE_PARENT_EVENT`   | Pathway Event type of the Housing Status child form        |
| `PAY_CHILD_DOCSERNO`   | Child Payor Source form linked to the parent DOCSERNO      |
| `PAY_PARENT_EVENT`     | Pathway Event type of the Payor Source child form          |
| `TIEDENROLLMENT`       | Enrollment key ensuring one‑to‑one cardinality             |

## Usage Notes

- Intended for internal review by program or Data Team staff.
- Confirm authoritative version for each duplicated entry before cleanup.
- Optionally reference audit log or historical submission timestamps to guide decision-making.

## Maintenance Notes

- Child view dependencies: If `Q_ERE_ALL_HOUSING_STATUS`, or `Q_ERE_ALL_PAYOR_SOURCE` change their column names or linkage logic, update this view accordingly.
- Duplicate detection window: The filter `ENROLLMENT_STARTING_DATE >= '2024-07-01'` is hard‑coded. Review periodically to ensure the window aligns with program reporting needs.
- Form linkage integrity: Ensure that child forms always reference a valid `PARENT_DOCSERNO`. If parent forms are deleted, child records may orphan.
- Performance considerations: The duplicate detection (`COUNT` + `HAVING`) can be expensive on large datasets. Indexing on `CLIENT_NUMBER`, `PWY_START_DATE`, `PWY_EVENT`, and `TIEDENROLLMENT` will help.
- Audit alignment: If audit logs or submission timestamps are added to the source views, consider surfacing them here to aid decision‑making.

## Changelog

- **2025-12-19**: Adds initial SQL view definition. Adds initial Markdown documentation. Converts existing '[Exception Report] ERE Duplicate PWY Forms Per Enrollment' to a view defintion to allow for use of `CTEs`.
- **2025-12-18**: Updates query to substitute `TIEDENROLLMENT` in place of `PEC_PATHCLIENT_DOCSERNO` and `DATE_ACCOMPLISHED` because `TIEDENROLLMENT` assures cardinality is one-to-one, while `DATE_ACCOMPLISHED` may be `NULL` even when a form exists and has been joined to the enrollment.
- **2025-07-13**: Adds initial SQL query of original exception report. Adds initial Markdown documentation for original exception report.
