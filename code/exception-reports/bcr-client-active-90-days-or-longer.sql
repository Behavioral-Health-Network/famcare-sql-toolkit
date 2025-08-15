/*
Report Name: BCR Client Active 90 Days or Longer  
Category: Exception Reports  

See docs/exception-reports/bcr-client-active-90-days-or-longer.md for full documentation.
*/

SELECT *
FROM Q_BCR_CLIENT_ACTIVE_90_DAYS_OR_LONGER
ORDER BY CLIENT_LAST,
	CLIENT_FIRST,
	ENROLLMENT_STARTING_DATE;
