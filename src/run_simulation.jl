include("network_project.jl")
include("Provided_Parameters.jl")

"""
The main simulation function gets an initial state and an initial event
that gets things going. Optional arguments are the maximal time for the
simulation, times for logging events, and a call-back function.
"""
function do_sim(init_state::State, init_timed_event::TimedEvent
                    ; 
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

#=
"""
    Function to run the simulation and records a full trajectory
"""
function do_experiment_traj(;n=10, 
                            max_time = 10.0^7, 
                            scv = 3.0, 
                            λ = 1.0, 
                            μ_possibilities = [1.05, 2.0, 3.0, 4.0])

    time_traj, queues_traj = Float64[], Vector{Int}[]

    pars = scenario1
    init_queues = fill(0, scenario1.L)
    do_sim(NetworkState(init_queues, 0, 0, 0, 0, 0, 0, scenario1), TimedEvent(ExternalArrivalEvent(),0.0), max_time = max_time, call_back = record_traj)
    time_traj, queues_traj, pars
end

using Random
Random.seed!(0)
time, traj, pars = do_experiment_traj()
=#

#=
#This function runs a long simulation with warm up time, and records integral of queues
function do_experiment_long(scenario::NetworkParameters
                            ; warm_up_time = 10.0^5, # change back to 10.0^5
                            max_time = 10.0^7)     # change back to 10.0^7

    queues_integral = zeros(scenario.L)
    last_time = 0.0

    # function to record mean number in queues
    function record_integral(time::Float64, state::NetworkState) 
        (time ≥ warm_up_time) && (queues_integral += state.queues*(time-last_time)) #Use a warmup time
        last_time = time
        return nothing
    end

    init_queues = fill(0, scenario.L)
    do_sim(NetworkState(init_queues, 0, 0, 0, 0, 0, 0, scenario), 
        TimedEvent(ExternalArrivalEvent(),0.0), max_time = max_time, call_back = record_integral)
    queues_integral/max_time, scenario
end
=#

#=
#This function runs a long simulation with warm up time, and records integral of number of items in park
function do_experiment_long(scenario::NetworkParameters
        ; warm_up_time = 10.0^5, # change back to 10.0^5
        max_time = 10.0^7)     # change back to 10.0^7

    total_inpark__integral = 0.0
    last_time = 0.0

    # function to record mean number in queues
    function record_integral(time::Float64, state::NetworkState) 
        (time ≥ warm_up_time) && (total_inpark__integral += state.in_park*(time-last_time)) #Use a warmup time
        last_time = time
        return nothing
    end

    init_queues = fill(0, scenario.L)
    do_sim(NetworkState(init_queues, 0, 0, 0, 0, 0, 0, scenario), 
        TimedEvent(ExternalArrivalEvent(),0.0), max_time = max_time, call_back = record_integral)
    total_inpark__integral/max_time, scenario
end
=#

#  Function v2 for calc integral of move - checking using piazza suggestion below
#This function runs a long simulation with warm up time, and records integral of move
#https://piazza.com/class/kr355m6ajl25er?cid=407

function do_experiment_long(scenario::NetworkParameters
        ; warm_up_time = 10.0^5, # change back to 10.0^5
        max_time = 10.0^7)     # change back to 10.0^7

        orbiting = 0.0
        total = 0.0
        last_time = 0.0

    # function to record mean number in queues
    function record_integral(time::Float64, state::NetworkState) 
        (time ≥ warm_up_time) && (orbiting += state.move*(time-last_time))
        (time ≥ warm_up_time) && (total += state.in_park*(time-last_time))
        last_time = time
        return nothing
    end

    init_queues = fill(0, scenario.L)
    do_sim(NetworkState(init_queues, 0, 0, 0, 0, 0, 0, scenario), 
        TimedEvent(ExternalArrivalEvent(),0.0), max_time = max_time, call_back = record_integral)
    orbiting/total, scenario
end

# with lambda = 0.75 - see Provided_Parameters
println("With lambda = 0.75: ")
Random.seed!(0)
integral1, pars1 = do_experiment_long(scenario1)
println("Scenario 1 park move integrals: ", integral1)
Random.seed!(0)
integral2, pars2 = do_experiment_long(scenario2)
println("Scenario 2 park move integrals: ", integral2)
Random.seed!(0)
integral3, pars3 = do_experiment_long(scenario3)
println("Scenario 3 park move integrals: ", integral3)
Random.seed!(0)
integral4, pars4 = do_experiment_long(scenario4)
println("Scenario 4 park move integrals: ", integral4) 
Random.seed!(0)
integral5, pars5 = do_experiment_long(scenario5)
println("Scenario 5 park move integrals: ", integral5)



# DELETE below code before submission of Project2

# Do NOT use function v1
#=  Function v1 for calc integral of move - checking below using v2 from piazza suggestion
#This function runs a long simulation with warm up time, and records integral of move
function do_experiment_long(scenario::NetworkParameters
        ; warm_up_time = 10.0^5, # change back to 10.0^5
        max_time = 10.0^7)     # change back to 10.0^7

        move_integral = 0.0
        last_time = 0.0

    # function to record mean number in queues
    function record_integral(time::Float64, state::NetworkState) 
        if state.in_park > 0
            (time ≥ warm_up_time) && (move_integral += (state.move/state.in_park)*(time-last_time))
        end
        last_time = time
        return nothing
    end

    init_queues = fill(0, scenario.L)
    do_sim(NetworkState(init_queues, 0, 0, 0, 0, 0, 0, scenario), 
        TimedEvent(ExternalArrivalEvent(),0.0), max_time = max_time, call_back = record_integral)
    move_integral/max_time, scenario
end
=#
