/*
Report Name: Clients With Multiple Active Pathways
Category: Exception Reports

See docs/exception-reports/clients-with-multiple-active-pathways.md for full documentation.
*/

SELECT *
FROM BEHAVHEALT_LIVE.DBO.Q_CLIENTS_WITH_MULTIPLE_ACTIVE_PATHWAYS
ORDER BY [COUNT_PATHWAY] DESC, 
	CLIENT_NUMBER;