
# Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytics Project** repository! 🚀  
This project showcases a complete data warehousing and analytics workflow, from raw data ingestion to business insights. Built as a hands-on portfolio project, it demonstrates practical data engineering and analytics skills using industry-standard approaches.

---
## 🏗️ Data Architecture

This project implements a Medallion Architecture with three layers: **Bronze**, **Silver**, and **Gold**.<br><br>
![Data Architecture](docs/Data_Architecture.png)

- **Bronze Layer**: Captures raw data directly from source systems (CSV files) into a SQL Server database.
- **Silver Layer**: Focuses on cleaning, standardizing, and transforming data to prepare it for analytics.
- **Gold Layer**: Contains business-ready, analytics-optimized data modeled in a star schema.

---

## 🔄 Data Flow Diagram

This diagram summarizes the journey of data from CRM and ERP sources through the Bronze and Silver layers, where it is refined and integrated. The process culminates in the Gold layer, producing analytical tables ready for business intelligence and reporting.<br><br>

![Gold Layer Data Flow](docs/gold-layer-diagram.png)

---

## 📊 Integration Model Diagram

This diagram illustrates how data from CRM and ERP sources is integrated at the logical level. It shows the relationships between transactional, customer, and product tables across both systems, highlighting how disparate data sources are connected and unified for downstream processing.<br><br>

![Integration Model](docs/integration_model_diagram.png)

---

## ⭐ Star Schema Model Diagram

The star schema diagram represents the final analytical data model in the Gold layer. It demonstrates how fact and dimension tables are structured for efficient querying and reporting, with clear relationships between sales transactions, customers, and products.<br><br>

![Star Schema Model](docs/star_schema_model_diagram.png)

---

## 🚀 How to Run the Full ETL Pipeline

After building and testing the automation scripts for all three layers (Bronze, Silver, and Gold), you can now run the entire ETL process in one click using the `run_full_etl.bat` file.

**Wait for the terminal to show:**

```bat
========================================================
 Starting Full ETL Process...
========================================================

[1/3]  Loading Bronze Layer...
TRUNCATE TABLE
COPY ...
Load completed successfully.

[2/3] Loading Silver Layer...
INSERT ...
Silver Layer Transformation Completed Successfully.

[3/3] Loading Gold Layer...
CREATE VIEW ...
Gold Layer views created successfully.

========================================================
 Full ETL Process Completed Successfully
 Total Time Taken: 30 seconds
========================================================
Press any key to continue . . .
```

---

## 📖 Project Overview

Key components of this project:

1. **Layered Data Architecture**: Modern data warehouse design using Bronze, Silver, and Gold layers.
2. **ETL Pipelines**: Automated extraction, transformation, and loading of data from source files.
3. **Data Modeling**: Creation of fact and dimension tables for efficient analytical queries.
4. **Analytics & Reporting**: SQL-based queries and reports to generate actionable business insights.

🎯 This repository is ideal for those looking to demonstrate skills in:
- SQL Development
- Data Architecture
- Data Engineering  
- ETL Pipeline Development  
- Data Modeling  
- Data Analytics  

---

## 🛠️ Useful Resources & Tools:

- **[Datasets](./datasets/):** Access to the project dataset (CSV files).
- **[PostgreSQL Server](https://www.postgresql.org/download/):** Lightweight server for hosting your SQL database.
- **[PG Admin tool](https://www.pgadmin.org/download/):** GUI for managing and interacting with PostgreSQL databases.
- **[Git Repository](https://github.com/):** Set up a GitHub account and repo to manage, version and collaborate on your code efficiently.
- **[DrawIO](https://www.drawio.com/):** Design data architecture, models, flows and diagrams.

---


## 🚦 Project Requirements

### Data Engineering

**Goal:**
Build a modern data warehouse that consolidates sales data for analytics and reporting.

**Scope:**
- **Data Sources:** Import data from ERP and CRM systems (CSV format).
- **Data Quality:** Clean and resolve issues before analysis.
- **Integration:** Merge both sources into a unified, analysis-friendly model.
- **Focus:** Use only the latest data; historization is not required.
- **Documentation:** Provide clear data model documentation for business and analytics users.

---

## 📈 Analytics & Reporting

**Goal:**
Develop SQL analytics to deliver insights on:
- Customer behavior
- Product performance
- Sales trends

These insights help stakeholders make informed, strategic decisions.

---

## 📂 Repository Structure

```
SQL-Data-Warehouse-Project/
│
├── datasets/                  # Source datasets (ERP and CRM CSV files)
│   ├── source_crm/            # CRM data
│   └── source_erp/            # ERP data
│
├── docs/                      # Documentation and diagrams
│   ├── bronze-layer-diagram.png
│   ├── Data_Architecture.png
│   ├── data_catalog.md
│   ├── gold-layer-diagram.png
│   ├── integration_model_diagram.png
│   ├── naming_conventions.md
│   ├── silver-layer-diagram.png
│   └── star_schema_model_diagram.png
│
├── scripts/                   # ETL and transformation scripts
│   ├── 01_bronze/             # Bronze layer scripts
│   ├── 02_silver/             # Silver layer scripts
│   └── 03_gold/               # Gold layer scripts
│
├── tests/                     # Data quality and validation scripts
│
├── run_full_etl.bat           # Batch file to run the full ETL pipeline
├── README.md                  # Project overview and instructions
├── LICENSE                    # License information
└── ...                        # Other supporting files
```
---

## 🛡️ License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share this project with proper attribution.

## 👤 About Me

Hi, I'm **Shashwat Singh**. I'm a passionate **Data Analyst** with a **B.Tech** in **Computer Science and Engineering** (specialization in **Big Data Analytics**) from SRM Institute of Science and Technology. I thrive on working with data in all its forms, from **business intelligence** and **reporting** to **ETL processes**, **automation**, and **advanced analytics**. My expertise spans the full **data lifecycle**, enabling impactful insights and efficient data-driven solutions.

Let's stay in touch! Feel free to connect with me on the following platforms:

[![ Portfolio](https://img.shields.io/badge/-Portfolio-800000?style=for-the-badge&logo=globe&logoColor=white)](https://www.shashwatanalyst.online/)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/shashwat-singh-bb2730357/)
[![X](https://img.shields.io/badge/X-000000?style=for-the-badge&logo=x&logoColor=white)](https://x.com/ShashwatSi48402)
[![LeetCode](https://img.shields.io/badge/LeetCode-FFA116?style=for-the-badge&logo=LeetCode&logoColor=black)](https://leetcode.com/u/fclDlbfku9/)
[![HackerRank](https://img.shields.io/badge/Hackerrank-2EC866?style=for-the-badge&logo=HackerRank&logoColor=white)](https://www.hackerrank.com/profile/shashwat98k)




