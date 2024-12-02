SELECT *
FROM NASHFULL
LIMIT 10;
-- number of units sold in each price range  
SELECT CEIL("Sale_Price" / 200000 + 1) * 200000 AS "Price_Range",
	"Sold_As_Vacant",
	COUNT(CEIL("Sale_Price" / 200000)) AS "No. OF Units"
FROM NASHFULL
GROUP BY "Sold_As_Vacant",
	CEIL("Sale_Price" / 200000 + 1)
ORDER BY CEIL("Sale_Price" / 200000 + 1);
-- number of units vacant or full
SELECT "Sold_As_Vacant",
	COUNT("Sold_As_Vacant")
FROM NASHFULL
GROUP BY "Sold_As_Vacant";
-- NUMBER OF UNITS SOLD WITH MULTIPLE PARCELS 
SELECT "Multiple_Parcels_Involved_in_Sale",
	"Sold_As_Vacant",
	COUNT(*)
FROM NASHFULL
GROUP BY "Multiple_Parcels_Involved_in_Sale",
	"Sold_As_Vacant"
ORDER BY "Multiple_Parcels_Involved_in_Sale",
	"Sold_As_Vacant";
-- NUMBER OF UNITS SOLD AS VACANT DIVIDED BY ACREAGE
SELECT "Sold_As_Vacant",
	round(cast (CEIL("Acreage" /.1) * 0.1 AS Numeric), 1) AS "Acreage",
	COUNT(CEIL("Acreage" /.1)) AS "No. OF Units"
FROM NASHFULL
WHERE "Sold_As_Vacant"
GROUP BY "Sold_As_Vacant",
	CEIL("Acreage" / 0.1)
ORDER BY CEIL("Acreage" / 0.1);
-- NUMBER OF UNITS SOLD AS VACANT DIVIDED BY Grade
SELECT "Sold_As_Vacant",
	"Grade",
	COUNT("Grade") AS "No. OF Units"
FROM NASHFULL
WHERE "Sold_As_Vacant"
GROUP BY "Sold_As_Vacant",
	"Grade"
ORDER BY "Grade";
-- NUMBER OF UNITS SOLD avg price PER MONTH
SELECT EXTRACT(
		YEAR
		FROM "Sale_Date"
	) AS "YEAR",
	EXTRACT(
		MONTH
		FROM "Sale_Date"
	) AS "MONTH",
	count("Sale_Date"),
	ROUND(AVG("Sale_Price"), 2) "PRICE"
FROM NASHFULL
GROUP BY EXTRACT(
		YEAR
		FROM "Sale_Date"
	),
	EXTRACT(
		MONTH
		FROM "Sale_Date"
	)
ORDER BY EXTRACT(
		YEAR
		FROM "Sale_Date"
	),
	EXTRACT(
		MONTH
		FROM "Sale_Date"
	);
-- NUMBER OF vacant UNITS SOLD PER MONTH
SELECT EXTRACT(
		YEAR
		FROM "Sale_Date"
	) AS "YEAR",
	"Sold_As_Vacant",
	count("Sale_Date") AS "No. Of Units",
	ROUND(AVG("Sale_Price"), 2) "PRICE"
FROM NASHFULL
GROUP BY EXTRACT(
		YEAR
		FROM "Sale_Date"
	),
	"Sold_As_Vacant"
ORDER BY EXTRACT(
		YEAR
		FROM "Sale_Date"
	),
	"Sold_As_Vacant";
-- average price per city
SELECT "Property_City",
	round(avg("Sale_Price"), 2) AS "Average_Price"
FROM NASHFULL
GROUP BY "Property_City"
ORDER BY "Average_Price" desc,
	"Property_City";
-- number of vacant units and average sale price categorized by land use   
SELECT "Land_Use",
	COUNT(*) AS "Units",
	ROUND(AVG("Sale_Price"), 2) AS "Average_Price"
FROM nashfull
WHERE "Sold_As_Vacant" = TRUE
GROUP by "Land_Use"
ORDER by ROUND(AVG("Sale_Price"), 2)