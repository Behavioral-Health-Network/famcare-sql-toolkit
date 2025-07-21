# FAMCare-SQL-Toolkit

A curated collection of SQL assets designed to support reporting, data integrity, and system maintenance within the FAMCare ecosystem. This repository centralizes queries authored and maintained by the Data Team, including exception reports, audit extracts, view definitions, and logic scaffolding for Quick Reports and downstream analytics.

---

## Purpose

This toolkit serves to:

- Centralize reportable SQL logic for staff collaboration and documentation
- Maintain reusable components across program areas and reporting frameworks
- Enable version control for Quick Reports and extract queries built in FAMCare or SSMS
- Support integration with wiki documentation, changelogs, and Git-linked workflows

## Folder Structure

- [Exception Reports]
- [Program Management]
- [Extract Queries]
- [R Child Doc Extracts]
- [Audit Reports]
- [View Definitions]
- [Maintenance Scripts]
- [Maintenance Queries]
- [Infrastructure Logic]


Each folder contains:

- Well-named `.sql` files with descriptive headers and embedded comments
- Optional markdown pages summarizing logic and usage
- Logical grouping by report category or system function

## Usage Guidelines

- Queries may be written in SSMS or in VS Code
- Queries may be tested in SSMS or in FAMCare's Advanced SQL Report Writer
- All files should begin with:
  - Query title and purpose
  - Associated report name or use case (if applicable)

- Naming conventions should reflect FAMCare Quick Report folder taxonomy and match report names where relevant
- When saving Quick Reports, ensure alignment with folder structure and report naming rules documented in the Azure DevOps wiki

## Roles and Ownership

- Primary Maintainer: Bradley  
- Contributors: Data Analysts, Data Coordinator  
- Collaborators may submit changes via pull request or commit through approved channels

## Related Documentation

This repository complements formal documentation maintained in Azure DevOps:

- Overview of Quick Reports and role-based security
- Individual report pages with changelogs, SQL logic, and usage notes
- Report request tracker and roadmap
- Contributor guidelines (coming soon)

## Future Enhancements

- Automated changelog generation
- Structured linking between SQL files and wiki pages
- Version-tracking for published and draft Quick Reports
- Integration with Power BI metadata if vendor support becomes available
