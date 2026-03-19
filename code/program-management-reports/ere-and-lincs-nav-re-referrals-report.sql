/*
Report Name: ERE and LINCS NAV Re-Referrals Report
Category: Program Management Reports  

See docs/program-management-reports/ere-and-lincs-nav-re-referrals-report.md for full documentation.
*/

SELECT *
FROM Q_ERE_LINCS_NAV_REREFERRAL AS [REREFERRAL]
WHERE 
	(
		(
		REREFERRAL.LAST_ERE_OR_NAV_REFERRAL_DATE >= '^^START REFERRAL DATE|DATEPICKER^^' 
			OR '^^START REFERRAL DATE^^' = ''
			)
			AND (
				REREFERRAL.LAST_ERE_OR_NAV_REFERRAL_DATE <= '^^END REFERRAL DATE|DATEPICKER^^' 
					OR '^^END REFERRAL DATE^^' = ''
			)
	)
