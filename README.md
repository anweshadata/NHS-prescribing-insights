# NHS Prescribing Insights

## Overview

This project explores NHS Prescription Cost Analysis (PCA) data to uncover trends, patterns, and insights from healthcare prescribing records.

The aim of this project is to demonstrate the process of transforming a large, messy public healthcare dataset into a clean and analysis-ready format. The project covers data loading, exploratory data analysis, data cleaning, and visualisation using Python.

The dataset contains over 6.8 million prescription records across multiple NHS regions and includes information about medicines, prescribing quantities, and prescription costs.

## Objectives

- Explore NHS prescribing data and understand its structure
- Identify data quality issues such as missing values, incorrect formats, and duplicates
- Clean and prepare the dataset for analysis
- Create summary tables to investigate prescribing trends
- Visualise patterns within NHS prescription activity
- Communicate insights from healthcare data in a clear and accessible way

## Dataset

**Source:** NHS Prescription Cost Analysis (PCA) Data

The dataset contains monthly prescribing information including:

- NHS regions and Integrated Care Boards (ICBs)
- Medicine names and categories
- Prescription quantities
- Number of items prescribed
- Net Ingredient Cost (NIC)
- Therapeutic classifications

Multiple monthly CSV files were combined into one consolidated dataset for analysis.

## Tools and Technologies

- Python 3
- Visual Studio Code
- Jupyter Extension for VS Code
- pandas
- NumPy
- Matplotlib
- Seaborn
- Git & GitHub

## Project Workflow

### 1. Data Loading and Exploration

- Imported required Python libraries
- Loaded multiple NHS CSV files
- Combined datasets into a single dataframe
- Investigated:
  - Dataset dimensions
  - Column information
  - Data types
  - Missing values
  - Duplicate records
  - Summary statistics

### 2. Data Cleaning

The dataset was cleaned by:

- Removing unnecessary administrative and classification columns
- Handling missing values
- Removing records with missing medicine classification information
- Checking and verifying data types
- Converting the `YEAR_MONTH` column into a datetime format

Cleaning decisions were documented throughout the analysis to maintain transparency and reproducibility.

### 3. Exploratory Analysis

Summary tables were created to investigate:

- Prescription activity across NHS regions
- Medicine categories and prescribing patterns
- Prescription quantities
- Prescription costs

Visualisations will be developed to communicate key findings and trends from the cleaned dataset.

## Project Structure
