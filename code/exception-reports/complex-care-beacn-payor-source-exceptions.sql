/*
Report Name: Complex Care BEACN Payor Source Exceptions
Category: Exception Reports  

See docs/exception-reports/complex-care-beacn-payor-source-exceptions.md for full documentation.
*/

SELECT *
FROM Q_COMPLEX_CARE_BEACN_PAYOR_SUMMATION_EXCEPTIONS
ORDER BY
	CLIENT_NUMBER,
	EXPECTED_DATE;