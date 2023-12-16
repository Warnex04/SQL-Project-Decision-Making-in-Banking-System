CREATE OR REPLACE FUNCTION monte_carlo_option_price(
    p_current_price NUMERIC,
    p_strike_price NUMERIC,
    p_risk_free_rate NUMERIC,
    p_time_to_expiration NUMERIC,
    p_volatility NUMERIC,
    p_num_simulations INT
)
RETURNS TABLE(call_price NUMERIC, put_price NUMERIC) AS
$$
DECLARE
    v_drift NUMERIC;
    v_random_component NUMERIC;
    v_simulated_price NUMERIC;
    v_call_payoff NUMERIC := 0;
    v_put_payoff NUMERIC := 0;
    v_i INT;
BEGIN
    -- Calculate the drift component of stock price movement
    v_drift := (p_risk_free_rate - 0.5 * p_volatility * p_volatility) * p_time_to_expiration;

    -- Perform simulations
    FOR v_i IN 1..p_num_simulations LOOP
        -- Generate a random component based on the normal distribution
        SELECT INTO v_random_component exp(p_volatility * sqrt(p_time_to_expiration) * random_normal() + v_drift);
        
        -- Calculate the simulated end price of the stock
        v_simulated_price := p_current_price * v_random_component;
        
        -- Calculate payoffs for the call and put options
        v_call_payoff := v_call_payoff + GREATEST(v_simulated_price - p_strike_price, 0);
        v_put_payoff := v_put_payoff + GREATEST(p_strike_price - v_simulated_price, 0);
    END LOOP;

    -- Calculate the average payoffs and discount them to present value
    call_price := exp(-p_risk_free_rate * p_time_to_expiration) * (v_call_payoff / p_num_simulations);
    put_price := exp(-p_risk_free_rate * p_time_to_expiration) * (v_put_payoff / p_num_simulations);

    RETURN NEXT;
END;
$$ LANGUAGE plpgsql VOLATILE;

-- Function to generate normally distributed random numbers
CREATE OR REPLACE FUNCTION random_normal()
RETURNS NUMERIC LANGUAGE SQL AS
$$
SELECT sqrt(-2 * ln(1 - random())) * cos(2 * pi() * random());
$$;


-- Test

-- Test Case 1: Simple case
SELECT * FROM monte_carlo_option_price(100, 100, 0.05, 1, 0.2, 10000);

-- Test Case 2: Out of the money call option (stock price below strike price)
SELECT * FROM monte_carlo_option_price(90, 100, 0.05, 1, 0.2, 10000);

-- Test Case 3: In the money put option (stock price above strike price)
SELECT * FROM monte_carlo_option_price(110, 100, 0.05, 1, 0.2, 10000);

-- Test Case 4: Long time to expiration
SELECT * FROM monte_carlo_option_price(100, 100, 0.05, 5, 0.2, 10000);

-- Test Case 5: High volatility
SELECT * FROM monte_carlo_option_price(100, 100, 0.05, 1, 0.5, 10000);
