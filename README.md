# NHS Prescribing Insights

A Python-based data analysis project using the NHS Prescription Cost Analysis (PCA) datasets. This repository demonstrates the full workflow of preparing and analysing large-scale healthcare prescribing data, from dataset integration and cleaning through to exploratory analysis, visualisation, and insight generation.

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

Data is publicly available from the NHSBSA Open Data Portal from January 2021 onwards, published with a roughly two-month lag, as a separate monthly resource file for each month. **This analysis specifically covers May 2025 to April 2026** (12 monthly files). The raw monthly CSVs and the full cleaned dataset are not included in this repo due to file size, see "How to Reproduce" below. The three summary tables produced during analysis (`top_spending_medicines.csv`, `regional_spending.csv`, `top_prescribed_medicines.csv`) are small and are included in `Data/` so the results can be viewed without re-running the notebook.

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

### 6. Insights & Conclusion

**Volume: cheap, everyday medicines dominate.** The medicines prescribed most often are all inexpensive, everyday treatments for common, long-term conditions. Atorvastatin 20mg (a cholesterol-lowering statin) tops the list with just over 40 million items dispensed, followed by Omeprazole (31.5 million, for acid reflux) and Amlodipine (24.1 million, for blood pressure).

**Cost: a very different story, led by Mounjaro.** The FreeStyle Libre 2 Plus Sensor, a glucose monitoring device, is the single highest-cost item at £311.8 million. Mounjaro is more striking still: three of its individual dose strengths each rank separately within the top 10 highest-cost medicines, together accounting for roughly £491.2 million. Once every dose strength and pack size is combined into one figure, Mounjaro's true total rises to £627.0 million — meaning the top-10 table alone understates its real cost impact by around £136 million, making it the single highest-spending medicine overall once treated as one drug rather than several separate line items. Despite this, Mounjaro doesn't appear anywhere in the top 10 by prescription volume.

**Region: spending is uneven across England.** The Midlands (£2,430.7 million) and North East and Yorkshire (£2,071.7 million) had the highest total spend. The South West was lowest at £1,046.3 million, with London second-lowest at £1,338.5 million.

**Limitations.** Costs are based on Net Ingredient Cost (NIC) — the list price before discounts or dispensing fees — so actual NHS spending may differ. Regional figures aren't adjusted for population size, so they reflect total spend rather than spend per patient. Different dose strengths of the same medicine are counted separately by default in a groupby on exact presentation name, which is why a dedicated calculation was needed to reveal Mounjaro's true combined cost.

**Conclusion.** NHS prescription spending appears shaped less by what gets prescribed most often, and more by the rising cost of newer, specialised treatments — with real implications for future NHS budgeting as demand for these kinds of drugs continues to grow.

## How to Reproduce

1. Clone the repo. Run: `git clone https://github.com/anweshadata/NHS-prescribing-insights.git` then `cd NHS-prescribing-insights`
2. Install dependencies. Run: `pip install -r requirements.txt`
3. Download the monthly NHS Prescription Cost Analysis (PCA) CSVs for **May 2025 through April 2026** from the [NHSBSA Open Data Portal](https://opendata.nhsbsa.net/dataset/prescription-cost-analysis-pca-monthly-data). Each month is published as a separate resource file; you'll need to select and download each of the 12 months individually.
4. Place the downloaded CSV files in a folder named `Data/` at the repo root (sibling to the `Notebook/` folder). The raw monthly CSVs and full cleaned dataset are not included in this repo due to file size.
5. Open `Notebook/nhs_prescription_analysis.ipynb` in Jupyter or VS Code and run all cells in order. Cleaned outputs (`cleaned_nhs_prescription_data.csv`, `top_spending_medicines.csv`, `regional_spending.csv`, `top_prescribed_medicines.csv`) will be saved back into `Data/`, overwriting the summary tables already included in the repo with freshly generated ones.

## About

Exploratory data analysis of NHS prescribing data (May 2025-April 2026) to uncover trends, patterns, and insights using Python. This project includes data cleaning, analysis, visualisation, and interpretation techniques to transform healthcare prescribing data into meaningful, evidence-based insights.

## Author

Anwesha Mohanty · [GitHub](https://github.com/anweshadata)
