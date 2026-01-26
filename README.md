# Treyd Analytics Core: Fintech Portfolio Engine

## 1. About Treyd

**Treyd** is a fintech pioneer providing "Sell now, pay later" inventory financing. They solve the "Cash Flow Gap" for scaling businesses by paying a merchant’s suppliers upfront, allowing the merchant to sell the goods and repay Treyd on flexible terms.

## 2. Project Overview

The **Treyd Analytics Core** is a robust SQL-based framework designed to provide a 360-degree view of the financing lifecycle. This project bridges raw transactional data with executive strategy, focusing on three critical pillars:

- **Risk Management:** Identifying capital exposure and defaults.
- **Operational Efficiency:** Measuring supplier fulfillment and repayment cycles.
- **Growth Dynamics:** Tracking cohort quality and merchant behavior.

## 3. Database Schema & Architecture

The analysis is built upon a relational architecture representing the core supply chain financing cycle.
![alt text](<db design.png>)

### The Core Tables:

- `Merchants`: Business entities utilizing Treyd’s financing.
- `Suppliers`: Manufacturers or wholesalers being paid by Treyd.
- `PurchaseOrders`: The funding events where Treyd pays the supplier.
- `Repayments`: The installment or lump-sum payments made by the merchant back to Treyd.

## 4. Key Questions Answered

- **Concentration Risk:** Does 20% of our merchant base represent a dangerous majority of our capital exposure?
- **Supplier Reliability:** Are certain manufacturers consistently delaying the merchant’s ability to start their repayment cycle?
- **Cohort Quality:** Are new merchants entering the platform with higher initial funding needs than in previous years?
- **Outlier Detection:** Which merchants exhibit funding patterns that deviate significantly from the platform average (Leave-One-Out Analysis)?

## 5. Strategic Insights Uncovered

- **Capital Recovery Velocity:** By calculating recovery rates per merchant, we identify "Over-leveraged" profiles before they reach a default state.
- **The Inventory Gap:** Measuring the time between funding and final settlement allows for optimized funding terms per industry.

## 6. How to Run the Analysis

This repository is designed to be plug-and-play.

### Step 1: Initialize the Environment

Execute the setup script to create the schema and populate it with synthetic data (including edge cases like defaults and reversals).

- `00_setup_mock_data.sql` in the '/init' folder.

### Step 2: Execute Analytical Scripts

Run the scripts in the `/queries` folder to generate business intelligence:

1.  `01_merchant_cohort_analysis.sql`
2.  `02_supplier_reliability_index.sql`
3.  `03_inventory_repayment_cycle.sql`
4.  `04_Merchants_recovery_rates.sql`
5.  `05_merchant_concentration_risk.sql`
6.  `First Default Risk Profile.sql`
7.  `Leave-One-Out Average.sql`
8.  `Risk Tiering.sql`
9.  `Serial Defaulter Check.sql`

---

**Author:** Boules Ghaly

**Project Purpose:** Professional Portfolio for Treyd Analytics
