CREATE OR REPLACE FUNCTION decide_to_exercise_options()
RETURNS TRIGGER AS $$
DECLARE
    option_record RECORD;
    threshold_days INT := 30; -- Threshold set to 30 days
BEGIN
    -- Loop through each option related to the updated stock
    FOR option_record IN SELECT * FROM Options WHERE StockID = NEW.StockID LOOP
        -- Decision Logic:
        -- Exercise the option if the current price is favorable compared to the strike price
        -- and if the time to expiration is within the threshold.
        IF (NEW.CurrentPrice > option_record.PurchasePrice AND (option_record.ExpiryDate - CURRENT_DATE) <= threshold_days) OR
           (NEW.CurrentPrice < option_record.PurchasePrice AND (option_record.ExpiryDate - CURRENT_DATE) <= threshold_days) THEN
            RAISE NOTICE 'It is beneficial to exercise option % for wallet %', option_record.OptionID, option_record.WalletID;
        ELSE
            RAISE NOTICE 'It is not beneficial to exercise option % for wallet %', option_record.OptionID, option_record.WalletID;
        END IF;
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
