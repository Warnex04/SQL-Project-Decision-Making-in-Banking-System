# SQL Project: Decision Making in Banking System

## Authors

- Mohammad Baker
- Mohammed Addi

## Project Structure

The project is structured with SQL scripts organized into specific folders that represent different aspects of the decision-making process in a simulated banking system. Each script is named according to the functionality it implements within the system.

## Implementation Details

The project aims to simulate a banking system's decision-making process, particularly for options trading. The simulation includes database schema creation, financial computation algorithms, and automated triggers for dynamic decision-making.

- `model.sql`: Sets up the initial database schema including clients, wallets, options, and stocks.
- `additional_tables.sql`: Adds additional tables required for the project.
- `option_ranking_algo.sql`: Implements the algorithm used to rank options for trading decisions.
- `decision_logic_buying.sql`: Contains logic for making buying decisions.
- `decision_logic_exercise.sql`: Contains logic for deciding when to exercise options.
- `portfolio_update.sql`: Script for updating the client portfolio based on trading decisions.
- `bank_financial_dashboard.sql`: Creates a view for the bank's financial dashboard, reflecting the overall financial position.
- `client_financial_dashboard.sql`: Creates a view for individual client financial dashboards, showing potential gains or losses.
- `auto-decision-making.sql`: Contains automated decision-making processes.
- `decision-making-triggers.sql`: Triggers for executing decision-making processes.
- `monte_carlo.sql`: Implements the Monte Carlo simulation for option pricing.
- `black_schole.sql`: Implements the Black-Scholes model for option pricing.
- `client_stock_view.sql`: Creates a view for clients' stock positions.
- `triggers.sql`: General triggers for database operations.
- Files outside the `decision_making` folder contain appropriate tests at the end if testing is relevant.

## Execution Instructions

Execute the scripts in the following order to replicate the project results:

1. `model.sql`
2. `additional_tables.sql`
3. `option_ranking_algo.sql`
4. `decision_logic_buying.sql`
5. `decision_logic_exercise.sql`
6. `portfolio_update.sql`
7. `bank_financial_dashboard.sql`
8. `client_financial_dashboard.sql`
9. `auto-decision-making.sql`
10. `decision-making-triggers.sql`
11. `monte_carlo.sql`
12. `black_schole.sql`
13. `client_stock_view.sql`
14. `triggers.sql`
15. `tests.sql` - Run this last to test the decision making system.

## Challenges Encountered

Throughout the project, we encountered challenges related to:

- Fitting our diagram to the scope of the project.
- Ensuring the accuracy of financial calculations.
- Division discrepancies.
- Handling edge cases in the decision-making logic.

## Solutions

We addressed these challenges by:

- Thoroughly reviewing financial algorithms.
- Profiling queries and creating necessary indexes.
- Implementing error handling for debugging and extensive test cases.

## Known Issues

- The end-of-day trigger relies on external scheduling, which may not be synchronized with the actual market closing time.
- The `auto-decision-making.sql` is currently set up for a fixed threshold and may not adapt dynamically to market volatility.

## Unimplemented Features and Attempts

We did not implement real-time data fetching due to the project's scope. We experimented with using a web service to pull live stock prices, but it was not integrated into the final submission.
