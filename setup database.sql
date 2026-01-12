-- 1. Setup Tables
CREATE TABLE Merchants (
    MerchantID INT PRIMARY KEY,
    MerchantName VARCHAR(100),
    Country VARCHAR(50),
    JoinedDate DATE
);

CREATE TABLE PurchaseOrders (
    PO_ID INT PRIMARY KEY,
    MerchantID INT,
    TotalAmount MONEY,
    SupplierName VARCHAR(100),
    FundingDate DATE
);

CREATE TABLE Repayments (
    RepaymentID INT PRIMARY KEY,
    PO_ID INT,
    MerchantID INT,
    DueDate DATE,
    RepaymentDate DATE NULL, -- NULL means unpaid
    Amount MONEY
);

-- 2. Seed Data with "Challenges"
INSERT INTO Merchants VALUES 
(101, 'EcoThreads', 'Sweden', '2023-01-15'),
(102, 'NordicTech', 'Norway', '2023-03-10'),
(103, 'GlowCosmetics', 'Denmark', '2023-05-20');

INSERT INTO PurchaseOrders VALUES
(5001, 101, 10000, 'SilkRoad Factory', '2024-01-01'),
(5002, 101, 5000, 'EcoPoly', '2024-02-01'),
(5003, 102, 25000, 'ChipMaker Inc', '2024-01-15'),
(5004, 103, 12000, 'BeautyLabs', '2024-06-01');

INSERT INTO Repayments VALUES
-- Merchant 101: Clean history initially, then a struggle
(1, 5001, 101, '2024-02-01', '2024-02-01', 5000), -- Paid on time
(2, 5001, 101, '2024-03-01', '2024-03-15', 5000), -- Late, but < 30 days
(3, 5002, 101, '2024-03-01', '2024-04-10', 2500), -- DEFAULT: 40 days late
(4, 5002, 101, '2024-04-01', NULL, 2500),         -- UNPAID: Currently 200+ days late (DEFAULT)

-- Merchant 102: The "One-time struggle"
(5, 5003, 102, '2024-02-15', '2024-04-01', 12500), -- DEFAULT: 45 days late
(6, 5003, 102, '2024-03-15', '2024-03-10', 12500), -- Paid EARLY (Rare but possible)

-- Merchant 103: New merchant, no defaults yet
(7, 5004, 103, '2024-07-01', '2024-07-01', 6000),
(8, 5004, 103, '2024-08-01', NULL, 6000);         -- Unpaid, but not yet 30 days past DueDate