CREATE OR REPLACE FUNCTION update_wallet_after_trade()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF NEW.Type = 'BUY' THEN
            UPDATE Wallets
            SET Balance = Balance - NEW.Amount
            WHERE ClientID = NEW.ClientID;
        ELSIF NEW.Type = 'SELL' THEN
            UPDATE Wallets
            SET Balance = Balance + NEW.Amount
            WHERE ClientID = NEW.ClientID;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION update_portfolio_after_exercise()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.Exercised IS DISTINCT FROM NEW.Exercised AND NEW.Exercised THEN
        -- Logic for when an option is exercised
        RAISE NOTICE 'Option % has been exercised.', NEW.OptionID;
        -- Additional logic here to handle the exercise of the option
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
