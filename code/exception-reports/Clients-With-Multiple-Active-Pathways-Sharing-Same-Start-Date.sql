/*
Report Name: Clients With Multiple Active Pathways Sharing Same Start Date
Category: Exception Reports

See docs/exception-reports/Clients-With-Multiple-Active-Pathways-Sharing-Same-Start-Date.md for full documentation.
*/

SELECT *
FROM BEHAVHEALT_LIVE.DBO.Q_CLIENTS_WITH_MULTIPLE_PATHWAYS_SHARING_SAME_START_DATE
ORDER BY CLIENT_NUMBER,
	PROGRAM_CODE;