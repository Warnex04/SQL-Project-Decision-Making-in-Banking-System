CREATE OR REPLACE FUNCTION update_option_ranking_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM calculate_option_ranking();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_option_ranking_trigger
AFTER UPDATE ON Stocks
FOR EACH ROW
EXECUTE FUNCTION update_option_ranking_trigger_function();


CREATE TRIGGER trigger_client_update
AFTER UPDATE OF RiskAdversityFactor ON Clients
FOR EACH ROW
EXECUTE FUNCTION decide_to_buy_options();

CREATE TRIGGER trigger_wallet_update
AFTER UPDATE OF Balance ON Wallets
FOR EACH ROW
EXECUTE FUNCTION decide_to_buy_options();

CREATE TRIGGER trigger_stock_price_change
AFTER UPDATE OF CurrentPrice ON Stocks
FOR EACH ROW
EXECUTE FUNCTION decide_to_exercise_options();

CREATE TRIGGER trigger_after_trade
AFTER INSERT ON Transactions
FOR EACH ROW
EXECUTE PROCEDURE update_wallet_after_trade();

CREATE TRIGGER trigger_after_exercise_decision
AFTER UPDATE OF Exercised ON Options
FOR EACH ROW
EXECUTE PROCEDURE update_portfolio_after_exercise();