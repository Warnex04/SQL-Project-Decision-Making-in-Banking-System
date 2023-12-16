CREATE OR REPLACE FUNCTION decide_to_buy_options()
RETURNS TRIGGER AS $$
DECLARE
    client_risk_factor NUMERIC;
    client_balance NUMERIC;
    client_id INT;
    option_record RECORD;
BEGIN
    -- Determine client ID based on the table that caused the trigger
    IF TG_TABLE_NAME = 'clients' THEN
        client_id := NEW.ClientID;
    ELSIF TG_TABLE_NAME = 'wallets' THEN
        client_id := NEW.ClientID;
    END IF;

    -- Fetch client's risk adversity factor and wallet balance
    SELECT RiskAdversityFactor INTO client_risk_factor FROM Clients WHERE ClientID = client_id;
    SELECT Balance INTO client_balance FROM Wallets WHERE ClientID = client_id;

    -- Loop through available options to make a buying decision
    FOR option_record IN SELECT * FROM Options ORDER BY Ranking DESC LOOP
        -- Decision Logic:
        -- Buy call options if risk factor is high and balance is sufficient
        -- Buy put options if risk factor is low and balance is sufficient
        IF client_balance > option_record.PurchasePrice * option_record.quantity THEN
            IF client_risk_factor >= 0.5 THEN
                -- High-risk tolerance: prefer buying call options
                RAISE NOTICE 'Client % decides to buy CALL option %', client_id, option_record.OptionID;
            ELSE
                -- Low-risk tolerance: prefer buying put options
                RAISE NOTICE 'Client % decides to buy PUT option %', client_id, option_record.OptionID;
            END IF;
        END IF;
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
