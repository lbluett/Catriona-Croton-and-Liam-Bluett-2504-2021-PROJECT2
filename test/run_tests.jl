include("../src/network_project.jl")

include("station_allocation_tests.jl")
arrival_distribution_test()
arrival_distribution_test2()

routing_matrix_test()
overflow_matrix_test()

include("event_time_tests.jl")
# To write, wasted a lot of time tonight, sorry!
