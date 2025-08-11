# BCR Client Active 90 Days or Longer

**Category:** Exception Reports  
**Source File:** `code/exception-reports/bcr-client-active-90-days-or-longer.sql`  
**Last Updated:** 2025-07-31  
**Author:** BHN Data Team  

---

## Purpose

Identifies BCR clients who have been actively enrolled for 90 days or more.  
This report supports program leadership in reviewing clients for timely dismissal, ensuring outreach coordinators have had sufficient time to engage and serve each client.

---

## Logic Summary

- Selects clients with open enrollments (`ENDINGDATE IS NULL`) from `PROVIDERPLACEMENT`.
- Filters for enrollments with `DOCREVNO = ' 0 '` to exclude revisions.
- Calculates 90-day review date using `DATEADD(DAY, 90, ENROLLMENT_STARTING_DATE)`.
- Joins to `PATHWAYCLIENT` to confirm enrollment alignment.
- Excludes test clients via upstream filters (assumed in `Q_CLIENT_BHN`).
- Returns distinct client records with enrollment and review dates.

---

## Output Fields

| Field Name              | Description                                 |
|------------------------|---------------------------------------------|
| `CLIENT_NUMBER`         | Unique client identifier                    |
| `CLIENT_LAST`           | Client last name                            |
| `CLIENT_FIRST`          | Client first name                           |
| `ENROLLMENT_STARTING_DATE` | Date of enrollment start                  |
| `90_DAY_DATE`           | Calculated date marking 90 days of enrollment |

---

## Usage Notes

- Intended for internal program review and client engagement tracking.
- May be used to support dismissal decisions or outreach follow-up.
- Ensure business rules for enrollment duration remain aligned with program expectations.
- Review logic periodically to confirm alignment with evolving program workflows.

---

## Maintenance Guidelines

- Confirm joins and filters reflect current business rules and data structures.
- Validate that `PATHWAYCLIENT.STARTDATE` matches `PROVIDERPLACEMENT.STARTINGDATE`.
- Test regularly to ensure accuracy and avoid silent misattribution.
- Document any changes in the changelog below.

---

## Changelog

- **2025-07-31** – Markdown documentation authored.  
  - Adds logic summary and output field descriptions.  
  - Standardizes comment block and Markdown structure.  
  - Confirms alignment with exception reporting standards.
- **2025-04-29** – Initial SQL version authored.  
