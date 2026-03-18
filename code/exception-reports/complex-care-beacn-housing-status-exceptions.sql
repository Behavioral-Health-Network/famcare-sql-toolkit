/*
Report Name: Complex Care BEACN Housing Status Exceptions
Category: Exception Reports  

See docs/exception-reports/complex-care-beacn-housing-status-exceptions.md for full documentation.
*/

SELECT *
FROM Q_COMPLEX_CARE_BEACN_HOUSING_SUMMATION_EXCEPTIONS
ORDER BY
	CLIENT_NUMBER,
	EXPECTED_DATE;