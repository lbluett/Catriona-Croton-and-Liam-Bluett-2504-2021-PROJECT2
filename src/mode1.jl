#############################################################################
#
# This is the main project file for park simulation setup for mode 1
#                                                                               
#############################################################################
#############################################################################

using DataStructures, Distributions, StatsBase, Random, Plots, Parameters, LinearAlgebra, Measures
using Base: Float64
import Base: isless

include("mode1_network_structs.jl")
include("network_functions.jl")
include("mode1_process_events.jl")

"""
The main simulation function gets an initial state and an initial event
that gets things going. Optional arguments are the maximal time for the
simulation, times for logging events, and a call-back function.
"""
function do_sim(init_state::State, init_timed_event::TimedEvent
                    ; 
                    λ = 5.0,
                    warm_up_time::Float64 = 10.0^5,  # change default to 10.0^5
                    max_time::Float64 = 10.0^7,      # change default to 10.0^7
                    log_times::Vector{Float64} = Float64[],
                    call_back = (time, state) -> nothing)

    # The event queue
    priority_queue = BinaryMinHeap{TimedEvent}()

    # Put the standard events in the queue
    push!(priority_queue, init_timed_event)
    push!(priority_queue, TimedEvent(EndSimEvent(), max_time))
    for log_time in log_times
        push!(priority_queue, TimedEvent(LogStateEvent(), log_time))
    end

    # initilize the state
    state = deepcopy(init_state)
    time = 0.0

    # set lambda
    state.params.λ = λ

    # Callback at simulation start
    call_back(time, state)

    # The main discrete event simulation loop
    while true
        # Get the next event
        timed_event = pop!(priority_queue)

        # Advance the time
        time = timed_event.time

        # Act on the event
        new_timed_events = process_event(time, state, timed_event.event) 

        # If the event was an end of simulation then stop
        if timed_event.event isa EndSimEvent
            break 
        end

        # The event may spawn 0 or more events which we put in the priority queue 
        for nte in new_timed_events
            push!(priority_queue,nte)
        end

        # Callback for each simulation event
        call_back(time, state)
    end
end

"""
Function to calculate the Park statistics
The statistics calculated can be either:
- mean number of jobs in the park, in which case use record is "in_park"
- proportion of jobs in orbit in the park (number in orbit/total in park), and use record is "moving"
"""
function do_experiment_long(scenario::NetworkParameters, λ::Float64, record::String;
    warm_up_time = 10.0^3, # change back to 10.0^5
    max_time = 10.0^5)      # change back to 10.0^7

    orbiting = 0.0
    total = 0.0
    total_inpark_integral = 0.0
    last_time = 0.0
    init_queues = fill(0, scenario.L)

    # function to record mean number in park
    function record_in_park(time::Float64, state::Mode1NetworkState) 
        (time ≥ warm_up_time) && (total_inpark_integral += state.in_park*(time-last_time)) #Use a warmup time
        last_time = time
        return nothing
    end

    # function to record proportion moving
    function record_prop_moving(time::Float64, state::Mode1NetworkState) 
        if state.in_park > 0
            (time ≥ warm_up_time) && (orbiting += (state.move)*(time-last_time))
            (time ≥ warm_up_time) && (total += (state.in_park)*(time-last_time))
        end
        last_time = time
        return nothing
    end

    # specify which call back function
    (record == "in_park") && (call_back = record_in_park)
    (record == "moving") && (call_back = record_prop_moving)

    # run the simulation
    do_sim(Mode1NetworkState(init_queues, 0, 0, 0, 0, 0, 0, 0, scenario), 
        TimedEvent(ExternalArrivalEvent(),0.0), λ = λ, max_time = max_time, warm_up_time = warm_up_time, call_back = call_back)
    
    # return appropriate statistics
    (call_back == record_in_park) && (return total_inpark_integral/max_time, scenario)
    (call_back == record_prop_moving) && (return orbiting/total, scenario)
end

"""
Function to plot the lambda values against the statistics of mean number in park and proportion orbiting jobs in park
"""
function plot_stats(scenario::NetworkParameters, title::String, record::String; 
    lambda_lower_bound = 1.0, lambda_upper_bound = 8.0, lambda_step = 0.5)

    lambda_values = collect(lambda_lower_bound:lambda_step:lambda_upper_bound)
    stat_park = []

    # loop to store y values
    for i in lambda_values
        Random.seed!(0)
        each_stat_park, scenario = do_experiment_long(scenario, i, record)
        push!(stat_park, each_stat_park)
    end

    # add the zero values for a neat plot
    if record == "in_park"
        lambda_values = pushfirst!(lambda_values, 0.0)
        stat_park = pushfirst!(stat_park, 0.0)
    end

    # specify the y label
    (record == "in_park") && (ylabel = "Mean Number of Jobs in Park")
    (record == "moving") && (ylabel = "Proportion of Park Jobs Orbiting")

    # specify the y lims
    (record == "in_park") && (ylims = (0, ceil(maximum(stat_park))))
    (record == "moving") && (ylims = (0, 1.0))

    # plot the values
    plot(lambda_values, stat_park, c=:blue, 
        xlabel = "λ Values", 
        ylabel = ylabel,
        title = title,
        titlefontsize = 12,
        xlims = (0, lambda_upper_bound),
        ylims = ylims,
        legend = false)
end
