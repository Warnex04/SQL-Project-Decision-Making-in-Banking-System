CREATE OR REPLACE VIEW v_option_prices AS
SELECT
    cl.ClientID,
    cl.Name AS ClientName,
    st.StockID,
    st.Name AS StockName,
    st.TickerSymbol,
    op.OptionID,
    op.name AS OptionName,
    mc.call_price AS MonteCarloCallPrice,
    mc.put_price AS MonteCarloPutPrice,
    bs.call_price AS BlackScholesCallPrice,
    bs.put_price AS BlackScholesPutPrice
FROM
    Clients cl
JOIN
    Wallets w ON cl.ClientID = w.ClientID
JOIN
    Options op ON w.WalletID = op.WalletID
JOIN
    Stocks st ON op.StockID = st.StockID,
    LATERAL (SELECT * FROM monte_carlo_option_price(op.CurrentPrice, op.PurchasePrice, op.RiskFreeRate, GREATEST((op.ExpiryDate - CURRENT_DATE)::NUMERIC/365, 1::NUMERIC/365), op.Volatility, 10000)) AS mc,
    LATERAL (SELECT * FROM black_scholes_option_price(op.CurrentPrice, op.PurchasePrice, GREATEST((op.ExpiryDate - CURRENT_DATE)::NUMERIC/365, 1::NUMERIC/365), op.RiskFreeRate, op.Volatility)) AS bs
WHERE (op.ExpiryDate - CURRENT_DATE) > 0;

-- Insert Data Sample for Sample Queries :

-- Insert into Clients Table
INSERT INTO Clients (Name, ContactInformation, RiskAdversityFactor) VALUES ('John Doe', 'johndoe@example.com', 0.3);

-- Insert into Wallets Table
INSERT INTO Wallets (ClientID, CreationDate, Balance) VALUES (1, '2023-01-01', 10000);

-- Insert into Stocks Table
INSERT INTO Stocks (Name, TickerSymbol, CurrentPrice) VALUES ('XYZ Corporation', 'StockXYZ', 150);

-- Insert into Options Table
INSERT INTO Options (WalletID, StockID, name, quantity, PurchasePrice, CurrentPrice, ExpiryDate, RiskFreeRate, Volatility) VALUES (1, 1, 'XYZ Option', 10, 100, 150, '2024-5-7', 0.05, 0.2);

-- Sample quaries

-- Sample Query 1: Retrieve all option prices for a specific client by ID
SELECT *
FROM v_option_prices
WHERE ClientID = 1;  -- Replace 1 with the actual ClientID you want to query

-- Sample Query 2: Retrieve all option prices for a specific stock by symbol
SELECT *
FROM v_option_prices
WHERE TickerSymbol = 'AAPL';  -- Replace 'AAPL' with the actual ticker symbol

-- Sample Query 3: Compare Monte Carlo and Black-Scholes call option prices for all options
SELECT ClientName, StockName, OptionName, MonteCarloCallPrice, BlackScholesCallPrice
FROM v_option_prices;

-- Sample Query 4: Retrieve options where the Monte Carlo call price is higher than the Black-Scholes call price
SELECT *
FROM v_option_prices
WHERE MonteCarloCallPrice > BlackScholesCallPrice;

-- Sample Query 5: Retrieve options where the put option prices are within a certain range
SELECT *
FROM v_option_prices
WHERE MonteCarloPutPrice BETWEEN 10 AND 50
AND BlackScholesPutPrice BETWEEN 10 AND 50;

-- Sample Query 6: Retrieve options sorted by highest difference between Monte Carlo and Black-Scholes call prices
SELECT *, (MonteCarloCallPrice - BlackScholesCallPrice) AS CallPriceDifference
FROM v_option_prices
ORDER BY CallPriceDifference DESC;

-- Sample Query 7: Retrieve options for a particular stock and client
SELECT *
FROM v_option_prices
WHERE ClientName = 'John Doe' AND StockName = 'XYZ Corporation';  -- Replace with actual names

-- Sample Query 8: Retrieve the top 5 most expensive call options based on Black-Scholes pricing
SELECT *
FROM v_option_prices
ORDER BY BlackScholesCallPrice DESC
LIMIT 5;



-- DEBUG DIVISION BY ZERO ERROR :

CREATE OR REPLACE VIEW v_option_prices_debug AS
SELECT
    op.OptionID,
    op.ExpiryDate,
    CURRENT_DATE AS Today,
    (op.ExpiryDate - CURRENT_DATE) AS DaysToExpiration,
    (op.ExpiryDate - CURRENT_DATE)/365 AS YearsToExpiration,
    GREATEST((op.ExpiryDate - CURRENT_DATE)/365, 1/365) AS AdjustedYearsToExpiration
FROM
    Options op;

-- Run this debug view
SELECT * FROM v_option_prices_debug;

-- In PostgreSQL, when we divide two integers, the result is also an integer. Since 143/365 is less than 1, it results in 0 in integer division..... replaced with float division. stupid discrepancy.