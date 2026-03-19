---
front-matter-title: YERE Client Needs View Definition  
category: view-definitions  
category-label: View Definitions  
source_file: code/view-definitions/q_yere_client_needs.sql  
last_updated: 2025-09-12  
status: active  
lifecycle: production  
tags: [youth-ere, client-needs, pathway-data, pivot-fields]  
program-scope: single  
programs:
  - yere  
dependencies:
  - name: pwyereclientnonbehavioralneedssum  
    type: table  
    repo: famcare-html-form-code  
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
change_control: production  
schema_version: 1.0  
---

# YERE Client Needs View Definition

## Purpose

Encapsulates logic for extracting non-behavioral health needs recorded for Youth ERE clients. Supports program staff in identifying service gaps and prioritizing outreach based on documented needs.

## Description

- Pulls from `PWYERECLIENTNONBEHAVIORALNEEDSSUM`, filtering to original form submissions (`DOCREVNO = ' 0 '`).
- Includes both raw multi-select field (`YOUTH_NEEDS`) and pivoted binary fields for each need category.
- Joins to `Q_CLIENT_BHN` for demographic context and test client exclusion.
- Intended for use in Youth ERE program dashboards and client-level reporting.

## Maintenance Notes

- Confirm that all pivoted fields align with current form logic and JavaScript execution.
- Validate that `YOUTH_NEEDS` remains consistent with the binary field mappings.
- Review periodically to ensure new need categories are reflected in the view.
- Changes to this view may affect multiple downstream reports and dashboards.

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

- **2025-12-12**: Adds collapsible `<details>` elements to the Changelog section.
- **2025-09-12**: Initial SQL view authored. Initial Markdown documentation authored.

</details>
</details>
<!---CHANGELOG-END--->
