CREATE OR REPLACE FUNCTION make_decision_on_stock_change()
RETURNS TRIGGER AS $$
BEGIN
    -- Simple decision-making logic: 
    -- For example, if stock price increases significantly, flag related options for review
    IF NEW.CurrentPrice > OLD.CurrentPrice * 1.1 THEN
        UPDATE Options
        SET NeedsReview = TRUE
        WHERE StockID = NEW.StockID;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION end_of_day_decision_process()
RETURNS VOID AS $$
BEGIN
    -- Simple end-of-day logic: 
    -- For example, reset the review flag on all options
    UPDATE Options
    SET NeedsReview = FALSE;
    
    RAISE NOTICE 'End-of-day reset process completed.';
END;
$$ LANGUAGE plpgsql;
