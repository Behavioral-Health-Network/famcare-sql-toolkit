# BCR Grant Missing

**Category:** Exception Reports  
**Source File:** `code/exception-reports/bcr-grant-missing.sql`  
**Last Updated:** 2025-08-14  
**Author:** BHN Data Team  
**Lifecycle:** `Production`

## Purpose

Identifies clients whose BCR Initial Contact forms are missing required grant information. This report supports program compliance and funding requirements by ensuring all eligible clients have complete grant documentation.

## Logic Summary

- Flags records where `BIC.BCR_GRANT IS NULL`, indicating missing grant assignment.
- Joins `PWBCRINITIALCONTACT` to `BCR_GRANT` for descriptive grant names.
- Includes ZIP Code from both the client record and Initial Contact form to assist in determining appropriate grant assignment.
- Filters to active records (`DOCREVNO = ' 0 '`) in both both `PWBCRINITIALCONTACT` and `PROVIDERPLACEMENT` forms.

## Usage Notes

- Intended for internal review by program managers and staff.
- Supports remediation of incomplete grant documentation for BCR clients.
- ZIP Code fields can be used to infer likely grant assignment when missing.

## Changelog

- **2025-08-14**: Initial Markdown documentation authored.
- **2025-04-07**: Initial SQL query authored.
