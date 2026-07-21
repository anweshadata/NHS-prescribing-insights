# **NHS Prescribing Insights**

A Python-based data analysis project using the **NHS Prescription Cost Analysis (PCA)** datasets. This repository demonstrates the full workflow of preparing and analysing **large-scale healthcare prescribing data**, from dataset integration and cleaning through to exploratory analysis, visualisation, and insight generation.

---

## Project Objective

To clean, explore, and analyse multiple monthly **NHS Prescription Cost Analysis (PCA)** datasets in order to understand where NHS prescription spending is concentrated and what that reveals about UK healthcare priorities.

The project aimed to:

- **Combine** monthly prescription datasets into a single dataframe
- **Identify and resolve** data quality issues
- **Remove unnecessary variables**
- **Handle missing values**
- **Remove duplicate records**
- **Convert data types**
- Produce a **reliable dataset** for analysing NHS prescribing costs and medicine demand
- **Explore and summarise** the cleaned dataset to answer three research questions on cost, geography, and volume
- **Visualise** key findings with charts
- **Interpret** results into clear, evidence-based insights

---

## Dataset

**Source:** NHS Business Services Authority (NHSBSA)

The project uses publicly available **Prescription Cost Analysis (PCA)** datasets containing prescribing information for medicines dispensed in England.

The raw datasets include:

- Medicine names and classifications
- Prescription items
- Quantity prescribed
- Net Ingredient Cost (NIC)
- Regional information
- Prescriber and dispenser details

Data is publicly available from the [NHSBSA Open Data Portal](https://opendata.nhsbsa.net/dataset/prescription-cost-analysis-pca-monthly-data), covering January 2021 onwards, published with a roughly two-month lag. Data is not included in this repo due to file size, see "How to Reproduce" below.

---

## Tools & Skills Used

| Stage                   | Tools / Techniques                                             |
| ------------------------ | --------------------------------------------------------------- |
| Development environment  | Visual Studio Code (VS Code)                                    |
| Programming language     | Python                                                           |
| Data loading             | pandas, glob, os                                                 |
| Data cleaning            | Missing value handling, duplicate removal, column filtering     |
| Data validation          | Dataset inspection, summary statistics, quality checks          |
| Data transformation      | Datetime conversion, dataframe manipulation                     |
| Exploratory analysis     | pandas aggregation, groupby, summary tables                     |
| Data visualisation       | matplotlib, custom chart formatting                              |
| Data export              | Cleaned CSV outputs                                              |

---

## Workflow

The project followed a structured, end-to-end data analysis workflow:

### 1. Import Libraries and Load Monthly Datasets
The required Python libraries were imported for data manipulation, numerical operations, visualisation, and file management. All monthly NHS PCA CSV files were automatically located using `glob`, loaded into pandas dataframes, and combined into one consolidated dataset.

### 2. Initial Dataset Inspection
The combined dataset was inspected to understand its structure and identify potential data quality issues, including dataset dimensions, column names, data types, missing values, duplicate records, and descriptive statistics.

### 3. Data Cleaning
Administrative and classification variables outside the project scope were removed, including code identifiers, classification codes, SNOMED identifiers, supplier information, and pharmacy service fields. Two rows with missing `GENERIC_BNF_EQUIVALENT_NAME` values were dropped. The `YEAR_MONTH` field was converted from YYYYMM integer format (for example, `202505`) into datetime format. A total of 143,869 exact duplicate rows were identified and removed using `drop_duplicates()`.

Final cleaned dataset: **6,732,174 rows, 14 columns**, exported as `cleaned_nhs_prescription_data.csv`.

### 4. Exploratory Data Analysis
The cleaned dataset was explored to answer one central research question, split into three angles: which medicines cost the NHS the most overall, which regions account for the highest prescription spending, and which medicines are prescribed most frequently. Summary tables were generated for each and exported as `top_spending_medicines.csv`, `regional_spending.csv`, and `top_prescribed_medicines.csv`. A dedicated calculation was also added to capture Mounjaro's true combined cost across all its dose strengths and pack sizes, since a groupby on exact presentation name alone splits it into multiple separate rows.

### 5. Data Visualisation
Three charts were built to make the findings easier to interpret: a horizontal bar chart of the top 10 medicines by NHS spending, a bar chart comparing total spending by region, and a lollipop chart of the top 10 most prescribed medicines by volume.

### 6. Insights & Conclusion
Findings were interpreted across volume, cost, and region, with the analysis showing that cost and prescription volume tell very different stories. The medicines prescribed most often are inexpensive, everyday treatments, while overall spending is increasingly driven by a small number of expensive, newer treatments such as Mounjaro. Regional spending was found to vary considerably, with the Midlands and North East and Yorkshire spending the most, and the South West spending the least. Key limitations, including the use of list price NIC figures and the lack of population-adjusted regional data, are documented alongside the findings.

---

## How to Reproduce

1. Clone the repo. Run: git clone https://github.com/anweshadata/NHS-prescribing-insights.git then cd NHS-prescribing-insights
2. Install dependencies. Run: pip install -r requirements.txt
3. Download the monthly NHS Prescription Cost Analysis (PCA) CSVs from the [NHSBSA Open Data Portal](https://opendata.nhsbsa.net/dataset/prescription-cost-analysis-pca-monthly-data). Data is available from January 2021 onwards, published roughly two months in arrears.
4. Place the downloaded CSV files in a folder named `data/` at the repo root (sibling to the `Notebook/` folder). Data is not included in this repo due to file size.
5. Open `Notebook/nhs_prescription_analysis.ipynb` in Jupyter or VS Code and run all cells in order. Cleaned outputs (`cleaned_nhs_prescription_data.csv`, `top_spending_medicines.csv`, `regional_spending.csv`, `top_prescribed_medicines.csv`) will be saved back into `data/`.

---

## About

Exploratory data analysis of NHS prescribing data to uncover trends, patterns, and insights using Python. This project includes data cleaning, analysis, visualisation, and interpretation techniques to transform healthcare prescribing data into meaningful, evidence-based insights.

---

## Author

Anwesha Mohanty
[GitHub](https://github.com/anweshadata)
