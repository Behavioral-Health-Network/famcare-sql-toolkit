/*
Script Name: update-epicc-community-referral-source-records.sql
Category: Maintenance Scripts 

See docs/maintenance-scripts/update-epicc-community-referral-source-records.md for full documentation.
*/

-- This query finds and replaces community referral records that had freeform text of EPICC, but will now use the EPICC Coach option

-- query itself with select statement
SELECT 
	CLIENTNUMBER, 
	DOCREVNO,
	VISITDT,
	VISITTM,
	USERID,
	COMMUNITY_REFERRAL_SOURCE,
	SPECIFY_OTHER_REFERRING_AGENCY
FROM PWEPICCREFERRAL
WHERE COMMUNITY_REFERRAL_SOURCE = '020'
	AND SPECIFY_OTHER_REFERRING_AGENCY LIKE ('%EPIC%')
	AND DOCREVNO = ' 0 '
	;

-- update query, with select statement removed. still need to determine all set variables
BEGIN TRY
    BEGIN TRANSACTION;

UPDATE PWEPICCREFERRAL
SET 
	COMMUNITY_REFERRAL_SOURCE = '041' -- '041' is the id for 'EPICC Coach'
	-- NOTE = 'Bulk Update of Data' --NOTE does not exist, but we need a note on this being a bulk update.
	-- ORIGINAL_SPECIFY_OTHER_REFERRING_AGENCY = SPECIFY_OTHER_REFERRING_AGENCY --We may want to save the original text value
FROM PWEPICCREFERRAL
WHERE COMMUNITY_REFERRAL_SOURCE = '020'
	AND SPECIFY_OTHER_REFERRING_AGENCY LIKE ('%EPIC%')
	AND DOCREVNO = ' 0 ';
	
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage,
        ERROR_LINE() AS ErrorLine;
END CATCH;
