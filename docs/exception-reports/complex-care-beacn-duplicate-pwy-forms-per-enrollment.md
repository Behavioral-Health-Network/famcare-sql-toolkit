---
front-matter-title: Complex Care BEACN Duplicate PWY Forms Per Enrollment
category: Exception Reports
source_file: code/exception-reports/complex-care-beacn-duplicate-pwy-forms-per-enrollment.sql
last_updated: 2025-12-18
author: Bradley Wing
status: active
lifecycle: production
program-scope: single
programs:
  - complex-care
tags:
  - exception-logic
dependencies:
  - q-complex-care-pathclient-enrollments
change_control: value
reviewed_by:
  - name: Bradley Wing
    date: 2025-12-18
last_reviewed: 2025-12-18
schema_version: 1.0
---

# Complex Care BEACN Duplicate Pathway Forms Per Enrollment

## Purpose

Identifies duplicate Complex Care Pathway forms (Roster, BEACN Metrics, PfP Discharge) associated with a single enrollment. For each client listed, staff should verify which form version is valid and delete any redundant entries.

## Logic Summary

- Queries `Q_COMPLEX_CARE_PATHCLIENT_ENROLLMENTS` for Pathway forms with a non-null `TIEDENROLLMENT`.
- Groups by client, enrollment start date, event type, and Pathway form serial number.
- Flags cases where `COUNT(PWY_FORMS_DOCSERNO) > 1`, indicating multiple forms tied to the same enrollment.

## Usage Notes

- Intended for internal remediation of duplicate documentation.
- Helps ensure one-to-one alignment between Pathway forms and enrollments.
- Staff should manually review flagged records and retain only the correct form.

## Changelog

- **2025-12-18**: Adds initial SQL query. Adds initial Markdown documentation.