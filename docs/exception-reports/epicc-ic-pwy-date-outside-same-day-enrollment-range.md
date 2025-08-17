# EPICC IC PWY Date Outside Same Day Enrollment Range

**Category:** Exception Reports  
**Source File:** `code/exception-reports/epicc-ic-pwy-date-outside-same-day-enrollment-range.sql`  
**Last Updated:** 2025-08-05  
**Author:** Bradley Wing  
**Lifecycle:** `Production`

---

## Purpose

Flags EPICC Initial Contact records where the enrollment start and end dates are identical, but the pathway date differs. The business rule conveyed to the Recovery Coaches is that they should always record the Initial Contact Pathway Date as the date that shows for this event on the Master Pathway Dashboard. Since the dashboard always shows End Dates, this is one day outside of the enrollment start and end range for enrollments that are opened and closed on the same day to allow for an already active enrollment to remain open. Changing the Pathway Date for the Initial Contact to be the same date as the enrollment start date will correct duplication in PATHWAYEVENTCLIENT in almost every instance. One known exception to this is instances where the Initial Contact for a same day enrollment is missing. Pathways module will consider the Initial Contact for the active enrollment to satisfy this Pathway Event. If possible, the missing Initial Contact should be entered. Failing that, we will have to filter out Initial Contacts with PATHWAY_DATE <> ENROLLMENT_STARTING_DATE in R to remove duplicates unless and until GVT offers a substantial fix for the structural defect in the Pathways Module.

## Logic Summary

- Filters for records where `ENROLLMENT_STARTING_DATE = ENROLLMENT_ENDING_DATE`
- Excludes cases where `PATHWAY_DATE` matches the enrollment start date
- Limits to `PWY_EVENT = 'EPICC Initial Contact'`
- Returns client identifiers, pathway date, enrollment dates, and dismissal reason

## Usage Notes

- Intended for review by the Data Team and by EPICC Managers
- Useful for identifying Initial Contact Pathway Dates that must be rolled back by one day for the Pathways Module to record only one form for this PWY Event

## Changelog

- **2025-08-05**: Initial SQL query authored.
