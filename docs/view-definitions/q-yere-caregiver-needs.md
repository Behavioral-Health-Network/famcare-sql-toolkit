---
front-matter-title: Q_YERE_CAREGIVER_NEEDS
category: view-definitions  
category-label: View Definitions  
source_file: code/view-definitions/q_yere_caregiver_needs.sql  
last_updated: 2025-12-17  
author: Bradley Wing  
status: active  
lifecycle: production  
tags:
  - caregiver-needs
  - pathway-data
  - updatereportfields-pivots
program-scope: single  
programs:
  - yere  
dependencies:
  - name: pwyerecaregiverprogramneeds  
    type: table  
    repo: famcare-html-form-code  
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
change_control: production  
reviewed_by:
  - name: Bradley Wing  
    date: 2025-09-12  
last_reviewed: 2025-09-12  
schema_version: 1.0  
---

# Q_YERE_CLIENT_NEEDS

## Purpose

Encapsulates logic for extracting non-behavioral health needs recorded for Youth ERE clients. Supports program staff in identifying service gaps and prioritizing outreach based on documented needs.

## Description

- Pulls from `PWYERECAREGIVERPROGRAMNEEDS`, filtering to original form submissions (`DOCREVNO = ' 0 '`).
- Includes both raw multi-select field (`CAREGIVER_NEEDS`) and pivoted binary fields for each need category.
- Joins to `Q_CLIENT_BHN` for demographic context and test client exclusion.
- Intended for use in Youth ERE program dashboards and client-level reporting.

## Maintenance Notes

- Confirm that all pivoted fields align with current form logic and JavaScript execution.
- Validate that `CAREGIVER_NEEDS` remains consistent with the binary field mappings.
- Review periodically to ensure new need categories are reflected in the view.
- Changes to this view may affect multiple downstream reports and dashboards.

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

- **2025-12-17**: Initial SQL view authored. Initial Markdown documentation authored.

</details>
</details>
