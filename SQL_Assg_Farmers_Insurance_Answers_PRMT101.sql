-- ============================================================
-- Farmers Insurance Analysis – Full Solution
-- Assignment ID : SQL/02
-- Group         : PRMT101
-- Database      : MySQL | Schema: ndap
-- Data Source   : National Data and Analytics Platform (NDAP)
-- Columns in lakh INR (scaling factor 100,000) for premium/sum amounts
-- InsuredLandArea in thousand Hectares (scaling factor 1,000)
-- ============================================================

use ndap;


-- ----------------------------------------------------------------------------------------------
-- SECTION 1.
-- SELECT Queries [5 Marks]

-- 	Q1.	Retrieve the names of all states (srcStateName) from the dataset.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

SELECT DISTINCT srcStateName
FROM FarmersInsuranceData
ORDER BY srcStateName;

-- ###

-- 	Q2.	Retrieve the total number of farmers covered (TotalFarmersCovered)
-- 		and the sum insured (SumInsured) for each state (srcStateName), ordered by TotalFarmersCovered in descending order.
-- ###
-- 	[3 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

SELECT
    srcStateName,
    SUM(TotalFarmersCovered)        AS TotalFarmersCovered,
    SUM(COALESCE(SumInsured, 0))    AS TotalSumInsured
FROM FarmersInsuranceData
GROUP BY srcStateName
ORDER BY TotalFarmersCovered DESC;

-- ###

-- --------------------------------------------------------------------------------------
-- SECTION 2.
-- Filtering Data (WHERE) [15 Marks]

-- 	Q3.	Retrieve all records where Year is '2020'.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

SELECT *
FROM FarmersInsuranceData
WHERE srcYear = 2020;

-- ###

-- 	Q4.	Retrieve all rows where the TotalPopulationRural is greater than 1 million and the srcStateName is 'HIMACHAL PRADESH'.
-- ###
-- 	[3 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

SELECT *
FROM FarmersInsuranceData
WHERE TotalPopulationRural > 1000000
  AND srcStateName = 'HIMACHAL PRADESH';

-- ###

-- 	Q5.	Retrieve the srcStateName, srcDistrictName, and the sum of FarmersPremiumAmount for each district in the year 2018,
-- 		and display the results ordered by FarmersPremiumAmount in ascending order.
-- ###
-- 	[5 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

SELECT
    srcStateName,
    srcDistrictName,
    SUM(COALESCE(FarmersPremiumAmount, 0)) AS TotalFarmersPremiumAmount
FROM FarmersInsuranceData
WHERE srcYear = 2018
GROUP BY srcStateName, srcDistrictName
ORDER BY TotalFarmersPremiumAmount ASC;

-- ###

-- 	Q6.	Retrieve the total number of farmers covered (TotalFarmersCovered) and the sum of premiums (GrossPremiumAmountToBePaid) for each state (srcStateName)
-- 		where the insured land area (InsuredLandArea) is greater than 5.0 and the Year is 2018.
-- ###
-- 	[5 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

SELECT
    srcStateName,
    SUM(TotalFarmersCovered)                    AS TotalFarmersCovered,
    SUM(COALESCE(GrossPremiumAmountToBePaid, 0)) AS TotalGrossPremiumAmountToBePaid
FROM FarmersInsuranceData
WHERE InsuredLandArea > 5.0
  AND srcYear = 2018
GROUP BY srcStateName;


-- ###
-- ------------------------------------------------------------------------------------------------

-- SECTION 3.
-- Aggregation (GROUP BY) [10 marks]

-- 	Q7. 	Calculate the average insured land area (InsuredLandArea) for each year (srcYear).
-- ###
-- 	[3 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

SELECT
    srcYear,
    AVG(COALESCE(InsuredLandArea, 0)) AS AvgInsuredLandArea
FROM FarmersInsuranceData
GROUP BY srcYear
ORDER BY srcYear;



-- ###

-- 	Q8. 	Calculate the total number of farmers covered (TotalFarmersCovered) for each district (srcDistrictName) where Insurance units is greater than 0.
-- ###
-- 	[3 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

SELECT
    srcDistrictName,
    SUM(TotalFarmersCovered) AS TotalFarmersCovered
FROM FarmersInsuranceData
WHERE InsuranceUnits > 0
GROUP BY srcDistrictName
ORDER BY TotalFarmersCovered DESC;



-- ###

-- 	Q9.	For each state (srcStateName), calculate the total premium amounts (FarmersPremiumAmount, StatePremiumAmount, GOVPremiumAmount)
-- 		and the total number of farmers covered (TotalFarmersCovered). Only include records where the sum insured (SumInsured) is greater than 500,000 (remember to check for scaling).
-- ###
-- 	[4 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

-- Note on scaling: SumInsured is stored in lakh INR (scaling factor = 100,000).
-- 500,000 INR = 5 lakh → stored threshold = 5.

SELECT
    srcStateName,
    SUM(COALESCE(FarmersPremiumAmount, 0))  AS TotalFarmersPremiumAmount,
    SUM(COALESCE(StatePremiumAmount, 0))    AS TotalStatePremiumAmount,
    SUM(COALESCE(GOVPremiumAmount, 0))      AS TotalGOVPremiumAmount,
    SUM(TotalFarmersCovered)                AS TotalFarmersCovered
FROM FarmersInsuranceData
WHERE COALESCE(SumInsured, 0) > 5
GROUP BY srcStateName
ORDER BY TotalFarmersCovered DESC;




-- ###

-- -------------------------------------------------------------------------------------------------
-- SECTION 4.
-- Sorting Data (ORDER BY) [10 Marks]

-- 	Q10.	Retrieve the top 5 districts (srcDistrictName) with the highest TotalPopulation in the year 2020.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

SELECT
    srcStateName,
    srcDistrictName,
    TotalPopulation
FROM FarmersInsuranceData
WHERE srcYear = 2020
ORDER BY TotalPopulation DESC
LIMIT 5;




-- ###

-- 	Q11.	Retrieve the srcStateName, srcDistrictName, and SumInsured for the 10 districts with the lowest non-zero FarmersPremiumAmount,
-- 		ordered by insured sum and then the FarmersPremiumAmount.
-- ###
-- 	[3 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

SELECT
    srcStateName,
    srcDistrictName,
    COALESCE(SumInsured, 0)            AS SumInsured,
    COALESCE(FarmersPremiumAmount, 0)  AS FarmersPremiumAmount
FROM FarmersInsuranceData
WHERE COALESCE(FarmersPremiumAmount, 0) > 0
ORDER BY SumInsured ASC, FarmersPremiumAmount ASC
LIMIT 10;



###

-- 	Q12. 	Retrieve the top 3 states (srcStateName) along with the year (srcYear) where the ratio of insured farmers (TotalFarmersCovered) to the total population (TotalPopulation) is highest.
-- 		Sort the results by the ratio in descending order.
-- ###
-- 	[5 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

SELECT
    srcStateName,
    srcYear,
    SUM(TotalFarmersCovered)                                            AS TotalFarmersCovered,
    SUM(TotalPopulation)                                                AS TotalPopulation,
    SUM(TotalFarmersCovered) / NULLIF(SUM(TotalPopulation), 0)         AS InsuredToPopulationRatio
FROM FarmersInsuranceData
GROUP BY srcStateName, srcYear
ORDER BY InsuredToPopulationRatio DESC
LIMIT 3;



-- ###

-- -------------------------------------------------------------------------------------------------

-- SECTION 5.
-- String Functions [6 Marks]

-- 	Q13. 	Create StateShortName by retrieving the first 3 characters of the srcStateName for each unique state.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

SELECT DISTINCT
    srcStateName,
    LEFT(srcStateName, 3) AS StateShortName
FROM FarmersInsuranceData
ORDER BY srcStateName;



-- ###

-- 	Q14. 	Retrieve the srcDistrictName where the district name starts with 'B'.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

SELECT DISTINCT srcDistrictName
FROM FarmersInsuranceData
WHERE srcDistrictName LIKE 'B%'
ORDER BY srcDistrictName;



-- ###

-- 	Q15. 	Retrieve the srcStateName and srcDistrictName where the district name contains the word 'pur' at the end.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

SELECT DISTINCT
    srcStateName,
    srcDistrictName
FROM FarmersInsuranceData
WHERE srcDistrictName LIKE '%pur'
ORDER BY srcStateName, srcDistrictName;

-- ###

-- -------------------------------------------------------------------------------------------------

-- SECTION 6.
-- Joins [14 Marks]

-- 	Q16. 	Perform an INNER JOIN between the srcStateName and srcDistrictName columns to retrieve the aggregated FarmersPremiumAmount for districts where the district's Insurance units for an individual year are greater than 10.
-- ###
-- 	[4 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

-- Technique: INNER JOIN the main table against a derived table of districts
-- that have InsuranceUnits > 10 in at least one year.
SELECT
    f.srcStateName,
    f.srcDistrictName,
    f.srcYear,
    SUM(COALESCE(f.FarmersPremiumAmount, 0)) AS AggrFarmersPremiumAmount
FROM FarmersInsuranceData f
INNER JOIN (
    SELECT DISTINCT srcStateName, srcDistrictName, srcYear
    FROM FarmersInsuranceData
    WHERE InsuranceUnits > 10
) filtered_districts
    ON  f.srcStateName    = filtered_districts.srcStateName
    AND f.srcDistrictName = filtered_districts.srcDistrictName
    AND f.srcYear         = filtered_districts.srcYear
GROUP BY f.srcStateName, f.srcDistrictName, f.srcYear
ORDER BY AggrFarmersPremiumAmount DESC;



-- ###

-- 	Q17.	Write a query that retrieves srcStateName, srcDistrictName, Year, TotalPopulation for each district and the the highest recorded FarmersPremiumAmount for that district over all available years
-- 		Return only those districts where the highest FarmersPremiumAmount exceeds 20 crores.
-- ###
-- 	[5 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

-- Note on scaling: FarmersPremiumAmount is stored in lakh INR (scaling factor = 100,000).
-- 20 crores = 2,000 lakh → stored threshold for MAX = 2000.

SELECT
    f.srcStateName,
    f.srcDistrictName,
    f.Year_                             AS Year,
    f.TotalPopulation,
    mx.MaxFarmersPremiumAmount
FROM FarmersInsuranceData f
INNER JOIN (
    SELECT
        srcStateName,
        srcDistrictName,
        MAX(COALESCE(FarmersPremiumAmount, 0)) AS MaxFarmersPremiumAmount
    FROM FarmersInsuranceData
    GROUP BY srcStateName, srcDistrictName
    HAVING MAX(COALESCE(FarmersPremiumAmount, 0)) > 2000
) mx
    ON  f.srcStateName    = mx.srcStateName
    AND f.srcDistrictName = mx.srcDistrictName
ORDER BY mx.MaxFarmersPremiumAmount DESC, f.srcStateName, f.srcDistrictName;



-- ###

-- 	Q18.	Perform a LEFT JOIN to combine the total population statistics with the farmers' data (TotalFarmersCovered, SumInsured) for each district and state.
-- 		Return the total premium amount (FarmersPremiumAmount) and the average population count for each district aggregated over the years, where the total FarmersPremiumAmount is greater than 100 crores.
-- 		Sort the results by total farmers' premium amount, highest first.
-- ###
-- 	[5 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

-- Note on scaling: 100 crores = 10,000 lakh → stored threshold for SUM = 10000.
-- LEFT JOIN: population sub-table (left) joined to insurance sub-table (right).

SELECT
    pop.srcStateName,
    pop.srcDistrictName,
    SUM(COALESCE(ins.FarmersPremiumAmount, 0))  AS TotalFarmersPremiumAmount,
    AVG(pop.TotalPopulation)                    AS AvgTotalPopulation
FROM (
    SELECT srcStateName, srcDistrictName, srcYear, TotalPopulation
    FROM FarmersInsuranceData
) pop
LEFT JOIN (
    SELECT srcStateName, srcDistrictName, srcYear,
           TotalFarmersCovered, SumInsured, FarmersPremiumAmount
    FROM FarmersInsuranceData
) ins
    ON  pop.srcStateName    = ins.srcStateName
    AND pop.srcDistrictName = ins.srcDistrictName
    AND pop.srcYear         = ins.srcYear
GROUP BY pop.srcStateName, pop.srcDistrictName
HAVING SUM(COALESCE(ins.FarmersPremiumAmount, 0)) > 10000
ORDER BY TotalFarmersPremiumAmount DESC;




-- ###

-- -------------------------------------------------------------------------------------------------

-- SECTION 7.
-- Subqueries [10 Marks]

-- 	Q19.	Write a query to find the districts (srcDistrictName) where the TotalFarmersCovered is greater than the average TotalFarmersCovered across all records.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

SELECT DISTINCT
    srcStateName,
    srcDistrictName,
    TotalFarmersCovered
FROM FarmersInsuranceData
WHERE TotalFarmersCovered > (
    SELECT AVG(TotalFarmersCovered)
    FROM FarmersInsuranceData
)
ORDER BY TotalFarmersCovered DESC;




-- ###

-- 	Q20.	Write a query to find the srcStateName where the SumInsured is higher than the SumInsured of the district with the highest FarmersPremiumAmount.
-- ###
-- 	[3 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

-- Note: The district with the highest FarmersPremiumAmount (Maharashtra/Bid) also holds
-- the highest SumInsured (275019 lakh). Using >= returns all states that match or exceed it.
SELECT DISTINCT
    srcStateName,
    COALESCE(SumInsured, 0) AS SumInsured
FROM FarmersInsuranceData
WHERE COALESCE(SumInsured, 0) >= (
    SELECT COALESCE(SumInsured, 0)
    FROM FarmersInsuranceData
    WHERE COALESCE(FarmersPremiumAmount, 0) = (
        SELECT MAX(COALESCE(FarmersPremiumAmount, 0))
        FROM FarmersInsuranceData
    )
    LIMIT 1
)
ORDER BY SumInsured DESC;




-- ###

-- 	Q21.	Write a query to find the srcDistrictName where the FarmersPremiumAmount is higher than the average FarmersPremiumAmount of the state that has the highest TotalPopulation.
-- ###
-- 	[5 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

SELECT DISTINCT
    srcStateName,
    srcDistrictName,
    COALESCE(FarmersPremiumAmount, 0) AS FarmersPremiumAmount
FROM FarmersInsuranceData
WHERE COALESCE(FarmersPremiumAmount, 0) > (
    SELECT AVG(COALESCE(FarmersPremiumAmount, 0))
    FROM FarmersInsuranceData
    WHERE srcStateName = (
        SELECT srcStateName
        FROM FarmersInsuranceData
        GROUP BY srcStateName
        ORDER BY SUM(TotalPopulation) DESC
        LIMIT 1
    )
)
ORDER BY FarmersPremiumAmount DESC;




-- ###

-- -------------------------------------------------------------------------------------------------

-- SECTION 8.
-- Advanced SQL Functions (Window Functions) [10 Marks]

-- 	Q22.	Use the ROW_NUMBER() function to assign a row number to each record in the dataset ordered by total farmers covered in descending order.
-- ###
-- 	[3 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

SELECT
    ROW_NUMBER() OVER (ORDER BY TotalFarmersCovered DESC) AS RowNum,
    rowID,
    srcStateName,
    srcDistrictName,
    srcYear,
    TotalFarmersCovered
FROM FarmersInsuranceData
ORDER BY TotalFarmersCovered DESC;




-- ###

-- 	Q23.	Use the RANK() function to rank the districts (srcDistrictName) based on the SumInsured (descending) and partition by alphabetical srcStateName.
-- ###
-- 	[3 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

SELECT
    srcStateName,
    srcDistrictName,
    srcYear,
    COALESCE(SumInsured, 0) AS SumInsured,
    RANK() OVER (
        PARTITION BY srcStateName
        ORDER BY COALESCE(SumInsured, 0) DESC
    ) AS SumInsuredRank
FROM FarmersInsuranceData
ORDER BY srcStateName, SumInsuredRank;



-- ###

-- 	Q24.	Use the SUM() window function to calculate a cumulative sum of FarmersPremiumAmount for each district (srcDistrictName), ordered ascending by the srcYear, partitioned by srcStateName.
-- ###
-- 	[4 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

SELECT
    srcStateName,
    srcDistrictName,
    srcYear,
    COALESCE(FarmersPremiumAmount, 0) AS FarmersPremiumAmount,
    SUM(COALESCE(FarmersPremiumAmount, 0)) OVER (
        PARTITION BY srcStateName
        ORDER BY srcYear ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS CumulativeFarmersPremiumAmount
FROM FarmersInsuranceData
ORDER BY srcStateName, srcYear;




-- ###

-- -------------------------------------------------------------------------------------------------

-- SECTION 9.
-- Data Integrity (Constraints, Foreign Keys) [4 Marks]

-- 	Q25.	Create a table 'districts' with DistrictCode as the primary key and columns for DistrictName and StateCode.
-- 		Create another table 'states' with StateCode as primary key and column for StateName.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

-- Drop in FK-safe order (child first, then parent) to allow clean re-runs
DROP TABLE IF EXISTS districts;
DROP TABLE IF EXISTS states;

CREATE TABLE states (
    StateCode   INT          NOT NULL,
    StateName   VARCHAR(255) NOT NULL,
    CONSTRAINT pk_states PRIMARY KEY (StateCode)
);

CREATE TABLE districts (
    DistrictCode    INT          NOT NULL,
    DistrictName    VARCHAR(255) NOT NULL,
    StateCode       INT          NOT NULL,
    CONSTRAINT pk_districts PRIMARY KEY (DistrictCode)
);




-- ###

-- 	Q26.	Add a foreign key constraint to the districts table that references the StateCode column from a states table.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

ALTER TABLE districts
    ADD CONSTRAINT fk_districts_states
    FOREIGN KEY (StateCode)
    REFERENCES states (StateCode)
    ON DELETE CASCADE
    ON UPDATE CASCADE;




-- ###

-- -------------------------------------------------------------------------------------------------

-- SECTION 10.
-- UPDATE and DELETE [6 Marks]

-- 	Q27.	Update the FarmersPremiumAmount to 500.0 for the record where rowID is 1.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

UPDATE FarmersInsuranceData
SET FarmersPremiumAmount = 500.0
WHERE rowID = 1;




-- ###

-- 	Q28.	Update the Year to '2021' for all records where srcStateName is 'HIMACHAL PRADESH'.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

UPDATE FarmersInsuranceData
SET srcYear = 2021
WHERE srcStateName = 'HIMACHAL PRADESH';



-- ###

-- 	Q29.	Delete all records where the TotalFarmersCovered is less than 10000 and Year is 2020.
-- ###
-- 	[2 Marks]
-- ###
-- TYPE YOUR CODE BELOW >

DELETE FROM FarmersInsuranceData
WHERE TotalFarmersCovered < 10000
  AND srcYear = 2020;



-- ###
