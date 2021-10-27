include("mode1.jl")
include("mode2.jl")
include("plot_all.jl")
include("Provided_Parameters.jl")

plot_all(scenario1, "Scenario 1")
plot_all(scenario2, "Scenario 2", 
    xGrid_upper = 50.0)
plot_all(scenario3, "Scenario 3", 
    stats_lambda_lower_bound = 0.01, stats_lambda_upper_bound = 8.01, stats_lambda_step = 0.5,
    times_lambda_lower_bound = 2.0, times_lambda_upper_bound = 8.0, times_lambda_step = 2.0,
    xGrid_upper = 50.0)
plot_all(scenario4, "Scenario 4", 
    stats_lambda_lower_bound = 0.01, stats_lambda_upper_bound = 0.91, stats_lambda_step = 0.1,
    times_lambda_lower_bound = 0.1, times_lambda_upper_bound = 0.9, times_lambda_step = 0.2, 
    xGrid_step = 4.0, xGrid_upper = 200.0)
plot_all(scenario5, "Scenario 5",
    stats_lambda_lower_bound = 0.01, stats_lambda_upper_bound = 12.01, stats_lambda_step = 0.5,
    times_lambda_lower_bound = 2.0, times_lambda_upper_bound = 12.0, times_lambda_step = 2.0,
    xGrid_upper = 20.0)
