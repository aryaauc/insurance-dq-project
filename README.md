# Insurance Claims — Data Quality Audit
### A Finance Data Quality Analyst Portfolio Project

---

## What this project is

This project simulates a data quality audit that a Finance Data Quality Analyst would run before insurance claims data is used in finance reporting. The goal is to catch issues — missing fields, duplicates, invalid values, financial inconsistencies — before they reach accountants or actuaries and cause problems downstream.

I used Python, SQL, and Excel to run the checks and document the findings in a format that a finance team could actually use.

---

## Files

| File | What it contains |
|---|---|
| `insurance_claims_raw.csv` | The raw dataset — 508 records, 12 fields, covering Jan 2023 to Jun 2024 |
| `DQ_Insurance_Claims_Analysis.ipynb` | The full analysis notebook — run this in Jupyter to see all the checks |
| `DQ_Assurance_Report_Insurance_Claims.xlsx` | The output report — this is what you'd share with the finance team |
| `dq_sql_queries.sql` | All SQL queries from the analysis as a standalone file |
| `README.md` | This file |

---

## What I checked

| Check | Category | Issue | Records Affected | Severity |
|---|---|---|---|---|
| DQ-01 | Completeness | Missing values in key fields | 40+ | HIGH |
| DQ-02 | Uniqueness | Duplicate claim IDs | 8 | HIGH |
| DQ-03 | Validity | Negative claim amounts | 7 | HIGH |
| DQ-04 | Validity | Zero claim amounts | 6 | MEDIUM |
| DQ-05 | Consistency | Report date before incident date | 14 | HIGH |
| DQ-06 | Validity | Future incident dates | 5 | HIGH |
| DQ-07 | Validity | Invalid status values | 10 | HIGH |
| DQ-08 | Validity | Invalid claim type values | 7 | MEDIUM |
| DQ-09 | Integrity | Approved amount exceeds claim amount | 15 | CRITICAL |
| DQ-10 | Consistency | Rejected claims with approved payouts | 36 | CRITICAL |

**Overall DQ Score: 93.2 / 100**

---

## Tools used

- Python (pandas, numpy) for data analysis and quality checks
- SQL (SQLite) for query-based investigation — the same approach used in most finance data teams
- Excel (openpyxl) to produce the assurance report

---

## How to run the notebook

Open Anaconda Prompt, navigate to the folder where you saved these files, then run:

```
jupyter notebook
```

Open `DQ_Insurance_Claims_Analysis.ipynb` and run all cells from top to bottom.

---

## Excel report tabs

- **Executive Summary** — KPI cards, full findings table with severity colour coding
- **Raw Data (Sample)** — First 200 rows of the dataset
- **Issue Breakdown** — Issues grouped by category and severity
- **Recommendations** — Prioritised action plan (immediate / short term / ongoing)
