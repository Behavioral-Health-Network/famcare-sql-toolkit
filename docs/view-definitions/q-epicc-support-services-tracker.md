---
front-matter-title: Q_EPICC_SUPPORT_SERVICES_TRACKER
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-epicc-support-services-tracker.sql
last_updated: 2025-12-12
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - epicc
tags:
  - tag1
  - tag2
dependencies:
  - name: pwepiccsupportservicestracker
    type: html
    repo: famcare-html-form-code
  - name: pwepiccsupportservicestracker
    type: table
    repo: none
  - name: q_client_bhn
    type: view
    repo: famcare-sql-toolkit
  - name: program-referral-sources
    type: table
    repo: none
  - name: community-referral-source
    type: table
    repo: none
  - name: epicc-ems-fire-district
    type: table
    repo: none
  - name: epicc-program-participation
    type: table
    repo: none
  - name: program-referral-sources
    type: table
    repo: none
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_EPICC_REFERRAL

## Purpose

## Description

## Logic Summary

- Uses `updateReportFields()` to pivot the fields `BEHAVIORAL_HEALTH_TYPE`, `PHYSICAL_HEALTH_TYPE`, `SOCIAL_SERVICES_TYPE`, `MATERNAL_HEALTH_TYPE`, and `HOUSING_TYPE` to columns with values of `0|1`.

- **Source Table:**
  - `PWEPICCSUPPORTSERVICESTRACKER` (aliased as `EPICC_SS_TRACKER`)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client metadata and test client exclusion
  - `LEFT JOIN EPICC_SUPPORT_SERVICE_AGENCIES` field (aliased 25 times)
    - `SUPPORT_SERVICE_OTHER_ESSA`
    - `CMHC_ESSA`
    - `GROUP_PEER_ESSA`
    - `IND_ESSA`
    - `SUBSTANCE_USE_ESSA`
    - `BEHAVIORAL_HEALTH_OTHER_ESSA`
    - `PH_OTHER_ESSA`
    - `FOOD_ESSA`
    - `CLOTHING_ESSA`
    - `HYGIENE_ESSA`
    - `UTILITY_ASSISTANCE_ESSA`
    - `CHILD_CARE_ESSA`
    - `DEVELOPMENTAL_DISABILITY_ESSA`
    - `DOMESTIC_VIOLENCE_ESSA`
    - `SS_OTHER_ESSA`
    - `PREGNANCY_RESOURCES_ESSA`
    - `PRE_POST_NATAL_CARE_ESSA`
    - `MH_OTHER_ESSA`
    - `SHELTER_HOUSING_ESSA`
    - `RECOV_ESSA`
    - `RESPITE_ESSA`
    - `TRANS_HOUSING_ESSA`
    - `HOMELESS_ESSA`
    - `HOUS_OTH_ESSA`
    - `SSA_ESSA`

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

## Output Column Matrices

<details markdown="1">
  <summary><strong>View Form Metadata Matrix</strong></summary>

### Form Metadata

| Column | Description |
|--------|-------------|
| ID | Internal record ID |
| DOCSERNO | Document serial number |
| VISITDT | Visit date |
| VISITTM | Visit time |
| USERID | User who entered the record |
| PARENTDOCSERNO | Parent document serial number |
| CLIENTNUMBER | Client identifier |
| PATHWAY_DATE | Pathway date |
| DOCREVNO | Document revision number (filtered to `' 0 '`) |

</details>
<details markdown="1">
  <summary><strong>Service Domain Matrices</strong></summary>

Each service domain follows a repeating pattern:

- **Code** → agency code stored in the tracker
- **Description** → human-readable agency name from lookup
- **Other** → free-text notes for agencies not in the lookup

<details markdown="1">
  <summary><strong>View Behavioral Health Services Matrix</strong></summary>

### Behavioral Health

| Column | Description |
|--------|-------------|
| BH_INDIVIDUAL_PEER_SUPPORT | Flag for individual peer support |
| INDIVIDUAL_PEER_SUPPORT_AGENCY_CODE | Agency code |
| INDIVIDUAL_PEER_SUPPORT_AGENCY_DESCRIPTION | Agency description |
| INDIVIDUAL_PEER_SUPPORT_AGENCY_OTHER | Other agency notes |
| BH_GROUP_PEER_SUPPORT | Flag for group peer support |
| GROUP_PEER_SUPPORT_AGENCY_CODE | Agency code |
| GROUP_PEER_SUPPORT_AGENCY_DESCRIPTION | Agency description |
| GROUP_PEER_SUPPORT_AGENCY_OTHER | Other agency notes |
| BH_SUBSTANCE_USE_SERVICES | Flag for substance use services |
| SUBSTANCE_USE_SERVICES_AGENCY_CODE | Agency code |
| SUBSTANCE_USE_SERVICES_AGENCY_DESCRIPTION | Agency description |
| SUBSTANCE_USE_SERVICES_AGENCY_OTHER | Other agency notes |
| BH_CMHC_SERVICES | Flag for CMHC services |
| CMHC_SERVICES_AGENCY_CODE | Agency code |
| CMHC_SERVICES_AGENCY_DESCRIPTION | Agency description |
| CMHC_SERVICES_AGENCY_OTHER | Other agency notes |
| BH_OTHER | Flag for other behavioral health |
| BEHAVIORAL_HEALTH_OTHER_AGENCY_CODE | Agency code |
| BEHAVIORAL_HEALTH_OTHER_AGENCY_DESCRIPTION | Agency description |
| BEHAVIORAL_HEALTH_OTHER_AGENCY_OTHER | Other agency notes |

</details>

<details markdown="1">
  <summary><strong>View Physical Health Services Matrix</strong></summary>

### Physical Health

| Column | Description |
|--------|-------------|
| PH_PRIMARY_CARE | Flag for primary care |
| PRIMARY_CARE | Agency code |
| PRIMARY_CARE_OTHER | Other agency notes |
| PH_DENTAL_CARE | Flag for dental care |
| DENTAL_CARE | Agency code |
| DENTAL_CARE_OTHER | Other agency notes |
| PH_OTHER | Flag for other physical health |
| PH_OTHER_AGENCY_CODE | Agency code |
| PH_OTHER_AGENCY_DESCRIPTION | Agency description |
| PH_OTHER_AGENCY_OTHER | Other agency notes |

</details>

<details markdown="1">
  <summary><strong>View Social Services Matrix</strong></summary>

### Social Services

| Column | Description |
|--------|-------------|
| SS_FOOD | Flag for food services |
| FOOD_AGENCY_CODE | Agency code |
| FOOD_AGENCY_DESCRIPTION | Agency description |
| FOOD_AGENCY_OTHER | Other agency notes |
| SS_CLOTHING | Flag for clothing services |
| CLOTHING_AGENCY_CODE | Agency code |
| CLOTHING_AGENCY_DESCRIPTION | Agency description |
| CLOTHING_AGENCY_OTHER | Other agency notes |
| SS_HYGIENE | Flag for hygiene services |
| HYGIENE_AGENCY_CODE | Agency code |
| HYGIENE_AGENCY_DESCRIPTION | Agency description |
| HYGIENE_AGENCY_OTHER | Other agency notes |
| SS_UTILITY_ASSISTANCE | Flag for utility assistance |
| UTILITY_ASSISTANCE_AGENCY_CODE | Agency code |
| UTILITY_ASSISTANCE_AGENCY_DESCRIPTION | Agency description |
| UTILITY_ASSISTANCE_AGENCY_OTHER | Other agency notes |
| SS_CHILD_CARE | Flag for child care |
| CHILD_CARE_AGENCY_CODE | Agency code |
| CHILD_CARE_AGENCY_DESCRIPTION | Agency description |
| CHILD_CARE_AGENCY_OTHER | Other agency notes |
| SS_DEVELOPMENTAL_DISABILITY | Flag for developmental disability |
| DEVELOPMENTAL_DISABILITY_AGENCY_CODE | Agency code |
| DEVELOPMENTAL_DISABILITY_AGENCY_DESCRIPTION | Agency description |
| DEVELOPMENTAL_DISABILITY_AGENCY_OTHER | Other agency notes |
| SS_DOMESTIC_VIOLENCE | Flag for domestic violence |
| DOMESTIC_VIOLENCE_AGENCY_CODE | Agency code |
| DOMESTIC_VIOLENCE_AGENCY_DESCRIPTION | Agency description |
| DOMESTIC_VIOLENCE_AGENCY_OTHER | Other agency notes |
| SS_OTHER | Flag for other social services |
| SS_OTHER_AGENCY_CODE | Agency code |
| SS_OTHER_AGENCY_DESCRIPTION | Agency description |
| SS_OTHER_AGENCY_OTHER | Other agency notes |

</details>

<details markdown="1">
  <summary><strong>View Maternal Health Services Matrix</strong></summary>

### Maternal Health

| Column | Description |
|--------|-------------|
| MH_PREGNANCY_RESOURCES | Flag for pregnancy resources |
| PREGNANCY_RESOURCES_AGENCY_CODE | Agency code |
| PREGNANCY_RESOURCES_AGENCY_DESCRIPTION | Agency description |
| PREGNANCY_RESOURCES_AGENCY_OTHER | Other agency notes |
| MH_PRE_POST_NATAL_CARE | Flag for pre/post-natal care |
| PRE_POST_NATAL_CARE_AGENCY_CODE | Agency code |
| PRE_POST_NATAL_CARE_AGENCY_DESCRIPTION | Agency description |
| PRE_POST_NATAL_CARE_AGENCY_OTHER | Other agency notes |
| MH_OTHER | Flag for other maternal health |
| MH_OTHER_AGENCY_CODE | Agency code |
| MH_OTHER_AGENCY_DESCRIPTION | Agency description |
| MH_OTHER_AGENCY_OTHER | Other agency notes |

</details>

<details markdown="1">
  <summary><strong>View Housing Services Matrix</strong></summary>

### Housing

| Column | Description |
|--------|-------------|
| H_SHELTER_HOUSING | Flag for shelter housing |
| SHELTER_HOUSING_AGENCY_CODE | Agency code |
| SHELTER_HOUSING_AGENCY_DESCRIPTION | Agency description |
| SHELTER_HOUSING_AGENCY_OTHER | Other agency notes |
| H_RECOVERY_HOUSING | Flag for recovery housing |
| RECOVERY_HOUSING_AGENCY_CODE | Agency code |
| RECOVERY_HOUSING_AGENCY_DESCRIPTION | Agency description |
| RECOVERY_HOUSING_AGENCY_OTHER | Other agency notes |
| H_RESPITE_HOUSING | Flag for respite housing |
| RESPITE_HOUSING_AGENCY_CODE | Agency code |
| RESPITE_HOUSING_AGENCY_DESCRIPTION | Agency description |
| RESPITE_HOUSING_AGENCY_OTHER | Other agency notes |
| H_TRANSITIONAL_HOUSING | Flag for transitional housing |
| TRANSITIONAL_HOUSING_AGENCY_CODE | Agency code |
| TRANSITIONAL_HOUSING_AGENCY_DESCRIPTION | Agency description |
| TRANSITIONAL_HOUSING_AGENCY_OTHER | Other agency notes |
| H_HOMELESS_SERVICES | Flag for homeless services |
| HOMELESS_SERVICES_AGENCY_CODE | Agency code |
| HOMELESS_SERVICES_AGENCY_DESCRIPTION | Agency description |
| HOMELESS_SERVICES_AGENCY_OTHER | Other agency notes |
| H_OTHER | Flag for other housing |
| HOUSING_OTHER_AGENCY_CODE | Agency code |
| HOUSING_OTHER_AGENCY_DESCRIPTION | Agency description |
| HOUSING_OTHER_AGENCY_OTHER | Other agency notes |

</details>

<details markdown="1">
  <summary><strong>View Supportive Services Matrix</strong></summary>

### Supportive Services

| Column | Description |
|--------|-------------|
| SS_SUPPORTIVE_SERVICES | Flag for supportive services |
| SUPPORTIVE_SERVICES_AGENCY_CODE | Agency code |
| SUPPORTIVE_SERVICES_AGENCY_DESCRIPTION | Agency description |
| SUPPORTIVE_SERVICES_AGENCY_OTHER | Other agency notes |

</details>

</details>

## Maintenance Notes

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

- **2025-12-12**: Adds initial Markdown documentation file.
- **2025-11-25**: Adds initial SQL view definition.
- **2025-10-08**: Adds HTML form.

</details>
</details>
