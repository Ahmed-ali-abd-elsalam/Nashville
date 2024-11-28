SELECT
	*
FROM
	NASHVILLE_HOUSING
LIMIT
	10;

SELECT
	NS."Sold_As_Vacant",
	COUNT(*)
FROM
	NASHVILLE_HOUSING AS NS
GROUP BY
	NS."Sold_As_Vacant";

SELECT DISTINCT
	NS."Sold_As_Vacant"
FROM
	NASHVILLE_HOUSING AS NS;

SELECT DISTINCT
	NS."Property_City"
FROM
	NASHVILLE_HOUSING AS NS;

SELECT
	NS."Address",
	NS."Property_City",
	NS."Property_Address"
FROM
	NASHVILLE_HOUSING AS NS
WHERE
	NS."Property_City" ISNULL;

SELECT
	NS."Land_Use",
	COUNT(*)
FROM
	NASHVILLE_HOUSING AS NS
WHERE
	NS."Property_City" ISNULL
GROUP BY
	NS."Land_Use";

SELECT
	*
FROM
	NASHVILLE_HOUSING AS NS
WHERE
	NS."Land_Use" = 'VACANT RESIDENTIAL LAND'
LIMIT
	10;

-- -------------------------------------------------------

SELECT
	*
FROM
	NASHVILLE_HOUSING
LIMIT
	10;
	
SELECT *
FROM
	NASHVILLE_HOUSING
where "Property_City" IS NULL OR "Property_Address" IS NULL;
