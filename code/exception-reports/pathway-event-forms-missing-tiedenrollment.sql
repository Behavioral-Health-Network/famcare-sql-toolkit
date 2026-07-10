/*
Report Name: Pathway Event Forms Missing TIEDENROLLMENT
Category: Exception Reports  

See docs/exception-reports/pathway-event-forms-missing-tiedenrollment.md for full documentation.
*/

SELECT *
FROM Q_ALL_PATHWAY_FORM_DOCSERNOS
WHERE TIEDENROLLMENT IS NULL