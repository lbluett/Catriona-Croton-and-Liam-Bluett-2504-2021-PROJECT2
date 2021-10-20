# Process events

"""
    new_timed_events = process_event(time, state, event)

Generate an array of 0 or more new `TimedEvent`s based on the current `event` and `state`.
"""
function process_event end # This defines a function with zero methods

"""
    EndSimEvent()
Return an event that ends the simulation.
"""
function process_event(time::Float64, state::State, es_event::EndSimEvent)
    println("Ending simulation at time $time.")
    return []
end

"""
    LogStateEvent()
Return an event that prints a log of the current simulation state.
"""
function process_event(time::Float64, state::State, ls_event::LogStateEvent)
    println("Logging state at time $time.")
    println(state)
    return []
end


"""
    ExternalArrivalEvent()
    For processing external arrivals to the park
    Returns the next external arrival and a QueueArrivalEvent to arrive at a queue according to vector p_e
"""
function process_event(time::Float64, state::State, park_arrival_event::ExternalArrivalEvent)
    state.in_park += 1   # add one to the counter for number in park
    new_timed_events = TimedEvent[]   # initialise empty array to store nte generated by function
    
    # create event that is the next External Arrival Event to add to the event schedule
    push!(new_timed_events,TimedEvent(ExternalArrivalEvent(), time + next_park_arrival_time(state)))
    
    # determine which queue the external arrival will join, which happens instantly (current time)
    # which queue the external arrival joins is determined by p_e matrix
    q = external_arrival_function(state.params.L, state.params.p_e)  # CHECK
    push!(new_timed_events,TimedEvent(QueueArrivalEvent(q), time))   # CHECK

    return new_timed_events
end


"""
    QueueArrivalEvent()
    For processing queue arrivals
    Adds one to the queue q
    If is the only job in the queue, then engage service and create a EndOfServiceEvent
"""
function process_event(time::Float64, state::State, queue_arrival_event::QueueArrivalEvent)
    state.number_in_queue += 1        # Increase number in queue by one using the counter
    state.queues[q] += 1              # add one to this queue
    q = queue_arrival_event.q         # store which queue this is for
    new_timed_events = TimedEvent[]

    #if this is the only job on the server engage service, and remove from queue
    if state.queues[q] == 1
        push!(new_timed_events, TimedEvent(EndOfServiceAtQueueEvent(q), time + next_service_time(state,q)))
        state.number_in_queue -= 1
        state.queues[q] -= 1
    end

    # if the queue is full when arrives, then overflow immediately
    if state.queues[q] > state.K[q]      # if the number in the queue is now greater than capacity
        push!(new_timed_events, TimedEvent(OverflowEvent(q), time))
        state.number_in_queue -= 1
        state.queues[q] -= 1
    end

    return new_timed_events
end


"""
    EndOfServiceAtQueueEvent()
    For processing end of service in queue number q
    Create new end of service event if more than one in the queue
    The job will move to another queue or overflow according to routing matrix P, row q
"""

function process_event(time::Float64, state::State, eos_event::EndOfServiceAtQueueEvent)
    q = eos_event.q              # record what queue the event is for
    new_timed_events = TimedEvent[]

    #if another customer in the queue then start a new service
    if state.queues[q] ≥ 1
        push!(new_timed_events, TimedEvent(EndOfServiceAtQueueEvent(q), time + next_service_time(state, q)))
        state.queues[q] -= 1         # remove one fom the appropriate queue
        state.number_in_queue -= 1   # remove one job from queue counter
        @assert state.number_in_queue ≥ 0
        @assert state.queues[q] ≥ 0
    end

    # determine if this job is moving or leaving using matrix P, row q
    q_move_to = routing_function(q, state.params.Q)
    # if moving to a queue, then create new event that is when arrives at the queue and add to the moving counter
    if q_move_to <= state.params.L
        push!(new_timed_events, TimedEvent(QueueArrivalEvent(q_move_to), time + moving_time(state)))
        state.move += 1
    # otherwise if not chosen a queue (if L+1), then leave
    else
        push!(new_timed_events, TimedEvent(LeaveParkEvent(), time))
    end

    return new_timed_events
end


"""
    OverflowEvent()
    For processing overflow event
    The job will move to another queue or leave according to overflow matrix Q, row q
"""
function process_event(time::Float64, state::State, overflow_event::OverflowEvent)
    q = overflow_event.q              # record what queue the event is for
    state.overflow += 1
    new_timed_events = TimedEvent[]

    # determine if this job is moving or leaving using matrix Q, row q
    q_move_to = routing_function(q, state.params.Q)
    # if moving to a queue, then create new event that is when arrives at the queue and add to the moving counter
    if q_move_to <= state.params.L
        push!(new_timed_events, TimedEvent(QueueArrivalEvent(q_move_to), time + moving_time(state)))
        state.move += 1
    # otherwise if not chosen a queue (if L+1), then leave
    else
        push!(new_timed_events, TimedEvent(LeaveParkEvent(), time))
    end

    return new_timed_events 
end

"""
    LeaveParkEvent()
"""
function process_event(time::Float64, state::State, leave_event::LeaveParkEvent)
    state.in_park -= 1
    state.left += 1
end
