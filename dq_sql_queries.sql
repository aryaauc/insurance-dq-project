-- =================================================
-- Finance Data Quality Analyst Portfolio Project
-- SQL Data Quality Checks: Insurance Claims Dataset
-- Author: Aryaa | Date: 2024
-- =================================================

-- DQ-01: Missing / Null Values in Critical Fields
SELECT
    'customer_id'   AS field,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_count,
    ROUND(COUNT(*) FILTER (WHERE customer_id IS NULL) * 100.0 / COUNT(*), 2) AS null_pct
FROM insurance_claims
UNION ALL
SELECT 'region', COUNT(*) FILTER (WHERE region IS NULL),
    ROUND(COUNT(*) FILTER (WHERE region IS NULL) * 100.0 / COUNT(*), 2)
FROM insurance_claims
UNION ALL
SELECT 'assessor_id', COUNT(*) FILTER (WHERE assessor_id IS NULL),
    ROUND(COUNT(*) FILTER (WHERE assessor_id IS NULL) * 100.0 / COUNT(*), 2)
FROM insurance_claims
UNION ALL
SELECT 'claim_type', COUNT(*) FILTER (WHERE claim_type IS NULL),
    ROUND(COUNT(*) FILTER (WHERE claim_type IS NULL) * 100.0 / COUNT(*), 2)
FROM insurance_claims;

-- DQ-02: Duplicate Claim IDs
SELECT claim_id, COUNT(*) AS duplicate_count
FROM insurance_claims
GROUP BY claim_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- DQ-03 & DQ-04: Invalid Claim Amounts
SELECT claim_id, policy_number, claim_amount_gbp,
    CASE
        WHEN claim_amount_gbp < 0 THEN 'Negative Amount'
        WHEN claim_amount_gbp = 0 THEN 'Zero Amount'
    END AS issue_type
FROM insurance_claims
WHERE claim_amount_gbp <= 0;

-- DQ-05: Report Date Before Incident Date (Chronological Violation)
SELECT claim_id, incident_date, report_date,
    JULIANDAY(incident_date) - JULIANDAY(report_date) AS days_discrepancy
FROM insurance_claims
WHERE report_date < incident_date
ORDER BY days_discrepancy DESC;

-- DQ-06: Future Incident Dates
SELECT claim_id, incident_date, status, claim_amount_gbp
FROM insurance_claims
WHERE incident_date > DATE('now')
ORDER BY incident_date;

-- DQ-07: Invalid Status Domain Values
SELECT status, COUNT(*) AS record_count
FROM insurance_claims
WHERE status NOT IN ('Open', 'Closed', 'Pending', 'Rejected')
GROUP BY status
ORDER BY record_count DESC;

-- DQ-08: Invalid Claim Type Domain Values
SELECT claim_type, COUNT(*) AS record_count
FROM insurance_claims
WHERE claim_type NOT IN ('Motor', 'Property', 'Liability', 'Health')
  AND claim_type IS NOT NULL
GROUP BY claim_type
ORDER BY record_count DESC;

-- DQ-09: Approved Amount Exceeds Claim Amount (Financial Integrity)
SELECT claim_id, policy_number, claim_amount_gbp, approved_amount_gbp,
    ROUND(approved_amount_gbp - claim_amount_gbp, 2) AS overpayment_gbp,
    ROUND((approved_amount_gbp / claim_amount_gbp - 1) * 100, 1) AS overpayment_pct
FROM insurance_claims
WHERE approved_amount_gbp > claim_amount_gbp
  AND claim_amount_gbp > 0
  AND approved_amount_gbp IS NOT NULL
ORDER BY overpayment_gbp DESC;

-- DQ-10: Rejected Claims with Approved Payout (Business Logic Violation)
SELECT claim_id, status, approved_amount_gbp, claim_amount_gbp, region
FROM insurance_claims
WHERE status = 'Rejected'
  AND approved_amount_gbp IS NOT NULL
ORDER BY approved_amount_gbp DESC;

-- SUMMARY: Data Quality Score by Category
SELECT
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END)                    AS missing_customer_id,
    SUM(CASE WHEN region IS NULL THEN 1 ELSE 0 END)                          AS missing_region,
    SUM(CASE WHEN claim_amount_gbp < 0 THEN 1 ELSE 0 END)                    AS negative_amounts,
    SUM(CASE WHEN report_date < incident_date THEN 1 ELSE 0 END)             AS date_violations,
    SUM(CASE WHEN approved_amount_gbp > claim_amount_gbp
             AND claim_amount_gbp > 0 THEN 1 ELSE 0 END)                     AS financial_integrity_issues,
    SUM(CASE WHEN status = 'Rejected'
             AND approved_amount_gbp IS NOT NULL THEN 1 ELSE 0 END)          AS logic_violations,
    COUNT(*)                                                                   AS total_records
FROM insurance_claims;
