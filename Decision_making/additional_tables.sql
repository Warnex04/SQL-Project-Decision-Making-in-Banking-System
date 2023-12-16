ALTER TABLE Options
ADD COLUMN Ranking NUMERIC;

CREATE TABLE Transactions (
    TransactionID SERIAL PRIMARY KEY,
    ClientID INT NOT NULL,
    Amount NUMERIC NOT NULL,
    Type VARCHAR(10) NOT NULL, -- 'BUY' or 'SELL'
    OptionID INT, -- ID of the option being traded
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ClientID) REFERENCES Clients (ClientID),
    FOREIGN KEY (OptionID) REFERENCES Options (OptionID)
);

ALTER TABLE Options
ADD COLUMN Exercised BOOLEAN DEFAULT FALSE;

ALTER TABLE Options
ADD COLUMN NeedsReview BOOLEAN DEFAULT FALSE;
