---
front-matter-title: EPICC Referral Referring Agency IC PRO or CORE Mismatch View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-epicc-referral-referring-agency-ic-pro-or-core-mismatch.sql
last_updated: 2025-11-18
status: active
lifecycle: production
program_scope: single
programs:
  - epicc
tags:
  - view-layer
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# EPICC Referral Referring Agency IC PRO or CORE Mismatch View Definition

## Purpose

Identify EPICC enrollments where the **referring agency recorded on the EPICC Referral form** is inconsistent with the **PRO or CORE designation recorded on the Initial Contact (IC) form** for the same enrollment.  

Specifically, this view flags cases where:

- the Referral form indicates **Referring Agency = Community**, but  
- the Initial Contact form indicates **PRO_OR_CORE = PRO**

This mismatch suggests a documentation or workflow error, as Community referrals should not be classified as PRO in the IC form.

The view supports data quality review, program monitoring, and correction of inconsistent referral pathways.

## Description

This view combines data from EPICC Referral and EPICC Initial Contact forms by:

1. Building a referral‑level dataset (`EPICC_REF`) containing:
   - client identifiers  
   - enrollment identifiers  
   - referral pathway date  
   - enrollment start/end dates  
   - referring agency description  

2. Building an IC‑level dataset (`EPICC_IC`) containing:
   - client identifiers  
   - enrollment identifiers  
   - IC pathway date  
   - PRO or CORE designation  

3. Joining the two datasets on:
   - CLIENT_NUMBER  
   - TIEDENROLLMENT  

4. Returning only rows where:
   - an IC record exists for the enrollment  
   - the referral agency is **Community**  
   - the IC designation is **PRO**  

These conditions identify mismatches between referral source and IC classification, which may require staff review or correction.

## Output Fields

| Field Name                           | Description |
|--------------------------------------|-------------|
| `CLIENT_NUMBER`                      | Unique BHN client identifier. |
| `CLIENT_LAST`                        | Client last name from Q_CLIENT_BHN. |
| `CLIENT_FIRST`                       | Client first name from Q_CLIENT_BHN. |
| `REFERRAL_PATHWAY_DATE`              | Pathway date of the EPICC Referral form. |
| `IC_PATHWAY_DATE`                    | Pathway date of the EPICC Initial Contact form. |
| `ENROLLMENT_STARTING_DATE`           | Start date of the EPICC enrollment episode. |
| `ENROLLMENT_ENDING_DATE`             | End date of the EPICC enrollment episode, if applicable. |
| `EPICC_REFERRING_AGENCY_DESCRIPTION` | Referring agency recorded on the EPICC Referral form. |
| `PRO_OR_CORE`                        | PRO or CORE designation recorded on the Initial Contact form. |

## Maintenance Notes

- This view depends on the structure and stability of `Q_EPICC_PATHCLIENT_ENROLLMENTS`, `Q_EPICC_REFERRAL`, `Q_EPICC_IC`, and `Q_CLIENT_BHN`. Any changes to these objects may require updates.
- Mismatches may arise from staff selecting incorrect referral sources or misclassifying PRO/CORE on the IC form. Program staff should review flagged cases in FAMCare.
- If EPICC modifies referral workflows, introduces new referring agency codes, or changes PRO/CORE logic, the filter conditions in this view should be reviewed.
- The join on `PWY_FORMS_DOCSERNO` ensures that the Referral and IC forms are matched to the correct enrollment episode; changes to Pathway Event logic may affect this behavior.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
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

- **2025-11-18**: Adds initial SQL view definition. Adds initial Markdown documentation file.

</details>
</details>
<!---CHANGELOG-END--->
