---
front-matter-title: Q_YERE_CLIENT_NEEDS  
category: view-definitions  
category-label: View Definitions  
source_file: code/view-definitions/q_yere_client_needs.sql  
last_updated: 2025-09-12  
author: Bradley Wing  
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

- Pulls from `PWYERECLIENTNONBEHAVIORALNEEDSSUM`, filtering to original form submissions (`DOCREVNO = ' 0 '`).
- Includes both raw multi-select field (`YOUTH_NEEDS`) and pivoted binary fields for each need category.
- Joins to `Q_CLIENT_BHN` for demographic context and test client exclusion.
- Intended for use in Youth ERE program dashboards and client-level reporting.

## Maintenance Notes

- Confirm that all pivoted fields align with current form logic and JavaScript execution.
- Validate that `YOUTH_NEEDS` remains consistent with the binary field mappings.
- Review periodically to ensure new need categories are reflected in the view.
- Changes to this view may affect multiple downstream reports and dashboards.

## Changelog

- **2025-09-12**: Initial Markdown documentation authored.  
- **2025-09-12**: Initial SQL view authored.
