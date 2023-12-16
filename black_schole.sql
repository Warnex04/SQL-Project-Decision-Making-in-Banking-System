CREATE OR REPLACE FUNCTION black_scholes_option_price(
    p_stock_price NUMERIC,
    p_strike_price NUMERIC,
    p_time_to_expiration NUMERIC,
    p_risk_free_rate NUMERIC,
    p_volatility NUMERIC
)
RETURNS TABLE(call_price NUMERIC, put_price NUMERIC) LANGUAGE plpgsql AS
$$
DECLARE
    d1 NUMERIC;
    d2 NUMERIC;
BEGIN
    -- Ensure all parameters are valid to prevent division by zero
    IF p_stock_price <= 0 OR p_strike_price <= 0 OR p_time_to_expiration <= 0 OR p_volatility <= 0 THEN
        call_price := NULL;
        put_price := NULL;
        RETURN NEXT;
    END IF;

    -- Calculate d1 and d2 for the Black-Scholes formula
    d1 := (ln(p_stock_price / p_strike_price) + (p_risk_free_rate + (p_volatility ^ 2) / 2) * p_time_to_expiration) / (p_volatility * sqrt(p_time_to_expiration));
    d2 := d1 - p_volatility * sqrt(p_time_to_expiration);

    -- Calculate the call and put option prices using the Black-Scholes formula
    call_price := p_stock_price * cdf_normal(d1) - p_strike_price * exp(-p_risk_free_rate * p_time_to_expiration) * cdf_normal(d2);
    put_price := call_price - p_stock_price + p_strike_price * exp(-p_risk_free_rate * p_time_to_expiration);

    RETURN NEXT;
END;
$$;




-- Auxiliary function to calculate the cumulative distribution function for the standard normal distribution
CREATE OR REPLACE FUNCTION cdf_normal(x NUMERIC)
RETURNS NUMERIC LANGUAGE plpgsql AS
$$
DECLARE
    b1 NUMERIC := 0.319381530;
    b2 NUMERIC := -0.356563782;
    b3 NUMERIC := 1.781477937;
    b4 NUMERIC := -1.821255978;
    b5 NUMERIC := 1.330274429;
    p NUMERIC := 0.2316419;
    c NUMERIC := 0.39894228;
    t NUMERIC;
    z NUMERIC;
BEGIN
    IF x >= 0 THEN
        t := 1 / (1 + p * x);
        z := 1 - c * exp(-x * x / 2) * t * 
            (t * (t * (t * (t * b5 + b4) + b3) + b2) + b1);
        RETURN z;
    ELSE
        t := 1 / (1 - p * x);
        z := c * exp(-x * x / 2) * t * 
            (t * (t * (t * (t * b5 + b4) + b3) + b2) + b1);
        RETURN 1 - z;
    END IF;
END;
$$;


-- Test

-- Test Case 1: At-the-money option where stock price equals strike price
SELECT * FROM black_scholes_option_price(100, 100, 1, 0.05, 0.2);

-- Test Case 2: Out-of-the-money call option where stock price is less than strike price
SELECT * FROM black_scholes_option_price(90, 100, 1, 0.05, 0.2);

-- Test Case 3: In-the-money put option where stock price is greater than strike price
SELECT * FROM black_scholes_option_price(110, 100, 1, 0.05, 0.2);

-- Test Case 4: Option with a long time until expiration
SELECT * FROM black_scholes_option_price(100, 100, 5, 0.05, 0.2);

-- Test Case 5: Option with high volatility
SELECT * FROM black_scholes_option_price(100, 100, 1, 0.05, 0.5);
