SELECT
	*
FROM
	NASHFULL
LIMIT
	10;

-- number of units sold in each price range  
SELECT
	"Sold_As_Vacant",
	CEIL("Sale_Price" / 200000+1) * 200000 AS "Price_Range",
	COUNT(CEIL("Sale_Price" / 200000+1)) AS "No. OF Units"
FROM
	NASHFULL
GROUP BY
	"Sold_As_Vacant",
	CEIL("Sale_Price" / 200000+1)
ORDER BY
	CEIL("Sale_Price" / 200000+1 );

-- NUMBER OF UNITS SOLD WITH MULTIPLE PARCELS 
SELECT "Multiple_Parcels_Involved_in_Sale","Sold_As_Vacant" , COUNT(*)
FROM NASHFULL
GROUP BY "Multiple_Parcels_Involved_in_Sale","Sold_As_Vacant"
ORDER BY "Multiple_Parcels_Involved_in_Sale","Sold_As_Vacant";

-- NUMBER OF UNITS SOLD AS VACANT DIVIDED BY ACREAGE
SELECT
	"Sold_As_Vacant",
	CEIL("Acreage" / .1) * 0.1 AS "Acreage",
	COUNT(CEIL("Acreage" / .1)) AS "No. OF Units"
FROM
	NASHFULL
WHERE "Sold_As_Vacant"
GROUP BY
	"Sold_As_Vacant",
	CEIL("Acreage" / 0.1)
ORDER BY
	CEIL("Acreage" / 0.1);

-- NUMBER OF UNITS SOLD AS VACANT DIVIDED BY ACREAGE
SELECT
	"Sold_As_Vacant",
	"Grade",
	COUNT("Grade") AS "No. OF Units"
FROM
	NASHFULL
WHERE "Sold_As_Vacant"
GROUP BY
	"Sold_As_Vacant",
	"Grade"
ORDER BY
	"Grade"