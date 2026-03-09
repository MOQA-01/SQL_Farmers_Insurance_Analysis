# 🌾 PMFBY Farmers Insurance Analysis — SQL Case Study

> **Group:** PRMT101 | **Database:** MySQL 8.x / 9.6 (Homebrew) | **Schema:** `ndap`
> **Data Source:** [National Data and Analytics Platform (NDAP)](https://ndap.niti.gov.in/) | **Period:** 2018–2021

[![MySQL](https://img.shields.io/badge/MySQL-8.x%2F9.x-blue?logo=mysql)](https://www.mysql.com/)
[![License](https://img.shields.io/badge/License-Academic-lightgrey)]()
[![Status](https://img.shields.io/badge/Status-Complete-brightgreen)]()

---

## 📋 Table of Contents

- [Overview](#overview)
- [Dataset](#dataset)
- [Schema](#schema)
- [Analysis Sections](#analysis-sections)
- [Key Insights](#key-insights)
- [Setup & Usage](#setup--usage)
- [Team](#team)

---

## Overview

This project analyses the **Pradhan Mantri Fasal Bima Yojana (PMFBY)** crop insurance dataset using SQL to uncover trends in insurance coverage, premium distributions, and farmer demographics across Indian states and districts over 2018–2021.

PMFBY is a government-backed scheme providing financial security to farmers against natural calamities. This case study was submitted as an SQL assignment for academic evaluation.

---

## Dataset

| Property | Details |
|---|---|
| Source | NDAP (National Data and Analytics Platform) |
| Format | CSV → MySQL import |
| Records | 1,870 rows |
| Columns | 44 fields |
| Years Covered | 2018, 2019, 2020, 2021 |
| States Covered | 27 states / UTs |

**NULL handling:** Blank cells treated as NULL via `NULLIF`; numeric columns defaulted to `0` via `COALESCE`. Percentage columns retained as NULL where blank.

---

## Schema

**Primary table:** `FarmersInsuranceData`

```sql
rowID               INT          PRIMARY KEY
srcYear             INT
srcStateName        VARCHAR(255)
srcDistrictName     VARCHAR(255)
InsuranceUnits      INT
TotalFarmersCovered INT
InsuredLandArea     FLOAT        -- in thousand hectares
FarmersPremiumAmount    FLOAT    -- in lakh INR
StatePremiumAmount      FLOAT
GOVPremiumAmount        FLOAT
GrossPremiumAmountToBePaid FLOAT
SumInsured          FLOAT        -- in lakh INR
PercentageMaleFarmersCovered    FLOAT
PercentageFemaleFarmersCovered  FLOAT
PercentageSCFarmersCovered      FLOAT
PercentageSTFarmersCovered      FLOAT
-- ... demographic & land area columns
TotalPopulation     INT
LandArea            FLOAT
```

**Supporting tables (referential integrity demo):**

```sql
CREATE TABLE states (
    StateCode    INT NOT NULL,
    StateName    VARCHAR(255) NOT NULL,
    CONSTRAINT pk_states PRIMARY KEY (StateCode)
);

CREATE TABLE districts (
    DistrictCode   INT NOT NULL,
    DistrictName   VARCHAR(255) NOT NULL,
    StateCode      INT NOT NULL,
    CONSTRAINT pk_districts PRIMARY KEY (DistrictCode),
    CONSTRAINT fk_districts_states
        FOREIGN KEY (StateCode) REFERENCES states(StateCode)
        ON DELETE CASCADE ON UPDATE CASCADE
);
```

> **Note:** The `states` and `districts` tables are populated for referential integrity demonstration only and are not the primary source of analysis data.

---

## Analysis Sections

| Section | Topics Covered | Member |
|---|---|---|
| 1, 2, 10 | `SELECT`, Filtering, `UPDATE` & `DELETE` | Mohammed Qalandar Shah Quazi |
| 3, 4, 5 | Aggregation, Sorting & String Functions | Teja P |
| 6, 7 | JOINs & Subqueries | Pratiksha Hanumant Wagaj |
| 8, 9 | Window Functions & Constraints | Ramyata Rohan Mendhe |

### Query Highlights

**Basic SELECT & Filtering**
```sql
-- Farmers covered above average (subquery filter)
SELECT DISTINCT srcStateName, srcDistrictName, TotalFarmersCovered
FROM FarmersInsuranceData
WHERE TotalFarmersCovered > (SELECT AVG(TotalFarmersCovered) FROM FarmersInsuranceData)
ORDER BY TotalFarmersCovered DESC;
```

**Aggregation — State-level totals**
```sql
SELECT srcStateName,
       SUM(TotalFarmersCovered) AS TotalFarmersCovered,
       SUM(COALESCE(SumInsured, 0)) AS TotalSumInsured
FROM FarmersInsuranceData
GROUP BY srcStateName
ORDER BY TotalFarmersCovered DESC;
```

**Coverage-to-Population Ratio**
```sql
SELECT srcStateName, srcYear,
       SUM(TotalFarmersCovered) / NULLIF(SUM(TotalPopulation), 0) AS Ratio
FROM FarmersInsuranceData
GROUP BY srcStateName, srcYear
ORDER BY Ratio DESC LIMIT 3;
```

**Window Functions — ROW_NUMBER & RANK**
```sql
-- Top 20 districts by farmers covered
SELECT ROW_NUMBER() OVER (ORDER BY TotalFarmersCovered DESC) AS RowNum,
       rowID, srcStateName, srcDistrictName, srcYear, TotalFarmersCovered
FROM FarmersInsuranceData
ORDER BY TotalFarmersCovered DESC LIMIT 20;

-- RANK districts within each state by SumInsured
SELECT srcStateName, srcDistrictName, srcYear,
       COALESCE(SumInsured, 0) AS SumInsured,
       RANK() OVER (PARTITION BY srcStateName ORDER BY COALESCE(SumInsured, 0) DESC) AS SumInsuredRank
FROM FarmersInsuranceData
ORDER BY srcStateName, SumInsuredRank LIMIT 30;
```

**Cumulative Premium (Running Total)**
```sql
SELECT srcStateName, srcDistrictName, srcYear,
       COALESCE(FarmersPremiumAmount, 0) AS FarmersPremiumAmount,
       SUM(COALESCE(FarmersPremiumAmount, 0))
           OVER (PARTITION BY srcStateName ORDER BY srcYear ASC
                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
           AS CumulativeFarmersPremiumAmount
FROM FarmersInsuranceData
ORDER BY srcStateName, srcYear LIMIT 30;
```

**String Functions — LIKE pattern matching**
```sql
-- Districts ending with 'pur'
SELECT DISTINCT srcStateName, srcDistrictName
FROM FarmersInsuranceData
WHERE srcDistrictName LIKE '%pur'
ORDER BY srcStateName, srcDistrictName;
-- Returns 59 districts across 18 states
```

**LEFT JOIN with Subquery**
```sql
-- Districts where total premium > 100 crore (10,000 lakh)
SELECT pop.srcStateName, pop.srcDistrictName,
       SUM(COALESCE(ins.FarmersPremiumAmount, 0)) AS TotalFarmersPremiumAmount,
       AVG(pop.TotalPopulation) AS AvgTotalPopulation
FROM (SELECT srcStateName, srcDistrictName, srcYear, TotalPopulation
      FROM FarmersInsuranceData) pop
LEFT JOIN (SELECT srcStateName, srcDistrictName, srcYear, FarmersPremiumAmount
           FROM FarmersInsuranceData) ins
    ON pop.srcStateName = ins.srcStateName
    AND pop.srcDistrictName = ins.srcDistrictName
    AND pop.srcYear = ins.srcYear
GROUP BY pop.srcStateName, pop.srcDistrictName
HAVING SUM(COALESCE(ins.FarmersPremiumAmount, 0)) > 10000
ORDER BY TotalFarmersPremiumAmount DESC;
```

---

## Key Insights

### 1. Premium Concentration in Madhya Pradesh
MP dominates 2018 farmer premiums — Ujjain (3,273 lakh), Vidisha (2,470 lakh), Sehore (2,330 lakh) — with West Bengal's Hugli (2,777 lakh) also ranking high. Financial risk is **geographically skewed** toward a few MP districts.

### 2. Volume vs. Coverage Efficiency
MP leads in absolute coverage (**9.1M farmers**), followed by Maharashtra (8.9M) and UP (7.2M). However, **Chhattisgarh (0.0498)** and **Tripura (0.0464)** lead in coverage-to-population ratio — converting a higher share of their population into insured farmers despite lower absolute numbers.

### 3. Odisha's Outlier Sum Insured
Odisha's `SumInsured` (~13.75 lakh crore) far exceeds its farmer coverage (2.5M), surpassing even MP and Maharashtra. This suggests significantly **higher per-farmer insured values**, likely due to larger land holdings or higher crop valuations.

---

## Setup & Usage

### Prerequisites
- MySQL 8.x or 9.x
- The NDAP PMFBY CSV dataset

### Load the database

```bash
# Create schema and load data
mysql -u root --local-infile=1 < setup_database.sql

# Connect to the schema
mysql -u root ndap
```

### Verify the load

```sql
SELECT COUNT(*) AS total_rows FROM FarmersInsuranceData;
-- Expected: 1870

SELECT srcYear, COUNT(*) AS rows_per_year
FROM FarmersInsuranceData
GROUP BY srcYear;
-- 2018: 525 | 2019: 505 | 2020: 429 | 2021: 411
```

### Run queries

All queries are organized by section in the SQL scripts. You can run individual sections or the full script:

```bash
mysql -u root ndap < queries/section_01_select_filter.sql
mysql -u root ndap < queries/section_08_09_window_constraints.sql
```

### Key assumptions

- `FarmersPremiumAmount` and `SumInsured` are stored in **lakh INR** (scale × 100,000)
- `InsuredLandArea` is in **thousand hectares** — `WHERE > 5.0` refers to > 5,000 ha
- `Q20` uses `LIMIT 1` to ensure scalar subquery where multiple records share the max premium
- 20 crore threshold = 2,000 lakh in stored units

---

## Team

| Member | Sections |
|---|---|
| Mohammed Qalandar Shah Quazi | 1, 2, 10 — SELECT, Filtering, UPDATE & DELETE |
| Teja P | 3, 4, 5 — Aggregation, Sorting & String Functions |
| Pratiksha Hanumant Wagaj | 6, 7 — JOINs & Subqueries |
| Ramyata Rohan Mendhe | 8, 9 — Window Functions & Constraints |

---

*Assignment ID: SQL Case Study | Group: PRMT101 | Report Date: March 2026*