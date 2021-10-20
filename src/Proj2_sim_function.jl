"""
The main simulation function gets an initial state and an initial event
that gets things going. Optional arguments are the maximal time for the
simulation, times for logging events, and a call-back function.
"""
function do_sim(init_state::State, init_timed_event::TimedEvent
                    ; 
                    max_time::Float64 = 10.0, 
                    log_times::Vector{Float64} = Float64[],
                    callback = (time, state) -> nothing)

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
    callback(time, state)

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
        callback(time, state)
    end
end

scenario1 = NetworkParameters(  L=3, 
                                gamma_scv = 3.0, 
                                λ = 1.0, 
                                η = 4.0, 
                                μ_vector = ones(3),
                                P = [0 1.0 0;
                                    0 0 1.0;
                                    0 0 0],
                                Q = zeros(3,3),
                                p_e = [1.0, 0, 0],
                                K = fill(5,3))
@show scenario1
init_queues = fill(0,scenario1.L)
test = NetworkState(init_queues, 0, 0, 0, 0, 0, scenario1)
@show test
typeof(test)


"""
    Function to run the simulation and records a full trajectory
"""
function do_experiment_traj(;n=10, max_time = 100.0, scv = 3.0, λ = 1.0, μ_possibilities = [1.05, 2.0, 3.0, 4.0])

    time_traj, queues_traj = Float64[], Vector{Int}[]

    function record_traj(time::Float64, state::NetworkState)
        #println("time = $time, $(state.queues)")
        push!(time_traj, time)
        push!(queues_traj, copy(state.queues))
        return nothing
    end

    pars = scenario1
    init_queues = fill(0, scenario1.L)
    do_sim(NetworkState(init_queues, 0, 0, 0, 0, 0, scenario1), TimedEvent(ExternalArrivalEvent(),0.0), max_time = max_time, callback = record_traj)
    time_traj, queues_traj, pars
end

using Random
Random.seed!(0)
time, traj, pars = do_experiment_traj()