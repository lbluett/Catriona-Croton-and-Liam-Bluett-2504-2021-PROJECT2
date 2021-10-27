using DataStructures, Distributions, StatsBase, Random, Plots, Parameters, LinearAlgebra
using Base: Float64
import Base: isless

include("mode2_network_structs.jl")
include("network_functions.jl")
include("mode2_process_events.jl")

"""
The main simulation function gets an initial state and an initial event
that gets things going. Optional arguments are the λ, maximal time for the
simulation, times for logging events, and a call-back function.
"""
function do_sim(init_state::State, init_timed_event::TimedEvent
                    ; 
                    λ = 10.0,
                    warm_up_time::Float64 = 10.0^2,  # change default to 10.0^5
                    max_time::Float64 = 10.0^3,      # change default to 10.0^7
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

    # Callback at simulation start
    call_back(time, state)

    # set lambda
    state.params.λ = λ
    # state parameters already contain sojourn time
    
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
    return state.sojourn_times
end

"""
    Function to record the sojourn times 
    This function runs a long simulation with warm up time, and records integral of move
"""
function do_experiment_long(scenario::NetworkParameters, λ::Float64; 
    warm_up_time = 10.0^2,   # change back to 10.0^5
    max_time = 10.0^3)       # change back to 10.0^7

    init_queues = []
    for _ in 1:scenario.L
        push!(init_queues, Queue{Int}())
    end

    #init_queues = fill(Queue{Int}(), scenario.L) pointing to the same queue
    empty_dict = Dict()
    sojourn_array = Float64[]
    
    Random.seed!(0)
    sojourn_times = do_sim(Mode2NetworkState(init_queues, 0, empty_dict, 0, sojourn_array, 0, scenario), 
            TimedEvent(Mode2ExternalArrivalEvent(),0.0), λ = λ, max_time = max_time)
    return sojourn_times
end


"""
    Function to plot the sojourn times 
    - mandatory arguments are the scenario, and the title of the plot
    - optional named arguments are to specify the upper and lower bound of λ, with a step
"""
function plot_times(scenario::NetworkParameters, title::String;
    lambda_lower_bound = 1.0, 
    lambda_upper_bound = 5.0, 
    lambda_step = 1.0,
    xGrid_step = 1.0,
    xGrid_upper = 30.0)

    lambda_values = collect(lambda_lower_bound:lambda_step:lambda_upper_bound)
    xGrid = 0.0:xGrid_step:xGrid_upper

    # to calculate and plot values
    data_collection = [do_experiment_long(scenario, lambda) for lambda in lambda_values]
    ecdfs = ecdf.(data_collection)
    plot_test = plot(xGrid, 
            hcat([df.(xGrid) for df in ecdfs]...),
            title = title,
            ylabel = "Cumulative Probability",
            xlabel = "Sojourn Time",
            ylims = (0, 1.0),
            label = permutedims(lambda_values[:,:]),
            legendtitle = "λ Values",
            legendtitlefontsize = 9,
            legend = :bottomright)
    return plot_test
end