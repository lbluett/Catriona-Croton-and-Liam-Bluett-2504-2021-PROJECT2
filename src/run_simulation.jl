include("mode1.jl")
include("Provided_Parameters.jl")

# Code to create and save plots for scenarios 1 to 5, for the first two plots for each
#=
p1a = plot_stats(scenario1, "Scenario 1", "in_park", lambda_lower_bound = 0.01, lambda_upper_bound = 5.01, step = 0.2)
p1b = plot_stats(scenario1, "Scenario 1", "moving", lambda_lower_bound = 0.01, lambda_upper_bound = 5.01, step = 0.2)
plot!(p1a, p1b, size=(800, 400), legend=:none, margin=5mm)
savefig("./plots/scenario1_plot1_plot2.png")

p2a = plot_stats(scenario2, "Scenario 2", "in_park", lambda_lower_bound = 0.01, lambda_upper_bound = 5.01, step = 0.2)
p2b = plot_stats(scenario2, "Scenario 2", "moving", lambda_lower_bound = 0.01, lambda_upper_bound = 5.01, step = 0.2)
plot!(p2a, p2b, size=(800, 400), legend=:none, margin=5mm)
savefig("./plots/scenario2_plot1_plot2.png")

p3a = plot_stats(scenario3, "Scenario 3", "in_park", lambda_lower_bound = 0.01, lambda_upper_bound = 8.01, step = 0.2)
p3b = plot_stats(scenario3, "Scenario 3", "moving", lambda_lower_bound = 0.01, lambda_upper_bound = 8.01, step = 0.2)
plot!(p3a, p3b, size=(800, 400), legend=:none, margin=5mm)
savefig("./plots/scenario3_plot1_plot2.png")

p4a = plot_stats(scenario4, "Scenario 4", "in_park", lambda_lower_bound = 0.01, lambda_upper_bound = 1.01, step = 0.01)
p4b = plot_stats(scenario4, "Scenario 4", "moving", lambda_lower_bound = 0.01, lambda_upper_bound = 1.01, step = 0.01)
plot!(p4a, p4b, size=(800, 400), legend=:none, margin=5mm)
savefig("./plots/scenario4_plot1_plot2.png")

p5a = plot_stats(scenario5, "Scenario 5", "in_park", lambda_lower_bound = 0.01, lambda_upper_bound = 10.01, step = 0.2)
p5b = plot_stats(scenario5, "Scenario 5", "moving", lambda_lower_bound = 0.01, lambda_upper_bound = 10.01, step = 0.2)
plot!(p5a, p5b, size=(800, 400), legend=:none, margin=5mm)
savefig("./plots/scenario5_plot1_plot2.png")
=#
