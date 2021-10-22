include("network_project.jl")
include("Provided_Parameters.jl")

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

# Merged function for mean in_park, proportion of jobs in orbit

function do_experiment_long(scenario::NetworkParameters, λ::Float64
    ; warm_up_time = 10.0^3, # change back to 10.0^5
    max_time = 10.0^5,       # change back to 10.0^7
    record = "moving")       # specify what are recording, options are "moving" or "in_park"

    orbiting = 0.0
    total = 0.0
    total_inpark_integral = 0.0
    last_time = 0.0
    init_queues = fill(0, scenario.L)

    # function to record mean number in park
    function record_in_park(time::Float64, state::NetworkState) 
        (time ≥ warm_up_time) && (total_inpark_integral += state.in_park*(time-last_time)) #Use a warmup time
        last_time = time
        return nothing
    end

    # function to record proportion moving
    function record_prop_moving(time::Float64, state::NetworkState) 
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
    do_sim(NetworkState(init_queues, 0, 0, 0, 0, 0, 0, scenario), 
        TimedEvent(ExternalArrivalEvent(),0.0), λ = λ, max_time = max_time, warm_up_time = warm_up_time, call_back = call_back)
    
    # return appropriate statistics
    (call_back == record_in_park) && (return total_inpark_integral/max_time, scenario)
    (call_back == record_prop_moving) && (return orbiting/total, scenario)
end


@show scenario1

lambda_values = collect(0.0:0.5:10.0)
for i in lambda_values
    println("With lambda = ", i)
    Random.seed!(0)
    in_park, scenario = do_experiment_long(scenario1, i, record = "in_park") 
    println("Scenario 1 mean number of jobs in park: ", in_park)
    Random.seed!(0)
    moving, scenario = do_experiment_long(scenario1, i, record = "moving")
    println("Scenario 1 proportion of jobs moving: ", moving)

    Random.seed!(0)
    in_park, scenario = do_experiment_long(scenario2, i, record = "in_park") 
    println("Scenario 2 mean number of jobs in park: ", in_park)
    Random.seed!(0)
    moving, scenario = do_experiment_long(scenario2, i, record = "moving")
    println("Scenario 2 proportion of jobs moving: ", moving)

    Random.seed!(0)
    in_park, scenario = do_experiment_long(scenario3, i, record = "in_park") 
    println("Scenario 3 mean number of jobs in park: ", in_park)
    Random.seed!(0)
    moving, scenario = do_experiment_long(scenario3, i, record = "moving")
    println("Scenario 3 proportion of jobs moving: ", moving)

    Random.seed!(0)
    in_park, scenario = do_experiment_long(scenario4, i, record = "in_park") 
    println("Scenario 4 mean number of jobs in park: ", in_park)
    Random.seed!(0)
    moving, scenario = do_experiment_long(scenario4, i, record = "moving")
    println("Scenario 4 proportion of jobs moving: ", moving)

    Random.seed!(0)
    in_park, scenario = do_experiment_long(scenario5, i, record = "in_park") 
    println("Scenario 5 mean number of jobs in park: ", in_park)
    Random.seed!(0)
    moving, scenario = do_experiment_long(scenario5, i, record = "moving")
    println("Scenario 5 proportion of jobs moving: ", moving)
end


# DELETE code below submission of Proj2
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
#=
function do_experiment_long(scenario::NetworkParameters
        ; warm_up_time = 10.0^3, # change back to 10.0^5
        max_time = 10.0^5)     # change back to 10.0^7

        orbiting = 0.0
        total = 0.0
        last_time = 0.0

    # function to record mean number in queues
    function record_integral(time::Float64, state::NetworkState) 
        if state.in_park > 0
            (time ≥ warm_up_time) && (orbiting += (state.move)*(time-last_time))
            (time ≥ warm_up_time) && (total += (state.in_park)*(time-last_time))
        end
        last_time = time
        return nothing
    end

    init_queues = fill(0, scenario.L)
    do_sim(NetworkState(init_queues, 0, 0, 0, 0, 0, 0, scenario), 
        TimedEvent(ExternalArrivalEvent(),0.0), max_time = max_time, call_back = record_integral)
    orbiting/total, scenario
end
=#


# below code has errors
# lambda = append!(collect(0.0:0.2:3.0), collect(4.0:1.0:10.0))
#=
lambda = collect(1.0:1.0:2.0)
for i in lambda
    Random.seed!(0)
    in_park, scenario = do_experiment_long(scenario1, record = "in_park")
    println("Scenario 1 mean number of jobs in park for λ is", i, ": ", in_park)
    #Random.seed!(0)
    #moving, scenario = do_experiment_long(scenario1, record = "moving")
    #println("Scenario 1 proportion of jobs moving: ", moving)
end
=#

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
