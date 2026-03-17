/*
Report Name: ERE FAMCare Updates to Enter Into CareManager
Category: Compliance Reports  

See docs/compliance-reports/ere-famcare-updates-to-enter-into-caremanager.md for full documentation.
*/

SELECT *
FROM Q_ERE_FAMCARE_UPDATES_TO_ENTER_INTO_CAREMANAGER
WHERE 
	(
		(
			ERE_REF_VISITDT >= '^^BEGINNING START DATE|DATEPICKER^^'
			OR '^^BEGINNING START DATE^^' = ''
		)
		AND
		(
			ERE_REF_VISITDT <= '^^ENDING START DATE|DATEPICKER^^'
			OR '^^ENDING START DATE^^' = ''
		)
	)
	OR
	(
		(
			ERE_IHNA_VISITDT >= '^^BEGINNING START DATE|DATEPICKER^^'
			OR '^^BEGINNING START DATE^^' = ''
		)
		AND
		(
			ERE_IHNA_VISITDT <= '^^ENDING START DATE|DATEPICKER^^'
			OR '^^ENDING START DATE^^' = ''
		)
	)
	OR
	(
		(
			ERE_THREE_MO_VISITDT >= '^^BEGINNING START DATE|DATEPICKER^^'
			OR '^^BEGINNING START DATE^^' = ''
		)
		AND
		(
			ERE_THREE_MO_VISITDT <= '^^ENDING START DATE|DATEPICKER^^'
			OR '^^ENDING START DATE^^' = ''
		)
	)
	OR
	(
		(
			ERE_SIX_MO_VISITDT >= '^^BEGINNING START DATE|DATEPICKER^^'
			OR '^^BEGINNING START DATE^^' = ''
		)
		AND
		(
			ERE_SIX_MO_VISITDT <= '^^ENDING START DATE|DATEPICKER^^'
			OR '^^ENDING START DATE^^' = ''
		)
	);