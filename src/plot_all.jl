"""
plot_all()
Function to create and save plots for both mode 1 and mode 2
"""
function plot_all(scenario::NetworkParameters, name::String;
        stats_lambda_lower_bound = 0.01, stats_lambda_upper_bound = 5.01, stats_lambda_step = 0.2,
        times_lambda_lower_bound = 1.0, times_lambda_upper_bound = 5.0, times_lambda_step = 1.0,
        xGrid_step = 0.1, xGrid_upper = 30.0)

    # plot the mean number in park, prop orbiting and empirical CDF and save
    p1 = plot_stats(scenario, string(name, " Mean Number in Park"), "in_park", 
        lambda_lower_bound = stats_lambda_lower_bound, lambda_upper_bound = stats_lambda_upper_bound, lambda_step = stats_lambda_step)
    p2 = plot_stats(scenario, string(name, " Proportion Orbiting"), "moving", 
        lambda_lower_bound = stats_lambda_lower_bound, lambda_upper_bound = stats_lambda_upper_bound, lambda_step = stats_lambda_step)
    p3 = plot_times(scenario, string("Empirical CDF for Sojourn Times for ", name), 
        lambda_lower_bound = times_lambda_lower_bound, lambda_upper_bound = times_lambda_upper_bound, lambda_step = times_lambda_step, 
        xGrid_step = xGrid_step, xGrid_upper = xGrid_upper)

    # plot the stats and the times and save in 2 files
    plot!(p1, p2, size=(800, 400), margin=5mm)
    file_name = join(strip.(split(name)))
    savefig(string("./", file_name, "_stats.png"))
    plot(p3)
    savefig(string("./", file_name, "_times.png"))
end
