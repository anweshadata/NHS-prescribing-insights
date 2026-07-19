# NHS Prescribing Insights – Data Cleaning

A Python-based data cleaning and preprocessing project using the **NHS Prescription Cost Analysis (PCA)** datasets. This repository demonstrates the end-to-end workflow used to combine, inspect, clean, and validate large monthly prescribing datasets before exploratory analysis and visualisation.

The project forms the data preparation stage of a wider NHS prescribing analysis portfolio project.

---

## Project Objective

To prepare multiple monthly NHS Prescription Cost Analysis datasets for analysis by applying a structured data cleaning workflow, including dataset integration, quality assessment, duplicate removal, missing value analysis, data type validation, and standardisation.

The aim was to produce a clean, reliable dataset suitable for exploratory data analysis and the development of data visualisations.

---

## Dataset

**Source:** NHS Business Services Authority (NHSBSA)

The project uses publicly available monthly **Prescription Cost Analysis (PCA)** datasets containing prescribing information for medicines dispensed in England.

The datasets include variables such as:

* BNF Code
* BNF Name
* Number of Items
* Quantity
* Net Ingredient Cost (NIC)
* Actual Cost
* Practice Information

Multiple monthly CSV files were combined into a single consolidated dataset before the cleaning process began.

---

## Tools & Skills Used

| Stage                   | Tools / Techniques                                                                        |
| ----------------------- | ----------------------------------------------------------------------------------------- |
| Development environment | Visual Studio Code (VS Code)                                                              |
| Programming language    | Python                                                                                    |
| Data loading            | pandas, pathlib, glob                                                                     |
| Data cleaning           | Duplicate detection, missing value assessment, data type validation, text standardisation |
| Data exploration        | pandas descriptive statistics and dataframe inspection                                    |
| Validation              | Data quality checks and final dataset verification                                        |

---

## Data Cleaning Workflow

The project followed a structured preprocessing workflow:

### **1. Import Libraries**

Imported the required Python libraries for data loading, cleaning, and exploration.

### **2. Load and Combine Monthly Datasets**

Automatically identified all monthly NHS PCA CSV files and combined them into a single dataframe for processing.

### **3. Initial Data Exploration**

Performed an initial inspection of the dataset by examining:

* Dataset dimensions
* Column names
* Data types
* Missing values
* Summary statistics
* Sample records

### **4. Remove Duplicate Records**

Checked for duplicate observations and removed duplicate rows to ensure each prescription record was unique.

### **5. Assess Missing Values**

Identified missing values across all columns and evaluated whether they required removal, retention, or further investigation.

### **6. Validate Data Types**

Verified that numerical and categorical columns were stored using appropriate data types to improve accuracy and efficiency.

### **7. Standardise Text Fields**

Cleaned text columns by removing unnecessary whitespace and improving formatting consistency where appropriate.

### **8. Validate Numeric Values**

Reviewed numerical columns for unexpected or invalid values using descriptive statistics and data quality checks.

### **9. Final Data Validation**

Performed a final verification to confirm that:

* Duplicate records had been removed
* Missing values had been assessed
* Data types were correct
* The dataset was ready for analysis

---

## Skills Demonstrated

* Data cleaning and preprocessing
* Exploratory data inspection
* Data quality assessment
* Python programming
* pandas dataframe manipulation
* Data validation
* Dataset integration
* Reproducible data preparation workflows

---

## Repository Structure

```text
├── README.md
├── nhs_prescribing_data_cleaning.ipynb
├── data/
│   ├── raw/
│   └── cleaned/
└── images/
```

---

## Future Work

The cleaned dataset will be used for further exploratory analysis, visualisation, and reporting to investigate prescribing patterns, prescribing costs, and trends within NHS prescription data.

---

## About

Built by **Anwesha Mohanty** as part of my independent data analytics portfolio to demonstrate practical data cleaning and preprocessing skills using real-world NHS prescribing data. The project showcases best practices for preparing large public datasets for reliable downstream analysis.
