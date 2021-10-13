using DataStructures
import Base: isless

abstract type Event end
abstract type State end

#Captures an event and the time it takes place
struct TimedEvent
    event::Event
    time::Float64
end

#Comparison of two timed events - this will allow us to use them in a heap/priority-queue
isless(te1::TimedEvent,te2::TimedEvent) = te1.time < te2.time

#This is an abstract function 
"""
It will generally be called as 
       new_timed_events = process_event(time, state, event)
It will generate 0 or more new timed events based on the current event
"""
function process_event end

#Generic events that we can always use
struct EndSimEvent <: Event end
struct LogStateEvent <: Event end

function process_event(time::Float64, state::State, es_event::EndSimEvent)
    println("Ending simulation at time $time.")
    return []
end

function process_event(time::Float64, state::State, ls_event::LogStateEvent)
    println("Logging state at time $time.")
    println(state)
    return []
end;

"""
The main simulation function gets an initial state and an initial event that gets things going.
Optional arguments are the maximal time for the simulation, times for logging events, and a call back function.
"""
function do_sim(init_state::State, init_timed_event::TimedEvent
                    ; 
                    max_time::Float64 = 10.0, 
                    log_times::Vector{Float64} = Float64[],
                    call_back = (time,state) -> nothing)

    #The event queue
    priority_queue = BinaryMinHeap{TimedEvent}()

    #Put the standard events in the queue
    push!(priority_queue, init_timed_event)
    push!(priority_queue, TimedEvent(EndSimEvent(),max_time))
    for lt in log_times
        push!(priority_queue,TimedEvent(LogStateEvent(),lt))
    end

    #initilize the state
    state = deepcopy(init_state)
    time = 0.0

    call_back(time,state)

    #The main discrete event simulation loop - SIMPLE!
    while true
        #Get the next event
        timed_event = pop!(priority_queue)

        #advance the time
        time = timed_event.time

        #Act on the event
        new_timed_events = process_event(time, state, timed_event.event) 

        #if the event was an end of simulation then stop
        isa(timed_event.event, EndSimEvent) && break 

        #The event may spawn 0 or more events which we put in the priority queue 
        for nte in new_timed_events
            push!(priority_queue,nte)
        end

        call_back(time,state)
    end
end;