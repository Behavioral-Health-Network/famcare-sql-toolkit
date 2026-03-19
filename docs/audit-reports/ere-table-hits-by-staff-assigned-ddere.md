---
front-matter-title: ERE Table Hits By Staff Assigned to DDERE Security Group Audit Report
category: audit-reports
category_label: Audit Reports
source_file: code/reports/program-worker-form-interaction-audit.sql
last_updated: 2026-03-17
status: active
lifecycle: production
program_scope: single
program:
  - ere
tags:
  - audit-report
  - workforce
  - form-usage
  - famcare-log
dependencies:
  - name: Q_HRFORM
    type: sql
    repo: famcare-sql-toolkit
  - name: LOG
    type: table
    repo: famcare-database
schema_version: 1.0
---

# ERE Table Hits By Staff Assigned to DDERE Security Group Audit Report

## Purpose

This report provides an **audit of form‑level interactions** performed by active program staff within FAMCare. It counts how many times each worker has saved or updated specific form‑generated tables, allowing supervisors and program managers to:

- Monitor staff activity across key documentation domains  
- Identify training needs or unusual patterns of form usage  
- Validate that required forms are being completed by assigned workers  
- Support quality assurance, compliance, and workload distribution reviews  

The report is keyed by **employee number**, **FAMCare user ID**, and **LOG.USERID**, ensuring traceability across HR records and system‑level audit logs.

---

## Description

The report joins:

- `Q_HRFORM` — authoritative HR roster of active employees  
- `LOG` — system audit log capturing table‑level save events  

Only workers who are:

- `DDERE = 'ON'` (enabled in FAMCare)  
- `EMPSTATUS = 'Active'`  

…are included.

For each worker, the report counts how many times they have saved records to specific form‑generated tables. Each table corresponds to a FAMCare form or domain‑specific data entry workflow.

The output is a **wide, pivot‑style summary** with one row per worker and one column per form type.

---

## Logic Summary

### 1. Worker Identification

- Pull all active workers from `Q_HRFORM`  
- Filter to those with FAMCare access (`DDERE = 'ON'`)  

### 2. Audit Log Join

- Left join to `LOG` on `FAMCAREUSERID = LOG.USERID`  
- Ensures workers with zero activity still appear  

### 3. Form Hit Counting

For each form type, the report computes:

```sql
SUM(CASE WHEN LOG.[TABLE] = '<table>' THEN 1 ELSE 0 END)
```

Special handling:

- `CLIENT` and `Client` are treated as the same form  
- All counts represent **save events**, not distinct records  

### 4. Output

One row per worker with counts for:

- Client  
- Client Identifying Information  
- Relationship  
- Enrollment  
- Pathway Assignment  
- Primary Provider Code History  
- Program Worker History  
- Case Notes  
- Hospital Visit Notes  
- Referral  
- IHNA  
- Three‑Month Follow‑Up  
- Six‑Month Follow‑Up  
- Behavioral Health Service  
- Client Needs  
- Housing Status  
- Payor Source  

---

## Output Fields

| Field | Description |
|-------|-------------|
| `EMPLOYEENUMBER` | HR employee identifier |
| `FAMCAREUSERID` | FAMCare system user ID |
| `USERID` | Audit log user ID (should match FAMCAREUSERID) |
| `CLIENT FORM HITS` | Saves to CLIENT/Client tables |
| `CLIENT IDENTIFYING INFORMATION FORM HITS` | Saves to ClientPassport |
| `RELATIONSHIP FORM HITS` | Saves to RELATIONSHIP |
| `ENROLLMENT FORM HITS` | Saves to PROVIDERPLACEMENT |
| `PATHWAY ASSIGNMENT FORM HITS` | Saves to PATHWAYCLIENT |
| `PRIMARY PROVIDER CODE HISTORY FORM HITS` | Saves to PrimaryProviderCodeHistory |
| `PROGRAM WORKER HISTORY FORM HITS` | Saves to PlacementProgramWorkerHistory |
| `CASE NOTE FORM HITS` | Saves to CASENOTEDETAIL |
| `HOSPITAL VISIT NOTE FORM HITS` | Saves to PWEREHospitalVisitNote |
| `REFERRAL FORM HITS` | Saves to PWEREReferral |
| `IHNA FORM HITS` | Saves to PWEREIHNA |
| `THREE-MONTH FOLLOW-UP FORM HITS` | Saves to PWEREThreeMonthFollowUp |
| `SIX-MONTH FOLLOW-UP FORM HITS` | Saves to PWERESixMonthFollowUp |
| `BEHAVIORAL HEALTH SERVICE FORM HITS` | Saves to PWEREBehavioralHealthService |
| `CLIENT NEEDS FORM HITS` | Saves to PWEREClientNeeds |
| `HOUSING STATUS FORM HITS` | Saves to PWHousingStatus |
| `PAYOR SOURCE FORM HITS` | Saves to PWPayorSource |

---

## Maintenance Notes

- **Form Additions:** When new FAMCare forms are introduced, add corresponding `SUM(CASE…)` expressions.  
- **Table Renames:** If form‑generated tables change names, update the CASE logic accordingly.  
- **Audit Log Integrity:** This report assumes `LOG` captures all save events; if audit logging is modified, review this report.  
- **User Mapping:** `FAMCAREUSERID` and `LOG.USERID` should match; discrepancies may indicate legacy accounts or misconfigured users.  
- **Inactive Staff:** Workers who become inactive will drop from the report automatically due to `EMPSTATUS = 'Active'`.  

---

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-03-17**: Adds initial Markdown documentation.

<details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

- **2025-11-24**: Adds initial SQL query.

</details>
</details>
<!---CHANGELOG-END--->
