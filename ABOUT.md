# About This Project

## Overview

This repository is a complete, runnable **data warehouse** built from scratch in **SQL Server**. It takes two disconnected source systems — a CRM and an ERP — and turns their raw CSV exports into a single, trustworthy, business-ready analytical model.

The goal is not just to move data, but to show the full engineering path: **ingest → clean → integrate → model → validate**.

---

## The Problem

The two source systems describe the same business from different angles:

- **CRM** owns customers, products and sales transactions, but with system codes (`M`, `F`, `R`, `T`) instead of readable values, duplicate customer records, inconsistent whitespace, and product keys that pack two identifiers into one column.
- **ERP** holds complementary attributes — customer birthdates and gender, country of residence, product category and subcategory — keyed differently from the CRM (`AW-00011000` vs `AW00011000`).

Neither system alone can answer a question like *"what did customers in Australia spend on Mountain bikes last quarter?"* The warehouse exists to make that a single, simple query.

---

## Objectives

1. **Consolidate** CRM and ERP data into one SQL Server database.
2. **Cleanse and standardize** the raw data: deduplicate, trim, decode system codes, fix invalid dates and inconsistent sales figures.
3. **Integrate** the two sources on shared business keys.
4. **Model** the result as a star schema optimized for analytical queries.
5. **Validate** every layer with repeatable data quality checks.
6. **Document** the architecture, the flow and the naming standards so the design is understandable without reading the SQL.

---

## Scope

| In scope | Out of scope |
|----------|--------------|
| Batch, full-load ETL from flat files | Streaming / near-real-time ingestion |
| Latest state of the data | Full historization (SCD Type 2) |
| Single-instance SQL Server | Distributed or cloud-native warehouses |
| Star schema for BI consumption | Dashboards and reports themselves |

---

## Design Decisions

**Why the Medallion Architecture?**
Separating Bronze, Silver and Gold keeps each concern in one place. Raw data is always recoverable in Bronze, all cleaning logic lives in Silver, and business definitions live in Gold. A bug in a business rule never requires re-ingesting source files.

**Why tables in Bronze and Silver, but views in Gold?**
Bronze and Silver are materialized because the transformations are expensive and re-run on a schedule. Gold is defined as views so business logic is always applied on the freshest Silver data and there is no extra copy to keep in sync.

**Why full loads instead of incremental?**
The source files are complete extracts and the volumes are small. A `TRUNCATE` + reload is simpler, idempotent, and makes the pipeline safe to re-run at any time.

**Why surrogate keys in the dimensions?**
`ROW_NUMBER()` generates warehouse-owned keys, so the model does not depend on source system keys that may change format or collide across systems.

**Why stored procedures per layer?**
`bronze.load_bronze` and `silver.load_silver` each wrap their layer in a single callable unit with `TRY...CATCH` error handling and printed load durations, so the pipeline can be orchestrated and monitored step by step.

---

## What Happens in Each Layer

### 🥉 Bronze — raw landing
Tables mirror the source files exactly. Loaded with `TRUNCATE` + `BULK INSERT`. No transformation, no filtering, no renaming — anything that arrives is preserved.

### 🥈 Silver — cleansed and standardized
- Deduplicates customers, keeping the most recent record per `cst_id`
- Trims whitespace from names and keys
- Decodes system codes into readable values (`M` → `Married`, `R` → `Road`, …)
- Splits the composite product key into a category ID and a product key
- Derives product end dates from the next version's start date
- Repairs invalid dates and recalculates sales where `sales ≠ quantity × price`
- Normalizes ERP keys so they join cleanly to CRM keys

### 🥇 Gold — business-ready star schema
- `dim_customers` — CRM demographics enriched with ERP country and birthdate, with the CRM as the authoritative source for gender and the ERP as fallback
- `dim_products` — current products only, enriched with ERP category and subcategory
- `fact_sales` — sales transactions linked to both dimensions through surrogate keys

---

## Data Quality

Validation is part of the pipeline, not an afterthought. The scripts in `tests/` check for:

- Duplicate or null primary keys
- Unwanted leading/trailing spaces
- Values outside the expected standardized set
- Invalid or out-of-order dates
- Sales amounts inconsistent with quantity × price
- Referential integrity between `fact_sales` and its dimensions
- Uniqueness of every surrogate key

Each check is written so that **an empty result set means the data is healthy**.

---

## Skills Demonstrated

- Data warehouse design and layered (Medallion) architecture
- Dimensional modelling — star schema, facts, dimensions, surrogate keys
- T-SQL: window functions, `CASE` logic, joins, views, stored procedures, error handling
- ETL development and bulk data ingestion
- Cross-system data integration and key harmonization
- Data quality engineering and automated validation
- Technical documentation and diagramming (draw.io)

---

## Possible Next Steps

- Incremental / delta loads with watermark columns
- SCD Type 2 history on the customer and product dimensions
- Orchestration (SQL Agent, Airflow or Azure Data Factory) with logging tables
- An analytics layer: cohort, retention and product performance reports
- A BI dashboard built on top of the Gold views

---

## Credits

Source data is the classic **AdventureWorks**-style CRM/ERP sample, used here for educational purposes.

Built by [@mahmoudemad2810](https://github.com/mahmoudemad2810).
