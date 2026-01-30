# FMCG Data Pipeline

This project is a data transformation pipeline for Fast-Moving Consumer Goods (FMCG) data, built using **dbt (data build tool)** and **Snowflake**. It follows a medallion architecture (Bronze, Silver, Gold) to process raw data into business-ready insights.

## Project Overview

The pipeline transforms raw data through three layers of quality:

*   **Bronze Layer**: Raw data ingestion. Data is loaded as-is from sources. Materialized as tables.
*   **Silver Layer**: Cleaned and conformed data. Deduplication, type casting, and basic cleaning happen here. Materialized as tables.
*   **Gold Layer**: Business-level aggregations and fact/dimension tables ready for reporting and analytics. Materialized as tables.

## Prerequisites

Before setting up the project, ensure you have the following:

*   **Python 3.8+**
*   **dbt Core** (installed via requirements)
*   **Snowflake Account** (with appropriate permissions to create tables and schemas)

## Setup & Installation

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd fmcg_data_pipeline
    ```

2.  **Install dependencies:**
    It is recommended to use a virtual environment.
    ```bash
    python -m venv venv
    source venv/bin/activate  # On Windows use `venv\Scripts\activate`
    pip install -r requirements.txt
    ```

3.  **Configure dbt Profile:**
    Set up your `~/.dbt/profiles.yml` file to connect to your Snowflake instance. The profile name used in this project is `fmcg_data_pipeline`.

    Example `profiles.yml` entry:
    ```yaml
    fmcg_data_pipeline:
      target: dev
      outputs:
        dev:
          type: snowflake
          account: <your-snowflake-account>
          user: <your-username>
          password: <your-password>
          role: <your-role>
          database: <your-database>
          warehouse: <your-warehouse>
          schema: <your-schema>
          threads: 4
    ```

4.  **Verify Connection:**
    Run the debug command to ensure dbt can connect to Snowflake.
    ```bash
    dbt debug
    ```

## Usage

### Running Models
To run the entire pipeline:
```bash
dbt run
```

To run a specific layer (e.g., only bronze models):
```bash
dbt run --select bronze
```
Or for silver/gold:
```bash
dbt run --select silver
dbt run --select gold
```

### Testing
Run data quality tests defined in the project:
```bash
dbt test
```

### Documentation
Generate and view project documentation:
```bash
dbt docs generate
dbt docs serve
```

## Project Structure

*   `models/`: Contains SQL files for dbt models.
    *   `bronze/`: Bronze layer models.
    *   `silver/`: Silver layer models.
    *   `gold/`: Gold layer models.
    *   `source/`: Source configurations.
*   `analyses/`: Ad-hoc SQL queries for analysis.
*   `macros/`: Custom dbt macros.
*   `seeds/`: CSV files for loading static data.
*   `snapshots/`: Snapshot definitions for Type 2 Slowly Changing Dimensions (SCD).
*   `tests/`: Custom data tests.
*   `dbt_project.yml`: Main dbt configuration file.
*   `requirements.txt`: Python dependencies.

## Resources

- [dbt Documentation](https://docs.getdbt.com/docs/introduction)
- [Snowflake Documentation](https://docs.snowflake.com/)
