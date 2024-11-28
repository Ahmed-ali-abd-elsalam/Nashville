SELECT
	* INTO NASHVILLE_HOUSING
FROM
	NASHVILLE_HOUSING_PERM;

UPDATE NASHVILLE_HOUSING
SET
	"Parcel_ID" = TRIM("Parcel_ID"),
	"Land_Use" = TRIM("Land_Use"),
	"Property_Address" = TRIM("Property_Address"),
	"Property_City" = TRIM("Property_City"),
	"Sale_Date" = TRIM("Sale_Date"),
	"Sold_As_Vacant" = TRIM("Sold_As_Vacant"),
	"Multiple_Parcels_Involved_in_Sale" = TRIM("Multiple_Parcels_Involved_in_Sale"),
	"Tax_District" = TRIM("Tax_District"),
	"Foundation_Type" = TRIM("Foundation_Type"),
	"Exterior_Wall" = TRIM("Exterior_Wall"),
	"Grade" = TRIM("Grade");

UPDATE NASHVILLE_HOUSING AS NS
SET
	"Land_Use" = 'VACANT RESIDENTIAL LAND'
WHERE
	NS."Land_Use" = 'VACANT RES LAND';

UPDATE NASHVILLE_HOUSING
SET
	"Property_Address" = "Address"
WHERE
	"Property_Address" IS NULL
	AND "Address" IS NOT NULL;

UPDATE NASHVILLE_HOUSING
SET
	"Property_City" = "City"
WHERE
	"Property_City" IS NULL
	AND "City" IS NOT NULL;

ALTER TABLE NASHVILLE_HOUSING
RENAME COLUMN "Unnamed_0" TO "Unique";

UPDATE NASHVILLE_HOUSING AS NS
SET
	"Property_Address" = FULL_TABLE."Property_Address"
FROM
	(
		SELECT
			A."Unique",
			B."Property_Address"
		FROM
			NASHVILLE_HOUSING AS A
			INNER JOIN NASHVILLE_HOUSING AS B ON A."Parcel_ID" = B."Parcel_ID"
			AND A."Unique" <> B."Unique"
		WHERE
			A."Property_Address" IS NULL
	) AS FULL_TABLE
WHERE
	NS."Unique" = FULL_TABLE."Unique";

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

ALTER TABLE NASHVILLE_HOUSING
DROP COLUMNS "Unnamed_01",
DROP COLUMN "Legal_Reference",
DROP COLUMN "image",
DROP COLUMN "Owner_Name",
DROP COLUMN "Suite_Condo",
DROP COLUMN "State",
DROP COLUMN "Address",
DROP COLUMN "City";


-- DELETEING DUPLICATE VALUES
-- DUPLICATE VALUES ARE ROWS WITH THE SAME PARCEL_ID ,Property_Address ,Sale_Date, Sale_Price
WITH DUPLICATED AS (
SELECT
	"Unique","NO"
FROM
	(
		SELECT
			ROW_NUMBER() OVER (
				PARTITION BY
					A."Parcel_ID"
			) AS "NO",
			A."Unique",
			A."Parcel_ID",
			A."Property_Address",
			A."Sale_Date",
			A."Sale_Price"
		FROM
			NASHVILLE_HOUSING AS A
			INNER JOIN NASHVILLE_HOUSING AS B ON A."Parcel_ID" = B."Parcel_ID"
			AND A."Property_Address" = B."Property_Address"
			AND A."Sale_Date" = B."Sale_Date"
			AND A."Sale_Price" = B."Sale_Price"
			AND A."Unique" <> B."Unique"
	)
WHERE
	"NO" > 1
ORDER BY "Unique" , "NO"
	)
DELETE FROM NASHVILLE_HOUSING AS NS USING DUPLICATED  WHERE NS."Unique" = DUPLICATED."Unique"
