-- create a backup of the data in a seperate table
SELECT * INTO NASHVILLE_HOUSING
FROM NASHVILLE_HOUSING_PERM;
-- remove whitespaces from the data
UPDATE NASHVILLE_HOUSING
SET "Parcel_ID" = TRIM("Parcel_ID"),
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
-- unifying the land_use to a single category
UPDATE NASHVILLE_HOUSING AS NS
SET "Land_Use" = 'VACANT RESIDENTIAL LAND'
WHERE NS."Land_Use" = 'VACANT RES LAND';
-- filling the missing addresses in the data from the extra column Address then removing it later
UPDATE NASHVILLE_HOUSING
SET "Property_Address" = "Address"
WHERE "Property_Address" IS NULL
	AND "Address" IS NOT NULL;
-- filling the missing cities in the data from the extra column City then removing it later
UPDATE NASHVILLE_HOUSING
SET "Property_City" = "City"
WHERE "Property_City" IS NULL
	AND "City" IS NOT NULL;
-- renaming the column to distinguish betweeen the rows with same parcel_id
ALTER TABLE NASHVILLE_HOUSING
	RENAME COLUMN "Unnamed_0" TO "Unique";
/*
 I discovered that some parcels appear multiple times, with address values missing in one occurrence but present in another.
 This query is designed to populate the missing address values for repeated parcel IDs.
 */
UPDATE NASHVILLE_HOUSING AS NS
SET "Property_Address" = FULL_TABLE."Property_Address"
FROM (
		SELECT A."Unique",
			B."Property_Address"
		FROM NASHVILLE_HOUSING AS A
			INNER JOIN NASHVILLE_HOUSING AS B ON A."Parcel_ID" = B."Parcel_ID"
			AND A."Unique" <> B."Unique"
		WHERE A."Property_Address" IS NULL
	) AS FULL_TABLE
WHERE NS."Unique" = FULL_TABLE."Unique";
-- fixing the data types for columns (Sale_Date,Year_Built,Sold_As_Vacant,Multiple_Parcels_Involved_in_Sale,Bedrooms,Full_Bath,Half_Bath)
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
-- dropping extra unneeded columns
ALTER TABLE NASHVILLE_HOUSING DROP COLUMN "Unnamed_01",
	DROP COLUMN "Legal_Reference",
	DROP COLUMN "image",
	DROP COLUMN "Owner_Name",
	DROP COLUMN "Suite_Condo",
	DROP COLUMN "State",
	DROP COLUMN "Address",
	DROP COLUMN "City";
/*  
 I observed that there are duplicate rows, which I defined as rows sharing the same parcel ID, property address, sale date, and sale price. 
 This query is intended to identify and remove those duplicate rows.
 */
WITH DUPLICATED AS (
	SELECT "Unique",
		"NO"
	FROM (
			SELECT ROW_NUMBER() OVER (PARTITION BY A."Parcel_ID") AS "NO",
				A."Unique",
				A."Parcel_ID",
				A."Property_Address",
				A."Sale_Date",
				A."Sale_Price"
			FROM NASHVILLE_HOUSING AS A
				INNER JOIN NASHVILLE_HOUSING AS B ON A."Parcel_ID" = B."Parcel_ID"
				AND A."Property_Address" = B."Property_Address"
				AND A."Sale_Date" = B."Sale_Date"
				AND A."Sale_Price" = B."Sale_Price"
				AND A."Unique" <> B."Unique"
		)
	WHERE "NO" > 1
	ORDER BY "Unique",
		"NO"
)
DELETE FROM NASHVILLE_HOUSING AS NS USING DUPLICATED
WHERE NS."Unique" = DUPLICATED."Unique";
SELECT SUM(
		CASE
			WHEN NSA."Unique" IS NOT NULL
			AND NSA."Parcel_ID" IS NOT NULL
			AND NSA."Land_Use" IS NOT NULL
			AND NSA."Property_Address" IS NOT NULL
			AND NSA."Property_City" IS NOT NULL
			AND NSA."Sale_Date" IS NOT NULL
			AND NSA."Sale_Price" IS NOT NULL
			AND NSA."Sold_As_Vacant" IS NOT NULL
			AND NSA."Multiple_Parcels_Involved_in_Sale" IS NOT NULL
			AND NSA."Acreage" IS NOT NULL
			AND NSA."Tax_District" IS NOT NULL
			AND NSA."Neighborhood" IS NOT NULL
			AND NSA."Land_Value" IS NOT NULL
			AND NSA."Building_Value" IS NOT NULL
			AND NSA."Total_Value" IS NOT NULL
			AND NSA."Finished_Area" IS NOT NULL
			AND NSA."Foundation_Type" IS NOT NULL
			AND NSA."Year_Built" IS NOT NULL
			AND NSA."Exterior_Wall" IS NOT NULL
			AND NSA."Grade" IS NOT NULL
			AND NSA."Bedrooms" IS NOT NULL
			AND NSA."Full_Bath" IS NOT NULL
			AND NSA."Half_Bath" IS NOT NULL THEN 1
			ELSE 0
		END
	) AS "WITH DATA",
	SUM(1) AS "ALL VALUES",
	ROUND(
		CAST(
			SUM(
				CASE
					WHEN NSA."Unique" IS NOT NULL
					AND NSA."Parcel_ID" IS NOT NULL
					AND NSA."Land_Use" IS NOT NULL
					AND NSA."Property_Address" IS NOT NULL
					AND NSA."Property_City" IS NOT NULL
					AND NSA."Sale_Date" IS NOT NULL
					AND NSA."Sale_Price" IS NOT NULL
					AND NSA."Sold_As_Vacant" IS NOT NULL
					AND NSA."Multiple_Parcels_Involved_in_Sale" IS NOT NULL
					AND NSA."Acreage" IS NOT NULL
					AND NSA."Tax_District" IS NOT NULL
					AND NSA."Neighborhood" IS NOT NULL
					AND NSA."Land_Value" IS NOT NULL
					AND NSA."Building_Value" IS NOT NULL
					AND NSA."Total_Value" IS NOT NULL
					AND NSA."Finished_Area" IS NOT NULL
					AND NSA."Foundation_Type" IS NOT NULL
					AND NSA."Year_Built" IS NOT NULL
					AND NSA."Exterior_Wall" IS NOT NULL
					AND NSA."Grade" IS NOT NULL
					AND NSA."Bedrooms" IS NOT NULL
					AND NSA."Full_Bath" IS NOT NULL
					AND NSA."Half_Bath" IS NOT NULL THEN 1
					ELSE 0
				END
			) AS NUMERIC
		) / SUM(1),
		2
	) * 100 AS "RATIO"
FROM NASHVILLE_HOUSING AS NSA;
SELECT * INTO NASHFULL
FROM NASHVILLE_HOUSING AS NSA
WHERE NSA."Unique" IS NOT NULL
	AND NSA."Parcel_ID" IS NOT NULL
	AND NSA."Land_Use" IS NOT NULL
	AND NSA."Property_Address" IS NOT NULL
	AND NSA."Property_City" IS NOT NULL
	AND NSA."Sale_Date" IS NOT NULL
	AND NSA."Sale_Price" IS NOT NULL
	AND NSA."Sold_As_Vacant" IS NOT NULL
	AND NSA."Multiple_Parcels_Involved_in_Sale" IS NOT NULL
	AND NSA."Acreage" IS NOT NULL
	AND NSA."Tax_District" IS NOT NULL
	AND NSA."Neighborhood" IS NOT NULL
	AND NSA."Land_Value" IS NOT NULL
	AND NSA."Building_Value" IS NOT NULL
	AND NSA."Total_Value" IS NOT NULL
	AND NSA."Finished_Area" IS NOT NULL
	AND NSA."Foundation_Type" IS NOT NULL
	AND NSA."Year_Built" IS NOT NULL
	AND NSA."Exterior_Wall" IS NOT NULL
	AND NSA."Grade" IS NOT NULL
	AND NSA."Bedrooms" IS NOT NULL
	AND NSA."Full_Bath" IS NOT NULL
	AND NSA."Half_Bath" IS NOT NULL;