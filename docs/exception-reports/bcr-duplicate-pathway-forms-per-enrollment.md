---
front-matter-title: Duplicate Pathway Forms Per Enrollment
category: Exception Reports
source_file: code/exception-reports/duplicate-pathway-forms-per-enrollment.sql
last_updated: 2025-08-14
author: Bradley Wing
status: active
lifecycle: production
program-scope: single
programs:
  - bcr
tags:
  - exception-logic
  - tag2
dependencies:
  - q-bcr-pathclient-enrollments
change_control: value
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Duplicate Pathway Forms Per Enrollment

## Purpose

Identifies duplicate Pathway forms (Referral, Initial Contact, follow-up forms, etc.) associated with a single enrollment. For each client listed, staff should verify which form version is valid and delete any redundant entries.

## Logic Summary

- Queries `Q_BCR_PATHCLIENT_ENROLLMENTS` for Pathway forms with a non-null `PE_DATE_ACCOMPLISHED`.
- Groups by client, enrollment start date, event type, and Pathway form serial number.
- Flags cases where `COUNT(PWY_FORMS_DOCSERNO) > 1`, indicating multiple forms tied to the same enrollment.

## Usage Notes

- Intended for internal remediation of duplicate documentation.
- Helps ensure one-to-one alignment between Pathway forms and enrollments.
- Staff should manually review flagged records and retain only the correct form.

## Changelog

- **2025-09-18**: Adds exception-logic tag and front-matter-title.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-14**: Adds initial Markdown documentation.
- **2025-07-09**: Adds initial SQL query.
