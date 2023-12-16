-- Clients Table
CREATE TABLE Clients (
    ClientID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    ContactInformation TEXT,
    RiskAdversityFactor NUMERIC CHECK (RiskAdversityFactor >= 0 AND RiskAdversityFactor <= 1)
);

-- Wallets Table
CREATE TABLE Wallets (
    WalletID SERIAL PRIMARY KEY,
    ClientID INT UNIQUE NOT NULL,
    CreationDate DATE NOT NULL,
    Balance NUMERIC CHECK (Balance >= 0),
    FOREIGN KEY (ClientID) REFERENCES Clients (ClientID)
);

-- Stocks Table
CREATE TABLE Stocks (
    StockID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    TickerSymbol VARCHAR(10) UNIQUE NOT NULL,
    CurrentPrice NUMERIC CHECK (CurrentPrice >= 0) -- Assuming stock prices are non-negative
);

-- Options Table
CREATE TABLE Options (
    OptionID SERIAL PRIMARY KEY,
    WalletID INT NOT NULL,
    StockID INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    quantity INT CHECK (quantity > 0),
    PurchasePrice NUMERIC CHECK (PurchasePrice >= 0),
    CurrentPrice NUMERIC CHECK (CurrentPrice >= 0),
    ExpiryDate DATE NOT NULL,
    RiskFreeRate NUMERIC CHECK (RiskFreeRate >= 0 AND RiskFreeRate <= 1),
    Volatility NUMERIC CHECK (Volatility > 0 AND Volatility <= 1), -- Assuming volatility is between 0 and 1
    FOREIGN KEY (WalletID) REFERENCES Wallets (WalletID),
    FOREIGN KEY (StockID) REFERENCES Stocks (StockID)
);

-- Historical Stock Prices Table
CREATE TABLE HistoricalStockPrices (
    HistoricalStockPricesID SERIAL PRIMARY KEY,
    StockID INT NOT NULL,
    Date DATE NOT NULL,
    OpeningPrice NUMERIC CHECK (OpeningPrice >= 0),
    ClosingPrice NUMERIC CHECK (ClosingPrice >= 0),
    Volume BIGINT CHECK (Volume >= 0),
    High NUMERIC CHECK (High >= 0),
    Low NUMERIC CHECK (Low >= 0),
    FOREIGN KEY (StockID) REFERENCES Stocks (StockID)
);
