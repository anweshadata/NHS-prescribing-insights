# **NHS Prescribing Insights – Data Cleaning**

A Python-based data cleaning and preprocessing project using the **NHS Prescription Cost Analysis (PCA)** datasets. This repository demonstrates the preparation of **large-scale healthcare prescribing data** through dataset integration, quality assessment, cleaning, validation, and export of an **analysis-ready dataset**.

---

## Project Objective

To clean and prepare multiple monthly **NHS Prescription Cost Analysis (PCA)** datasets by applying a structured **ETL workflow**.

The project aimed to:

- **Combine** monthly prescription datasets into a single dataframe
- **Identify and resolve** data quality issues
- **Remove unnecessary variables**
- **Handle missing values**
- **Remove duplicate records**
- **Convert data types**
- Produce a **reliable dataset** for analysing NHS prescribing costs and medicine demand

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

Data is publicly available from the [NHSBSA Open Data Portal](https://opendata.nhsbsa.net/dataset/prescription-cost-analysis-pca-monthly-data), covering January 2021 onwards, published with a roughly two-month lag. Data is not included in this repo due to file size — see "How to Reproduce" below.

---

## Tools & Skills Used

| Stage                    | Tools / Techniques                                            |
| ------------------------ | --------------------------------------------------------------- |
| Development environment  | Visual Studio Code (VS Code)                                    |
| Programming language     | Python                                                           |
| Data loading             | pandas, glob, os                                                 |
| Data cleaning            | Missing value handling, duplicate removal, column filtering     |
| Data validation          | Dataset inspection, summary statistics, quality checks          |
| Data transformation      | Datetime conversion, dataframe manipulation                     |
| Exploratory analysis     | pandas aggregation, groupby, summary tables                     |
| Data export              | Cleaned CSV outputs                                              |

---

## Data Cleaning Workflow

The project followed a structured data preprocessing workflow:

### 1. Import Libraries and Load Monthly Datasets

The required Python libraries were imported for data manipulation, numerical operations, visualisation, and file management. All monthly NHS PCA CSV files were automatically located using `glob`, loaded into pandas dataframes, and combined into one consolidated dataset.

### 2. Initial Dataset Inspection

The combined dataset was inspected to understand its structure and identify potential data quality issues, including:

- Dataset dimensions
- Column names
- Data types
- Missing values
- Duplicate records
- Descriptive statistics

### 3. Remove Unnecessary Variables

Administrative and classification variables outside the project scope were removed, including code identifiers, classification codes, SNOMED identifiers, supplier information, and pharmacy service fields. This reduced dataset complexity while retaining variables required for prescription cost and frequency analysis.

### 4. Handle Missing Values

The `GENERIC_BNF_EQUIVALENT_NAME` column contained 2 missing records. Since these records could not be reliably categorised, they were removed.

### 5. Convert Data Types

The `YEAR_MONTH` field was converted from YYYYMM integer format (for example, `202505`) into datetime format, enabling monthly trend analysis, time-based grouping, and visualisation.

### 6. Remove Duplicate Records

Duplicate records were identified using pandas' `duplicated()` function. A total of 143,869 exact duplicate rows were detected and removed using `drop_duplicates()`, preventing repeated prescription records from influencing analysis results.

### 7. Final Dataset Validation

The cleaned dataset was checked to confirm no remaining missing values, no duplicate rows, correct data types, and that required analytical variables were retained.

Final cleaned dataset: **6,732,174 rows, 14 columns**

The cleaned dataset was exported as `cleaned_nhs_prescription_data.csv`.

---

## How to Reproduce

1. Clone the repo:
```
   git clone https://github.com/anweshadata/Nhs-prescribing-insights.git
   cd Nhs-prescribing-insights
```

2. Install dependencies:
```
   pip install -r requirements.txt
```

3. Download the monthly NHS Prescription Cost Analysis (PCA) CSVs from the [NHSBSA Open Data Portal](https://opendata.nhsbsa.net/dataset/prescription-cost-analysis-pca-monthly-data). Data is available from January 2021 onwards, published roughly two months in arrears.

4. Place the downloaded CSV files in a folder named `data/` at the repo root (sibling to the `Notebook/` folder). Data is not included in this repo due to file size.

5. Open `Notebook/nhs_prescription_analysis.ipynb` in Jupyter or VS Code and run all cells in order. Cleaned outputs (`cleaned_nhs_prescription_data.csv`, `top_spending_medicines.csv`, `regional_spending.csv`, `top_prescribed_medicines.csv`) will be saved back into `data/`.

---

## About

Exploratory data analysis of NHS prescribing data to uncover trends, patterns, and insights using Python. This project includes data cleaning, analysis, and visualisation techniques to transform healthcare data into meaningful insights.
