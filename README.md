# Retail Orders ETL and Analysis

This repository demonstrates the process of extracting, cleaning, transforming, and analyzing retail orders data. The project uses Python and MySQL to perform data extraction from Kaggle, data cleaning, and exploratory data analysis (EDA) to derive business insights.

## Project Overview

In this project, I processed and analyzed a dataset containing over 10,000 retail orders. The process involved:
1. **Extracting the Dataset**: The retail orders dataset is downloaded from Kaggle using the Kaggle API in Python.
2. **Data Cleaning**: Null values were treated, columns were renamed, date columns were updated, and unnecessary columns were dropped.
3. **Data Transformation**: The cleaned data was loaded into a MySQL database for further analysis.
4. **Exploratory Data Analysis (EDA)**: SQL queries were used to answer various business questions about product performance, revenue generation, sales growth, and more.

## Business Questions Analyzed

The following key business queries were analyzed using the dataset:

1. **Top 10 Highest Revenue Generating Products**
2. **Top 5 Highest Selling Products in Each Region**
3. **Month-over-Month Growth Comparison for Sales (2022 vs. 2023)**
4. **Month with Highest Sales in Each Category**
5. **Highest Growth by Profit in Sub-Categories (2023 vs. 2022)**
6. **Revenue Contribution of Each Customer Segment**
7. **Products or Regions with the Highest Profit Margins**
8. **Impact of Ship Mode on Sales and Profitability**
9. **Comparison of Sales Across Seasons**
10. **Seasonal Sales Growth and Regional Performance Analysis**

## Project Structure
``` bash

Directory structure:
└── anshulkansal121-Retail_Orders_ETL/
    ├── Order_Data_Queries.sql  # EDA SQL Script
    ├── Retail Orders Data Cleaning and Loading.ipynb   # Python scripts for data extraction, cleaning, and loading
    ├── orders.csv   # Original Data 
    ├── orders.csv.zip
    └── .ipynb_checkpoints/
        └── Retail Order Data Cleaning and Loading-checkpoint.ipynb

```

## Requirements

To run this project, you need the following libraries installed:

- `pandas`
- `numpy`
- `mysql-connector-python`
- `pymysql`
- `kaggle`

You can install the required dependencies using:

```bash
pip install -r requirements.txt
```

## How to Run the Project

1. **Setup Kaggle API:** Ensure that you have the Kaggle API key setup. You can follow this guide to configure it. The .json file need to in **~/.kaggle/kaggle..json** directory.

2. **Run the Python Script**: Download and Run `Retail Orders Data Cleaning and Loading.ipynb` the following python script will perform the Data Extraction, Cleaning and Load it to Mysql Server.

3. **Run EDA and Analysis:** Open and run `Order_Data_Queries.sql` or you can also try the above mentioned analysis questions yourself.


## Pull Request Guidelines

To contribute to this project, please follow these guidelines:

**Steps to Create a PR:**
1. Fork the Repository

2. Create a New Branch for your changes

``` bash
git checkout -b feature/your-feature-name
```
3. Implement your feature, bug fix or any relevant insight, and make sure to follow the code style used in the repository.

4.  Write clear and concise commit messages describing the changes you made.

``` bash
git commit -m "Added feature or fixed bug"
```
5. Push your changes to your forked repository.

``` bash
git push origin feature/your-feature-name
```
6. Open a PR from your branch to the main repository. Ensure your PR follows these rules:

   - The PR should be clear and well-documented.
   - Ensure the PR only contains relevant changes.
   - Add detailed descriptions of the changes in the PR comments.
