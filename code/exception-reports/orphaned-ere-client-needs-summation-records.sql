/*
Report Name: Orphaned ERE Client Needs Summation Records
Category: Exception Reports  

See docs/exception-reports/orphaned-ere-client-needs-summation-records.md for full documentation.
*/

SELECT ERENEEDS.CLIENT_NUMBER,
	ERENEEDS.PATHWAY_DATE,
	ERENEEDS.DOCSERNO AS [NEEDS_DOCSERNO],
	ERENEEDS.FORM_TYPE,
	ERENEEDS.PARENTDOCSERNO AS [PARENT_DOCSERNO]
FROM Q_ERE_CLIENT_NEEDS AS [ERENEEDS]
WHERE ERENEEDS.FORM_TYPE IS NULL