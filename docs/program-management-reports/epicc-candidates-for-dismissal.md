# EPICC Candidates for Dismissal

**Category:** Program Management Reports  
**Source File:** `code/program-management-reports/epicc-candidates-for-dismissal.sql`  
**Last Updated:** 2025-07-31  
**Author:** Bradley Wing  
**Lifecycle** `Deprecated`

---

## Purpose

This report is now considered defunct as it has been superseded by the revised `code/program-management-reports/epicc-candidates-for-re-engagement-or-dismissal.sql` report.

This report identifies EPICC program clients who are candidates for dismissal due to program completion, non-engagement resulting in a recommendation for termination, or a variety of program participation responses indicating that the client is ineligible, declined, has become incarcerated, become deceased, has been transferred to another state-wide EPICC region, etc. It supports decision-making around closure of enrollments that no longer meet continued outreach or engagement thresholds, in alignment with contractual obligations and program workflow.

## Scope of Review

- Evaluates program participation progression from Referral through Six-Month Follow-Up
- Prioritizes dismissal only if downstream participation is absent, if cient status indicates disengagement, or if program participation values align with dismissal reasons
- Safeguards clients still within outreach windows or transferred for re-engagement

## Eligibility Logic Summary

The report applies a tiered HAVING clause that cascades through key milestones:

| Tier | Milestone        | Inclusion Criteria                                                                                     |
|------|------------------|--------------------------------------------------------------------------------------------------------|
| 1    | Six Month        | Form exists                                                                                           |
| 2    | Three Month      | Form exists AND participation ≠ 'Engaged'                                                             |
| 3    | Thirty Day       | Form exists AND either: <br>– participation ≠ 'Engaged'<br>– participation = 'Not Engaged' AND status not in ('Outreaching', 'Transfer To Re-Engagement Specialist') |
| 4    | Two Week         | Form exists AND participation not in ('Engaged', 'Not Engaged')                                       |
| 5    | Initial Contact  | Form exists AND participation ≠ 'Enrolled With EPICC'                                                 |
| 6    | Referral         | Form exists AND participation ≠ 'Eligible For Services'                                               |

- Clients are excluded if they have milestone participation consistent with ongoing outreach or valid continuation flags in program participation fields
- Filters remove clients with Referral or Initial Contact = 'Unable To Contact/Locate' regardless of downstream data
- Logic ensures dismissal recommendations do not prematurely exclude clients within mandated outreach periods

## Technical Notes

- Uses `MAX(CASE...)` logic with milestone-aware filters per `PE.SHORTDESCRIPTION`
- Joins leverage `DATEACCOMPLISHED` for accurate form-to-event alignment
- Only includes active enrollments (`PP.ENDINGDATE IS NULL`)
- Excludes test clients
  
## Recommendations

- Review report routinely on an enrollment audit cycles set by the program leadership
- Keep dismissal criteria consistent with evolving policy language and external oversight standards

## Changelog

- **2025-08-06**: Fixes problematic joins to `PATHWAYCLIENT` and `PATHWAYEVENTCLIENT` by pulling the join logic from `Q_EPICC_PATHCLIENT_ENROLLMENTS`. The join to `PATHWAYCLIENT` was apparently not distinguishing between enrollments adequately, and at least one `PROGRAM_PARTICIPATION_IC` value from a different enrollment was being joined into another enrollment, resulting in a false positive showing.  
- **2025-08-06**: Adds `PP.ENDINGDATE IS NULL` to ensure that only clients with active enrollments may be considered for dismissal.
- **2025-08-01**: Adds yaml-like block and this changelog.
- **2025-07-29**: Adds initial version.
