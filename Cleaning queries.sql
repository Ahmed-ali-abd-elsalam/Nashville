ALTER TABLE NASHVILLE_HOUSING
DROP COLUMN "Unnamed_0";

ALTER TABLE NASHVILLE_HOUSING
DROP COLUMN "Unnamed_01";

ALTER TABLE NASHVILLE_HOUSING
DROP COLUMN "Legal_Reference";

ALTER TABLE NASHVILLE_HOUSING
DROP COLUMN "image";

ALTER TABLE NASHVILLE_HOUSING
DROP COLUMN "Owner_Name";

ALTER TABLE NASHVILLE_HOUSING
DROP COLUMN "Address";

ALTER TABLE NASHVILLE_HOUSING
DROP COLUMN "City";

ALTER TABLE NASHVILLE_HOUSING
ALTER COLUMN "Sale_Date"
SET DATA TYPE DATE USING "Sale_Date"::DATE;

ALTER TABLE NASHVILLE_HOUSING
ALTER COLUMN "Year_Built"
SET DATA TYPE INTEGER USING "Year_Built"::INTEGER;

ALTER TABLE NASHVILLE_HOUSING
ALTER COLUMN "Sold_As_Vacant"
SET DATA TYPE BOOLEAN USING "Sold_As_Vacant"::BOOLEAN;

ALTER TABLE NASHVILLE_HOUSING
ALTER COLUMN "Multiple_Parcels_Involved_in_Sale"
SET DATA TYPE BOOLEAN USING "Multiple_Parcels_Involved_in_Sale"::BOOLEAN;

ALTER TABLE NASHVILLE_HOUSING
ALTER COLUMN "Bedrooms"
SET DATA TYPE INTEGER USING "Bedrooms"::INTEGER;

ALTER TABLE NASHVILLE_HOUSING
ALTER COLUMN "Full_Bath"
SET DATA TYPE INTEGER USING "Full_Bath"::INTEGER;

ALTER TABLE NASHVILLE_HOUSING
ALTER COLUMN "Half_Bath"
SET DATA TYPE INTEGER USING "Half_Bath"::INTEGER;

UPDATE NASHVILLE_HOUSING AS NS
SET
	"Land_Use" = 'VACANT RESIDENTIAL LAND'
WHERE
	NS."Land_Use" = 'VACANT RES LAND';