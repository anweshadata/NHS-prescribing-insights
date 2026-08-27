# NHS Prescribing Insights

An end-to-end data analysis project using the NHS Prescription Cost Analysis (PCA) datasets, built three ways: Python/pandas for cleaning and exploratory analysis, SQL/SQLite for reproducible querying, and a Power BI dashboard for interactive reporting. This repository demonstrates the full workflow of preparing and analysing large-scale healthcare prescribing data, from dataset integration and cleaning through to exploratory analysis, visualisation, and insight generation.

**Analysis period covered: May 2025 - April 2026 (12 months)**

## Project Objective

To clean, explore, and analyse multiple monthly NHS Prescription Cost Analysis (PCA) datasets in order to understand where NHS prescription spending is concentrated and what that reveals about UK healthcare priorities.

The project aimed to:

- Combine monthly prescription datasets into a single dataframe
- Identify and resolve data quality issues
- Remove unnecessary variables
- Handle missing values
- Remove duplicate records
- Convert data types
- Produce a reliable dataset for analysing NHS prescribing costs and medicine demand
- Explore and summarise the cleaned dataset to answer three research questions on cost, geography, and volume
- Visualise key findings with charts
- Interpret results into clear, evidence-based insights
- Rebuild the analysis with SQL for reproducible, well-defined querying
- Deliver the findings as an interactive Power BI dashboard for non-technical stakeholders

## Dataset

**Source:** NHS Business Services Authority (NHSBSA)

The project uses publicly available Prescription Cost Analysis (PCA) datasets containing prescribing information for medicines dispensed in England.

The raw datasets include:

- Medicine names and classifications
- Prescription items
- Quantity prescribed
- Net Ingredient Cost (NIC)
- Regional information
- Prescriber and dispenser details

Data is publicly available from the NHSBSA Open Data Portal from January 2021 onwards, published with a roughly two-month lag, as a separate monthly resource file for each month. **This analysis specifically covers May 2025 to April 2026** (12 monthly files). The raw monthly CSVs and the full cleaned dataset are not included in this repo due to file size, see "How to Run" below. The three summary tables produced during analysis (`top_spending_medicines.csv`, `regional_spending.csv`, `top_prescribed_medicines.csv`) are small and are included in `Data/` so the results can be viewed without re-running the notebook.

## Tools & Skills Used

| Stage | Tools / Techniques |
|---|---|
| Development environment | Visual Studio Code (VS Code) |
| Programming language | Python |
| Data loading | pandas, glob, os |
| Data cleaning | Missing value handling, duplicate removal, column filtering |
| Data validation | Dataset inspection, summary statistics, quality checks |
| Data transformation | Datetime conversion, dataframe manipulation |
| Exploratory analysis | pandas aggregation, groupby, summary tables |
| Data visualisation | matplotlib, custom chart formatting |
| Data export | Cleaned CSV outputs |
| Database | SQLite, indexed tables |
| SQL | SELECT, WHERE, GROUP BY, HAVING, aggregates, JOIN, subqueries |
| Business intelligence | Power BI Desktop, multi-page report design, DAX (measures, calculated columns, RANKX, CALCULATE, filter context) |
| Reproducibility | venv, `requirements.txt`, standalone pipeline script, Git LFS |

## Workflow

The project followed a structured, end-to-end data analysis workflow:

### 1. Import Libraries and Load Monthly Datasets

The required Python libraries were imported for data manipulation, numerical operations, visualisation, and file management. All monthly NHS PCA CSV files (May 2025-April 2026) were automatically located using `glob`, loaded into pandas dataframes, and combined into one consolidated dataset.

### 2. Initial Dataset Inspection

The combined dataset was inspected to understand its structure and identify potential data quality issues, including dataset dimensions, column names, data types, missing values, duplicate records, and descriptive statistics.

### 3. Data Cleaning

Administrative and classification variables outside the project scope were removed, including code identifiers, classification codes, SNOMED identifiers, supplier information, and pharmacy service fields. Two rows with missing `GENERIC_BNF_EQUIVALENT_NAME` values were dropped. The `YEAR_MONTH` field was converted from YYYYMM integer format (for example, 202505) into datetime format. A total of 143,869 exact duplicate rows were identified and removed using `drop_duplicates()`.

Final cleaned dataset: 6,732,174 rows, 14 columns, exported as `cleaned_nhs_prescription_data.csv`.

### 4. Exploratory Data Analysis

The cleaned dataset was explored to answer one central research question, split into three angles: which medicines cost the NHS the most overall, which regions account for the highest prescription spending, and which medicines are prescribed most frequently. Summary tables were generated for each and exported as `top_spending_medicines.csv`, `regional_spending.csv`, and `top_prescribed_medicines.csv`. A dedicated calculation was also added to capture Mounjaro's true combined cost across all its dose strengths and pack sizes, since a groupby on exact presentation name alone splits it into multiple separate rows.

### 5. Data Visualisation

Three charts were built to make the findings easier to interpret: a horizontal bar chart of the top 10 medicines by NHS spending, a bar chart comparing total spending by region, and a lollipop chart of the top 10 most prescribed medicines by volume.

### 6. Database & SQL Analysis

The cleaned dataset was loaded into a SQLite database (`Data/nhs_prescriptions.db`), with indexes added on `REGION_NAME`, `BNF_PRESENTATION_NAME`, and `YEAR_MONTH` for faster querying. `SQL/practice_queries.sql` covers core query patterns (`SELECT`, `WHERE`, `ORDER BY`, `GROUP BY`, `HAVING`, aggregates, `LIKE`). `SQL/region_population_lookup.sql` adds a second `region_population` lookup table (population estimates from ONS/Census 2021, mixed vintages 2019-2024) and uses a `JOIN` plus a subquery to calculate NHS spending per capita by region, and to identify which regions spend above the national per-capita average.

### 7. Insights & Conclusion

**Volume: cheap, everyday medicines dominate.** The medicines prescribed most often are all inexpensive, everyday treatments for common, long-term conditions. Atorvastatin 20mg (a cholesterol-lowering statin) tops the list with just over 40 million items dispensed, followed by Omeprazole (31.5 million, for acid reflux) and Amlodipine (24.1 million, for blood pressure).

**Cost: a very different story, led by Mounjaro.** The FreeStyle Libre 2 Plus Sensor, a glucose monitoring device, is the single highest-cost item at £311.8 million. Mounjaro is more striking still: three of its individual dose strengths each rank separately within the top 10 highest-cost medicines, together accounting for roughly £491.2 million. Once every dose strength and pack size is combined into one figure, Mounjaro's true total rises to £627.0 million — meaning the top-10 table alone understates its real cost impact by around £136 million, making it the single highest-spending medicine overall once treated as one drug rather than several separate line items. Despite this, Mounjaro doesn't appear anywhere in the top 10 by prescription volume.

**Region: spending is uneven across England — and raw totals are misleading.** By raw total, the Midlands (£2,430.7 million) and North East and Yorkshire (£2,071.7 million) had the highest spend, with the South West lowest at £1,046.3 million and London second-lowest at £1,338.5 million. But raw totals mostly track population size. Adjusting for population (spend per capita, via the `region_population` lookup table and JOIN in `SQL/region_population_lookup.sql`) flips this: North East and Yorkshire has the highest per-capita spend (£254.18), followed by the Midlands (£235.29), while London — despite having the second-highest *raw* total — has the *lowest* per-capita spend (£147.26) of any region. Four regions (North East and Yorkshire, Midlands, East of England, North West) spend above the national per-capita average.

**Limitations.** Costs are based on Net Ingredient Cost (NIC) — the list price before discounts or dispensing fees — so actual NHS spending may differ. The per-capita regional figures use population estimates from mixed vintages (2019-2024, sourced via Wikipedia infoboxes citing ONS/Census 2021) rather than a single consistent-year ONS extract, since a matching single-year regional breakdown was only available as an `.xlsx` file that couldn't be downloaded/parsed in the environment used to build this — a more rigorous version would pull a single mid-year estimate directly from the [ONS CCG/ICB population dataset](https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/clinicalcommissioninggroupmidyearpopulationestimates). Different dose strengths of the same medicine are counted separately by default in a groupby on exact presentation name, which is why a dedicated calculation was needed to reveal Mounjaro's true combined cost.

**Conclusion.** NHS prescription spending appears shaped less by what gets prescribed most often, and more by the rising cost of newer, specialised treatments — with real implications for future NHS budgeting as demand for these kinds of drugs continues to grow.

### 8. Power BI Dashboard

To make the findings usable by a non-technical stakeholder rather than requiring them to read a notebook or run SQL queries, the same cleaned dataset was rebuilt as a 5-page interactive Power BI report (`Power BI/NHS_Prescribing_Insights_Dashboard.pbix`): **Overview** (KPI summary, cost trend, a region filter synced across all 5 pages), **Cost** (top medicines by spend, and Mounjaro's true combined cost once all dose strengths are unified), **Volume** (top medicines by items prescribed, items trend over time), **Cost vs Volume** (where high-spend and high-volume medicines diverge — zero overlap between the two Top 10 lists), and **Regional** (spend by region, both raw totals and per capita). See [`Power BI/NOTES.md`](./Power%20BI/NOTES.md) for detailed build notes and troubleshooting, including a DAX filter-context bug, a deprecated map visual, and other fixes made along the way. The dashboard's findings match those in Insights & Conclusion above — the same underlying dataset and calculations, presented as an explorable report rather than static charts.

## Folder Structure

```
nhs-prescription-analysis/
├── Data/                              # not tracked in git except the 3 summary CSVs below (see Setup)
│   ├── pca_YYYYMM.csv                 # 12 monthly raw files (downloaded, not included)
│   ├── cleaned_nhs_prescription_data.csv  # generated
│   ├── nhs_prescriptions.db           # generated SQLite database
│   ├── top_spending_medicines.csv     # included — small, viewable without re-running anything
│   ├── regional_spending.csv          # included
│   └── top_prescribed_medicines.csv   # included
├── Notebook/
│   ├── nhs_prescription_analysis.ipynb
│   └── data_pipeline.py               # reusable load/clean/load-to-sqlite functions
├── SQL/
│   ├── practice_queries.sql
│   └── region_population_lookup.sql
├── Power BI/
│   ├── NHS_Prescribing_Insights_Dashboard.pbix
│   └── NOTES.md                       # build notes & troubleshooting
├── requirements.txt
├── .gitignore
└── README.md
```

## Setup

1. Install [Git LFS](https://git-lfs.github.com) if you don't have it, then clone the repo: `git lfs install` (one-time, per machine) followed by `git clone https://github.com/anweshadata/NHS-prescribing-insights.git` then `cd NHS-prescribing-insights`. Git LFS is required to properly download `Power BI/NHS_Prescribing_Insights_Dashboard.pbix` — without it you'll get a small pointer file instead of the actual `.pbix`.
2. Create and activate a virtual environment:
   - Windows: `python -m venv venv` then `venv\Scripts\activate`
   - macOS/Linux: `python -m venv venv` then `source venv/bin/activate`
3. Install dependencies. Run: `pip install -r requirements.txt`

## How to Run

1. Download the monthly NHS Prescription Cost Analysis (PCA) CSVs for **May 2025 through April 2026** from the [NHSBSA Open Data Portal](https://opendata.nhsbsa.net/dataset/prescription-cost-analysis-pca-monthly-data). Each month is published as a separate resource file; you'll need to select and download each of the 12 months individually.
2. Place the downloaded CSV files in a folder named `Data/` at the repo root (sibling to the `Notebook/` folder) — you'll need to create this folder yourself, since it isn't tracked in git (see `.gitignore`). The raw monthly CSVs and full cleaned dataset are not included in this repo due to file size.
3. Either:
   - Open `Notebook/nhs_prescription_analysis.ipynb` in Jupyter or VS Code and run all cells in order, **or**
   - Run the pipeline directly from the `Notebook/` folder: `cd Notebook` then `python data_pipeline.py`, which loads, cleans, and writes the cleaned data into an indexed `nhs_prescriptions.db` (this covers steps 1-3 of the workflow above; the EDA, visualisation, and insights steps still need to be run from the notebook).
4. Either route saves outputs back into `Data/`: `cleaned_nhs_prescription_data.csv`, `nhs_prescriptions.db`, and (notebook only) `top_spending_medicines.csv`, `regional_spending.csv`, `top_prescribed_medicines.csv` — overwriting the summary tables already included in the repo with freshly generated ones.
5. To run the SQL analysis, open `Data/nhs_prescriptions.db` in any SQLite client (e.g. [DB Browser for SQLite](https://sqlitebrowser.org/), or the SQLite extension in VS Code) and run the queries in `SQL/practice_queries.sql` and `SQL/region_population_lookup.sql`.
6. To view the Power BI dashboard, open `Power BI/NHS_Prescribing_Insights_Dashboard.pbix` in [Power BI Desktop](https://www.microsoft.com/en-us/power-platform/products/power-bi/downloads) (free, Windows only). The report's data sources point to `cleaned_nhs_prescription_data.csv` (generated in steps 3-4 above) and `region_population.csv` (included at the repo root), so if either file isn't at its original local path, refresh will fail until the source paths are updated (**Transform Data > Data source settings** in Power BI Desktop). See `Power BI/NOTES.md` for background on how the report was built.

## Reflections

**SQL vs pandas — which did I prefer?** Honestly, both, for different reasons. Pandas felt like the right tool for the messy, step-by-step cleaning work — combining 12 monthly CSVs, dropping columns, fixing types, deduplicating 143,869 rows — where I needed to see and shape the data incrementally as I went. SQL felt more natural once the data was already clean and the task became "answer this specific question" — especially the region per-capita analysis, where a JOIN plus a subquery expressed "spend per capita by region, then filter to above-average regions" more compactly than the equivalent pandas would have. If anything, working through both on the same dataset made the distinction clearer: pandas for irregular, exploratory cleaning; SQL for well-defined aggregation and lookup questions against data that's already in good shape.

**Power BI — what did building it a third way add?** The regional and Mounjaro findings didn't change between the pandas, SQL, and Power BI versions, but getting them into a report someone else could filter themselves surfaced new problems: DAX's filter context caught me out more than once, where a measure that looked correct in isolation gave a silently wrong answer once a relationship or a slicer was involved, in a way that neither pandas nor SQL had exposed. I also decided against building fully dynamic text callouts, since this version's deliverable is static screenshots of the unfiltered report rather than a live shared file — a trade-off documented in `Power BI/NOTES.md` rather than solved. Overall this felt like the project that was most about anticipating how someone else would actually use the output, not just getting the right answer.

## About

Exploratory data analysis of NHS prescribing data (May 2025-April 2026) to uncover trends, patterns, and insights, using Python, SQL, and Power BI. This project includes data cleaning, analysis, visualisation, and interpretation techniques to transform healthcare prescribing data into meaningful, evidence-based insights.

## Author

Anwesha Mohanty · [GitHub](https://github.com/anweshadata)
