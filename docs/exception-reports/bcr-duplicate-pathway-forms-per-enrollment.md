# Duplicate Pathway Forms per Enrollment

**Category:** Exception Reports  
**Source File:** `code/exception-reports/duplicate-pathway-forms-per-enrollment.sql`  
**Last Updated:** 2025-08-14  
**Author:** BHN Data Team  
**Lifecycle:** `Production`

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

- **2025-08-14**: Initial Markdown documentation authored.
- **2025-07-09**: Initial SQL query authored.
