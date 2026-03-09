-- ============================================================
-- Farmers Insurance Analysis - Database Setup Script
-- Group: PRMT101
-- Database: MySQL | Schema: ndap
-- ============================================================

-- Enable loading data from local files
SET GLOBAL local_infile = 1;

CREATE SCHEMA IF NOT EXISTS ndap;

USE ndap;

-- ============================================================
-- Drop and recreate the main table (idempotent setup)
-- ============================================================
DROP TABLE IF EXISTS FarmersInsuranceData;

CREATE TABLE FarmersInsuranceData (
    rowID                           INT PRIMARY KEY,
    srcYear                         INT,
    srcStateName                    VARCHAR(255),
    srcDistrictName                 VARCHAR(255),
    InsuranceUnits                  INT,
    TotalFarmersCovered             INT,
    ApplicationsLoaneeFarmers       INT,
    ApplicationsNonLoaneeFarmers    INT,
    InsuredLandArea                 FLOAT,
    FarmersPremiumAmount            FLOAT,
    StatePremiumAmount              FLOAT,
    GOVPremiumAmount                FLOAT,
    GrossPremiumAmountToBePaid      FLOAT,
    SumInsured                      FLOAT,
    PercentageMaleFarmersCovered    FLOAT,
    PercentageFemaleFarmersCovered  FLOAT,
    PercentageOthersCovered         FLOAT,
    PercentageSCFarmersCovered      FLOAT,
    PercentageSTFarmersCovered      FLOAT,
    PercentageOBCFarmersCovered     FLOAT,
    PercentageGeneralFarmersCovered FLOAT,
    PercentageMarginalFarmers       FLOAT,
    PercentageSmallFarmers          FLOAT,
    PercentageOtherFarmers          FLOAT,
    YearCode                        INT,
    Year_                           VARCHAR(255),
    Country                         VARCHAR(255),
    StateCode                       INT,
    DistrictCode                    INT,
    TotalPopulation                 INT,
    TotalPopulationUrban            INT,
    TotalPopulationRural            INT,
    TotalPopulationMale             INT,
    TotalPopulationMaleUrban        INT,
    TotalPopulationMaleRural        INT,
    TotalPopulationFemale           INT,
    TotalPopulationFemaleUrban      INT,
    TotalPopulationFemaleRural      INT,
    NumberOfHouseholds              INT,
    NumberOfHouseholdsUrban         INT,
    NumberOfHouseholdsRural         INT,
    LandAreaUrban                   FLOAT,
    LandAreaRural                   FLOAT,
    LandArea                        FLOAT
);

-- ============================================================
LOAD DATA LOCAL INFILE '/Users/moqa/Desktop/Farmer_insurence /Data_PMFBY/data.csv'
INTO TABLE FarmersInsuranceData
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    rowID,
    srcYear,
    srcStateName,
    srcDistrictName,
    InsuranceUnits,
    TotalFarmersCovered,
    ApplicationsLoaneeFarmers,
    ApplicationsNonLoaneeFarmers,
    InsuredLandArea,
    FarmersPremiumAmount,
    StatePremiumAmount,
    GOVPremiumAmount,
    GrossPremiumAmountToBePaid,
    SumInsured,
    @PercentageMaleFarmersCovered,
    @PercentageFemaleFarmersCovered,
    @PercentageOthersCovered,
    @PercentageSCFarmersCovered,
    @PercentageSTFarmersCovered,
    @PercentageOBCFarmersCovered,
    @PercentageGeneralFarmersCovered,
    @PercentageMarginalFarmers,
    @PercentageSmallFarmers,
    @PercentageOtherFarmers,
    YearCode,
    Year_,
    Country,
    StateCode,
    DistrictCode,
    @TotalPopulation,
    @TotalPopulationUrban,
    @TotalPopulationRural,
    @TotalPopulationMale,
    @TotalPopulationMaleUrban,
    @TotalPopulationMaleRural,
    @TotalPopulationFemale,
    @TotalPopulationFemaleUrban,
    @TotalPopulationFemaleRural,
    @NumberOfHouseholds,
    @NumberOfHouseholdsUrban,
    @NumberOfHouseholdsRural,
    @LandAreaUrban,
    @LandAreaRural,
    @LandArea
)
SET
    -- NULL handling: replace empty strings with NULL, then default to 0
    PercentageMaleFarmersCovered    = NULLIF(@PercentageMaleFarmersCovered,    ''),
    PercentageFemaleFarmersCovered  = NULLIF(@PercentageFemaleFarmersCovered,  ''),
    PercentageOthersCovered         = NULLIF(@PercentageOthersCovered,         ''),
    PercentageSCFarmersCovered      = NULLIF(@PercentageSCFarmersCovered,      ''),
    PercentageSTFarmersCovered      = NULLIF(@PercentageSTFarmersCovered,      ''),
    PercentageOBCFarmersCovered     = NULLIF(@PercentageOBCFarmersCovered,     ''),
    PercentageGeneralFarmersCovered = NULLIF(@PercentageGeneralFarmersCovered, ''),
    PercentageMarginalFarmers       = NULLIF(@PercentageMarginalFarmers,       ''),
    PercentageSmallFarmers          = NULLIF(@PercentageSmallFarmers,          ''),
    PercentageOtherFarmers          = NULLIF(@PercentageOtherFarmers,          ''),
    TotalPopulation                 = COALESCE(NULLIF(@TotalPopulation,        ''), 0),
    TotalPopulationUrban            = COALESCE(NULLIF(@TotalPopulationUrban,   ''), 0),
    TotalPopulationRural            = COALESCE(NULLIF(@TotalPopulationRural,   ''), 0),
    TotalPopulationMale             = COALESCE(NULLIF(@TotalPopulationMale,    ''), 0),
    TotalPopulationMaleUrban        = COALESCE(NULLIF(@TotalPopulationMaleUrban,  ''), 0),
    TotalPopulationMaleRural        = COALESCE(NULLIF(@TotalPopulationMaleRural,  ''), 0),
    TotalPopulationFemale           = COALESCE(NULLIF(@TotalPopulationFemale,     ''), 0),
    TotalPopulationFemaleUrban      = COALESCE(NULLIF(@TotalPopulationFemaleUrban,''), 0),
    TotalPopulationFemaleRural      = COALESCE(NULLIF(@TotalPopulationFemaleRural,''), 0),
    NumberOfHouseholds              = COALESCE(NULLIF(@NumberOfHouseholds,      ''), 0),
    NumberOfHouseholdsUrban         = COALESCE(NULLIF(@NumberOfHouseholdsUrban, ''), 0),
    NumberOfHouseholdsRural         = COALESCE(NULLIF(@NumberOfHouseholdsRural, ''), 0),
    LandAreaUrban                   = NULLIF(@LandAreaUrban,  ''),
    LandAreaRural                   = NULLIF(@LandAreaRural,  ''),
    LandArea                        = NULLIF(@LandArea,       '');

-- Verify load
SELECT COUNT(*) AS total_rows_loaded FROM FarmersInsuranceData;
