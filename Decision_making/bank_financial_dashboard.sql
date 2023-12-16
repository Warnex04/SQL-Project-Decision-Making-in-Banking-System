CREATE OR REPLACE VIEW BankFinancialDashboard AS
SELECT
    t.TransactionID,
    t.ClientID,
    t.Amount,
    t.Type,
    t.OptionID,
    t.TransactionDate,
    o.CurrentPrice AS OptionCurrentPrice,
    o.PurchasePrice AS OptionPurchasePrice,
    s.CurrentPrice AS StockCurrentPrice,
    CASE
        WHEN t.Type = 'BUY' THEN t.Amount - (o.quantity * o.CurrentPrice)
        WHEN t.Type = 'SELL' THEN (o.quantity * o.CurrentPrice) - t.Amount
    END AS PotentialGainLoss
FROM
    Transactions t
JOIN
    Options o ON t.OptionID = o.OptionID
JOIN
    Stocks s ON o.StockID = s.StockID;
