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

    QueueArrivalEvent()

"""
function process_event(time::Float64, state::State, ::QueueArrivalEvent)
    # Increase number in system
    state.number_in_queue += 1
    new_timed_events = TimedEvent[]

    # Prepare next arrival - OLD CODE
    # NEW CODE - arrival to queue will be determined by park arrival, moving after service, overflow
    #push!(new_timed_events,TimedEvent(ArrivalEvent(),time + rand(Exponential(1/λ))))

    # If this is the only job on the server
    state.number_in_queue == 1 && push!(new_timed_events,TimedEvent(EndOfServiceEvent(), time + servicefunction()))
    return new_timed_events
end

"""

    EndOfServiceAtQueueEvent()

"""
function process_event(time::Float64, state::State, ::EndOfServiceAtQueueEvent)
    # Release a customer from the system
    state.number_in_queue -= 1 
    @assert state.number_in_queue ≥ 0
    return state.number_in_queue ≥ 1 ? [TimedEvent(EndOfServiceAtQueueEvent(), time + servicefunction())] : TimedEvent[]
end

"""
    ExternalArrivalEvent()
"""
function process_event(time::Float64, state::State, ::ExternalArrivalEvent)
    #ADD
    #return ADD
end

"""
    OverflowEvent()
"""
function process_event(time::Float64, state::State, ::OverflowEvent)
    #ADD
    #return ADD
end

"""
    LeaveParkEvent()
"""
function process_event(time::Float64, state::State, ::LeaveParkEvent)
    #ADD
    #return ADD
end
