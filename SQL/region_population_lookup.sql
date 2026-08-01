-- ============================================================
-- region_population_lookup.sql
-- Week 3: Lookup table, JOIN, and subquery practice
--
-- Purpose: Add a second table (region_population) to the
-- nhs_prescriptions.db database so regional NHS prescribing
-- spend can be compared on a per-capita basis, not just raw
-- totals. This addresses a limitation noted in the Project 1
-- report: regional spending wasn't adjusted for population.
--
-- Data source: regional population figures sourced from ONS
-- and 2021 Census estimates (via Wikipedia infoboxes, which
-- cite ONS mid-year estimates and Census 2021 directly).
-- NOTE: vintages are mixed (2019-2024) because a single
-- consistent-year ONS regional breakdown was only available
-- as an .xlsx file that could not be downloaded/parsed in the
-- environment used to build this. For a final report, replace
-- with a single consistent mid-year extract from:
-- https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/clinicalcommissioninggroupmidyearpopulationestimates
-- ============================================================

-- 1. Create the lookup table
CREATE TABLE IF NOT EXISTS region_population (
    REGION_NAME TEXT PRIMARY KEY,
    POPULATION INTEGER
);

-- 2. Populate it (population figures as described above)
INSERT OR REPLACE INTO region_population (REGION_NAME, POPULATION) VALUES
    ('LONDON', 9089736),                      -- 2024
    ('MIDLANDS', 10330501),                   -- East Midlands 5,063,164 (2024) + West Midlands 5,267,337 (2021 Census)
    ('NORTH EAST AND YORKSHIRE', 8150715),     -- North East 2,669,941 (2019) + Yorkshire & Humber 5,480,774 (2021)
    ('NORTH WEST', 7417397),                  -- 2021 Census
    ('SOUTH EAST', 9642942),                  -- 2024
    ('SOUTH WEST', 5889695),                  -- 2024
    ('EAST OF ENGLAND', 6576306);             -- 2024

-- 3. JOIN: total spend and spend per capita by region
SELECT
    p.REGION_NAME,
    SUM(p.NIC) AS total_spending,
    rp.POPULATION,
    ROUND(SUM(p.NIC) * 1.0 / rp.POPULATION, 2) AS spending_per_person
FROM prescriptions p
INNER JOIN region_population rp
    ON p.REGION_NAME = rp.REGION_NAME
GROUP BY p.REGION_NAME
ORDER BY spending_per_person DESC;

-- Result (as at time of writing):
-- NORTH EAST AND YORKSHIRE   254.18
-- MIDLANDS                   235.29
-- EAST OF ENGLAND            223.32
-- NORTH WEST                 222.88
-- SOUTH WEST                 177.64
-- SOUTH EAST                 175.34
-- LONDON                     147.26
--
-- Insight: London has the highest RAW total spend (population
-- size effect) but the LOWEST spend per capita - this flips the
-- naive "London spends the most" finding from raw totals alone.

-- 4. Subquery: which regions spend above the national average per capita
SELECT REGION_NAME, spending_per_person
FROM (
    SELECT
        p.REGION_NAME,
        ROUND(SUM(p.NIC) * 1.0 / rp.POPULATION, 2) AS spending_per_person
    FROM prescriptions p
    INNER JOIN region_population rp
        ON p.REGION_NAME = rp.REGION_NAME
    GROUP BY p.REGION_NAME
) AS regional_per_capita
WHERE spending_per_person > (
    SELECT AVG(spending_per_person)
    FROM (
        SELECT
            p2.REGION_NAME,
            SUM(p2.NIC) * 1.0 / rp2.POPULATION AS spending_per_person
        FROM prescriptions p2
        INNER JOIN region_population rp2
            ON p2.REGION_NAME = rp2.REGION_NAME
        GROUP BY p2.REGION_NAME
    )
)
ORDER BY spending_per_person DESC;

-- Result: 4 regions spend above the national per-capita average:
-- NORTH EAST AND YORKSHIRE, MIDLANDS, EAST OF ENGLAND, NORTH WEST
