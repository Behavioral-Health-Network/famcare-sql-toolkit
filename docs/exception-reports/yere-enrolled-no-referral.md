---
front-matter-title: YERE Enrolled No Referral
category: Exception Reports
source_file: code/exception-reports/yere-enrolled-no-referral.sql
last_updated: 2025-12-18
author: Bradley Wing
status: active
lifecycle: production
program-scope: single
programs:
  - yere
tags:
  - exception-logic
  - tag2
dependencies:
  - value1
  - value2
change_control: value
reviewed_by:
  - name: Bradley Wing
    date: 2025-12-18
last_reviewed: 2025-12-18
schema_version: 1.0
---

# YERE Enrolled No Referral Exception Report

## Purpose

Identifies YERE enrollments that have no `PWYEREREFERRAL` form entered and joined on `TIEDENROLLMENT`.

## Logic Summary

## Output Fields

| Field Name                 | Description              |
|----------------------------|--------------------------|
| `CLIENT_NUMBER`            | Unique client identifier |
| `CLIENT_LAST`              | Client last name         |
| `CLIENT_FIRST`             | Client first name        |
| `ENROLLMENT_STARTING_DATE` | Date of enrollment start |
| `ENROLLMENT_ENDING_DATE`   | Date of enrollment end   |

## Usage Notes

- Intended for data team review.

## Maintenance Guidelines

## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

</details>

<details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

- **2025-12-18**: Adds initial SQL view definition. Adds initial Markdown documentation file.

</details>
</details>
