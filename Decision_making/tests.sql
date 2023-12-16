-- Truncate tables and restart identity
TRUNCATE TABLE HistoricalStockPrices RESTART IDENTITY CASCADE;
TRUNCATE TABLE Options RESTART IDENTITY CASCADE;
TRUNCATE TABLE Stocks RESTART IDENTITY CASCADE;
TRUNCATE TABLE Wallets RESTART IDENTITY CASCADE;
TRUNCATE TABLE Clients RESTART IDENTITY CASCADE;


-- Insert test data into Clients, Wallets, Stocks, and Options tables
-- Example insertions (adjust according to your schema and test cases):

-- Insert Clients
INSERT INTO Clients (Name, ContactInformation, RiskAdversityFactor) VALUES 
('Test Client 1', 'client1@example.com', 0.5),
('Test Client 2', 'client2@example.com', 0.7);

-- Insert Wallets (assuming ClientIDs are 1 and 2)
INSERT INTO Wallets (ClientID, CreationDate, Balance) VALUES 
(1, '2023-01-01', 10000),
(2, '2023-01-02', 15000);

-- Insert Stocks
INSERT INTO Stocks (Name, TickerSymbol, CurrentPrice) VALUES 
('Test Stock 1', 'TS1', 100),
('Test Stock 2', 'TS2', 200);

-- Insert Options (assuming StockIDs are 1 and 2, and WalletIDs are 1 and 2)
INSERT INTO Options (WalletID, StockID, name, quantity, PurchasePrice, CurrentPrice, ExpiryDate, RiskFreeRate, Volatility) VALUES 
(1, 1, 'Option 1', 10, 90, 110, '2024-01-01', 0.01, 0.3),
(2, 2, 'Option 2', 5, 180, 220, '2024-06-01', 0.02, 0.4);

-- Option Ranking System Test :

-- Call the ranking function to update option rankings based on the current data
SELECT calculate_option_ranking();

-- Query to check the updated rankings in the Options table
SELECT * FROM Options;

-- Simulate a scenario where a stock price is updated
UPDATE Stocks SET CurrentPrice = 105 WHERE StockID = 1;

-- Check if the option rankings are updated after the stock price change
SELECT * FROM Options;


-- Decision Logic for Buying Test :

-- Test the decision logic for a specific client (ClientID 1) to buy options
SELECT * FROM decide_to_buy_options(1);

-- Update the risk factor of a client and see if it affects the buying decision
UPDATE Clients SET RiskAdversityFactor = 0.7 WHERE ClientID = 1;

-- Update the wallet balance of a client and see how it impacts the buying decision
UPDATE Wallets SET Balance = 20000 WHERE ClientID = 1;

-- Update a stock's current price to trigger the re-evaluation of buying decisions
UPDATE Stocks SET CurrentPrice = 120 WHERE StockID = 1;

-- Decision Logic for Exercise Test :

-- Example: Simulate a significant increase in stock price
UPDATE Stocks SET CurrentPrice = 200 WHERE StockID = 1; -- Assuming StockID 1 is relevant

-- Example: Simulate a significant decrease in stock price
UPDATE Stocks SET CurrentPrice = 50 WHERE StockID = 2; -- Assuming StockID 2 is relevant

-- Verify if options linked to StockID 1 are marked as exercised
SELECT OptionID, Exercised FROM Options WHERE StockID = 1;

-- Verify if options linked to StockID 2 are marked as exercised
SELECT OptionID, Exercised FROM Options WHERE StockID = 2;


-- Client Portfolio Test :

-- Simulate buying an option (reduce balance)
INSERT INTO Transactions (ClientID, Amount, Type, OptionID, TransactionDate)
VALUES (1, 500, 'BUY', 1, CURRENT_TIMESTAMP);

-- Simulate selling an option (increase balance)
INSERT INTO Transactions (ClientID, Amount, Type, OptionID, TransactionDate)
VALUES (1, 300, 'SELL', 1, CURRENT_TIMESTAMP);

-- Check the updated balance for ClientID 1
SELECT * FROM Wallets WHERE ClientID = 1;

-- Mark an option as exercised
UPDATE Options SET Exercised = TRUE WHERE OptionID = 1;

-- Check if the option is marked as exercised
SELECT * FROM Options WHERE OptionID = 1;

-- Visualize the bank dashboard :

SELECT * FROM BankFinancialDashboard;

-- Visualize tjhe client dashboard :

SELECT * FROM ClientFinancialDashboard WHERE ClientID = 1;

-- Simple Auto Decision Making Test :

-- Simulate an increase in stock price by more than 10%
UPDATE Stocks SET CurrentPrice = CurrentPrice * 1.15 WHERE StockID = 1;

-- Check if options linked to StockID 1 are marked for review
SELECT OptionID, NeedsReview FROM Options WHERE StockID = 1;

-- Execute the end-of-day function to reset review flags
SELECT end_of_day_decision_process();

-- this needs a cron job setup in bash :
# Open the cron jobs file
crontab -e

# Add a line to run the function at a specific time, e.g., 6 PM every weekday
0 18 * * 1-5 psql -d your_database -c "SELECT end_of_day_decision_process();"

-- Verify that the NeedsReview flag has been reset
SELECT OptionID, NeedsReview FROM Options;
