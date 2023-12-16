CREATE OR REPLACE VIEW ClientFinancialDashboard AS
SELECT
    c.ClientID,
    c.Name,
    o.OptionID,
    o.name AS OptionName,
    o.CurrentPrice AS OptionCurrentPrice,
    o.PurchasePrice AS OptionPurchasePrice,
    o.ExpiryDate,
    o.Exercised,
    s.CurrentPrice AS StockCurrentPrice,
    o.quantity * (o.CurrentPrice - o.PurchasePrice) AS PotentialGainLoss
FROM
    Clients c
JOIN
    Wallets w ON c.ClientID = w.ClientID
JOIN
    Options o ON w.WalletID = o.WalletID
JOIN
    Stocks s ON o.StockID = s.StockID;
