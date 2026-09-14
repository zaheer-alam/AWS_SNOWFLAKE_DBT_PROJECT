# 🏠 Airbnb End-to-End Data Engineering Pipeline

An end-to-end **Data Engineering / Analytics Engineering project** that builds a modern ELT pipeline using **AWS S3, Snowflake, dbt, SQL, and Jinja**.

The project demonstrates how raw Airbnb data can be ingested from cloud storage, loaded into Snowflake, transformed through a **Bronze → Silver → Gold Medallion Architecture**, tested for data quality, and prepared for downstream analytics.

---

## 📌 Project Overview

Modern data platforms rarely perform all transformations before loading data into a warehouse.

This project follows an **ELT (Extract, Load, Transform)** architecture:

```text
CSV Source Data
       │
       ▼
    AWS S3
       │
       ▼
Snowflake Staging
       │
       ▼
┌─────────────────┐
│  BRONZE LAYER   │
│    Raw Data     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  SILVER LAYER   │
│ Cleaned Data    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   GOLD LAYER    │
│ Analytics Ready │
└────────┬────────┘
         │
         ▼
 BI / Analytics / Reporting
```

The pipeline processes three core Airbnb datasets:

* 🏘️ **Listings**
* 📅 **Bookings**
* 👤 **Hosts**

---

# 🎯 Project Objectives

The main objectives of this project are to demonstrate practical implementation of:

* Cloud-based data ingestion using **AWS S3**
* Data warehousing using **Snowflake**
* ELT transformation using **dbt Core**
* Medallion Architecture
* Incremental data loading
* Data cleaning and standardization
* Reusable SQL using **Jinja & dbt Macros**
* Slowly Changing Dimensions (**SCD Type 2**)
* Data quality testing
* Data lineage
* Dimensional / analytical modeling
* Git-based version control

---

# 🛠️ Technology Stack

| Technology       | Purpose                            |
| ---------------- | ---------------------------------- |
| **AWS S3**       | Cloud storage for source CSV files |
| **Snowflake**    | Cloud data warehouse               |
| **dbt Core**     | Data transformation and modeling   |
| **SQL**          | Data transformation and analysis   |
| **Jinja**        | Dynamic SQL generation             |
| **Python**       | Project environment                |
| **Git & GitHub** | Version control                    |
| **VS Code**      | Development environment            |

---

# 🏗️ Architecture

## 1️⃣ Source Layer

The project starts with Airbnb CSV datasets containing information about:

```text
bookings
hosts
listings
```

The source files are uploaded to **Amazon S3**.

---

## 2️⃣ AWS S3

AWS S3 acts as the cloud storage layer.

```text
CSV Files
    │
    ▼
AWS S3 Bucket
    │
    ▼
Snowflake External Stage
```

Snowflake accesses the files stored in S3 and loads them into staging tables.

---

## 3️⃣ Snowflake Staging Layer

The source data is initially loaded into the Snowflake staging area.

Example source tables:

```text
AIRBNB.STAGING.BOOKINGS
AIRBNB.STAGING.HOSTS
AIRBNB.STAGING.LISTINGS
```

This layer represents the data before dbt transformations are applied.

---

# 🥉 Bronze Layer

The Bronze layer contains data close to its original source structure.

Main models:

```text
bronze_bookings
bronze_hosts
bronze_listings
```

### Purpose

* Preserve source-level data
* Create a controlled transformation starting point
* Support incremental processing
* Separate source ingestion from downstream transformations

---

# 🥈 Silver Layer

The Silver layer contains **cleaned, standardized and transformed data**.

Main models:

```text
silver_bookings
silver_hosts
silver_listings
```

Typical transformations include:

* Cleaning column values
* Standardizing data
* Removing unwanted records
* Applying business rules
* Creating derived columns
* Preparing datasets for joins
* Applying reusable macros

The Silver layer becomes the trusted source for downstream analytical models.

---

# 🥇 Gold Layer

The Gold layer contains **business-ready analytical datasets**.

Examples include:

```text
fact
obt
```

### OBT — One Big Table

The **One Big Table (OBT)** combines information from:

```text
Bookings
   +
Listings
   +
Hosts
```

to create a denormalized dataset that can be consumed easily by analytics and BI applications.

Conceptually:

```text
SILVER_BOOKINGS
       │
       │ listing_id
       ▼
SILVER_LISTINGS
       │
       │ host_id
       ▼
 SILVER_HOSTS
       │
       ▼
      OBT
```

---

# ⚡ Incremental Data Loading

One important feature implemented in this project is **incremental processing**.

Instead of rebuilding an entire table every time dbt runs, incremental models process only newly added or changed records.

Conceptually:

```sql
{{ config(materialized='incremental') }}

SELECT *
FROM {{ source('staging', 'listings') }}

{% if is_incremental() %}

WHERE created_at > (
    SELECT COALESCE(MAX(created_at), '1900-01-01')
    FROM {{ this }}
)

{% endif %}
```

### Benefits

* Faster pipeline execution
* Reduced warehouse compute
* Better scalability
* Avoids unnecessary full-table processing

---

# 🧩 dbt Macros & Jinja

The project uses **Jinja templating and custom dbt macros** to make SQL reusable and maintainable.

Examples include reusable logic for:

```text
Schema generation
String trimming
Categorization / tagging
Mathematical operations
Dynamic SQL generation
```

Instead of repeatedly writing the same SQL logic, macros allow transformations to be centralized and reused across models.

---

# 🔄 Dynamic SQL Generation

Jinja loops are also used to dynamically generate SQL.

This is particularly useful when multiple tables contain similar transformation or joining patterns.

Conceptually:

```text
Configuration
     │
     ▼
 Jinja Loop
     │
     ▼
Generated SQL
     │
     ▼
Snowflake Execution
```

This approach reduces repetitive SQL and makes models easier to maintain.

---

# 🕒 Slowly Changing Dimensions — SCD Type 2

The project uses **dbt snapshots** to preserve historical changes.

Instead of overwriting old values when a record changes, SCD Type 2 maintains historical versions.

Example:

```text
Host 101

Version 1
City: Delhi
Valid From: 2025-01-01
Valid To: 2026-02-15

Version 2
City: Mumbai
Valid From: 2026-02-15
Valid To: NULL
```

This enables questions such as:

> What did the record look like at a specific point in time?

Snapshots are maintained for key datasets such as:

```text
Bookings
Hosts
Listings
```

---

# 🧪 Data Quality Testing

dbt tests help validate the reliability of transformed data.

The project demonstrates checks such as:

```text
NOT NULL
UNIQUE
Referential integrity
Source validation
Custom SQL tests
```

Testing helps prevent bad data from silently reaching analytical models.

Tests can be executed using:

```bash
dbt test
```

---

# 🔗 Data Lineage

One major advantage of dbt is automatic lineage tracking.

Conceptually:

```text
SOURCE
   │
   ▼
BRONZE
   │
   ▼
SILVER
   │
   ├──────────────┐
   ▼              ▼
FACT             OBT
   │              │
   └──────┬───────┘
          ▼
      ANALYTICS
```

This makes it easier to understand:

* Upstream dependencies
* Downstream dependencies
* Transformation flow
* Impact of model changes

---

# 📂 Project Structure

```text
AWS_SNOWFLAKE_DBT_PROJECT/
│
├── aws_dbt_snowflake_project/
│   │
│   ├── models/
│   │   ├── sources/
│   │   │   └── sources.yml
│   │   │
│   │   ├── bronze/
│   │   │   ├── bronze_bookings.sql
│   │   │   ├── bronze_hosts.sql
│   │   │   └── bronze_listings.sql
│   │   │
│   │   ├── silver/
│   │   │   ├── silver_bookings.sql
│   │   │   ├── silver_hosts.sql
│   │   │   └── silver_listings.sql
│   │   │
│   │   └── gold/
│   │       ├── fact.sql
│   │       ├── obt.sql
│   │       └── ephemeral/
│   │
│   ├── macros/
│   │   ├── generate_schema_name.sql
│   │   ├── multiply.sql
│   │   ├── tag.sql
│   │   └── trimmer.sql
│   │
│   ├── snapshots/
│   │
│   ├── tests/
│   │
│   ├── analyses/
│   │
│   ├── seeds/
│   │
│   └── dbt_project.yml
│
├── .gitignore
├── .python-version
├── main.py
├── pyproject.toml
├── uv.lock
└── README.md
```

---

# 🚀 Running the Project

## 1. Clone Repository

```bash
git clone https://github.com/zaheer-alam/AWS_SNOWFLAKE_DBT_PROJECT.git

cd AWS_SNOWFLAKE_DBT_PROJECT
```

## 2. Create Python Environment

Python **3.12+** is recommended for the current project configuration.

```bash
python -m venv .venv
```

Windows:

```bash
.venv\Scripts\activate
```

---

## 3. Install Dependencies

```bash
pip install dbt-core dbt-snowflake
```

The project currently uses:

```text
dbt-core >= 1.12.4
dbt-snowflake >= 1.12.0
```

---

## 4. Configure Snowflake

Create your local dbt `profiles.yml` configuration with your own Snowflake credentials.

⚠️ **Never commit Snowflake passwords, AWS access keys, secret keys, or other credentials to GitHub.**

---

## 5. Test the Connection

Navigate to the dbt project:

```bash
cd aws_dbt_snowflake_project
```

Then:

```bash
dbt debug
```

---

## 6. Run Models

Run the complete transformation pipeline:

```bash
dbt run
```

Or run individual layers:

```bash
dbt run --select bronze
dbt run --select silver
dbt run --select gold
```

---

## 7. Run Tests

```bash
dbt test
```

---

## 8. Run Snapshots

```bash
dbt snapshot
```

---

## 9. Build the Project

```bash
dbt build
```

---

## 📚 Generate dbt Documentation

Generate documentation:

```bash
dbt docs generate
```

Start the documentation server:

```bash
dbt docs serve
```

This provides an interactive interface for exploring models, documentation, dependencies, and lineage.

---

# 💡 Key Data Engineering Concepts Demonstrated

This project demonstrates practical knowledge of:

**Data Engineering**

`ETL/ELT` • `Data Ingestion` • `Cloud Storage` • `Data Warehousing`

**Data Modeling**

`Medallion Architecture` • `Bronze/Silver/Gold` • `Fact Tables` • `OBT`

**dbt**

`Models` • `Sources` • `ref()` • `source()` • `Macros` • `Jinja` • `Tests` • `Snapshots`

**Pipeline Optimization**

`Incremental Loading` • `Reusable SQL` • `Modular Transformations`

**Data Warehousing**

`SCD Type 2` • `Historical Tracking` • `Data Quality` • `Data Lineage`

---

# 📈 Future Improvements

Potential improvements to make the pipeline more production-ready:

* [ ] Add orchestration using Apache Airflow
* [ ] Add automated CI/CD using GitHub Actions
* [ ] Expand dbt testing coverage
* [ ] Add freshness checks
* [ ] Add Power BI dashboard
* [ ] Add pipeline monitoring and alerting
* [ ] Implement additional dimensional models
* [ ] Add automated S3 → Snowflake ingestion using Snowpipe
* [ ] Add production/dev dbt environments

---

# 🎓 What I Learned

Building this project provided hands-on experience with the complete lifecycle of a modern analytics engineering pipeline:

```text
Raw Data
   ↓
Cloud Storage
   ↓
Data Warehouse
   ↓
Transformation
   ↓
Data Quality
   ↓
Data Modeling
   ↓
Analytics-Ready Data
```

The project strengthened practical understanding of **AWS S3, Snowflake, dbt, SQL, ELT architecture, incremental loading, Jinja, macros, data quality testing, snapshots, SCD Type 2, and analytical data modeling**.

---

# 👤 Author

**Zaheer Alam**

Data Analytics & Data Engineering Enthusiast

GitHub: `zaheer-alam`

---

⭐ If you found this project useful, feel free to star the repository.
