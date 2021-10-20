# set up the events for the Park

# create the overall abstract type event
abstract type Event end

# create the necessary events
struct ExternalArrivalEvent <: Event end
struct LeaveParkEvent <: Event end
struct LogStateEvent <: Event end
struct EndSimEvent <: Event end

struct QueueArrivalEvent <: Event
    q::Int # the index of the queue where service started
end

struct StartServiceEvent <: Event
    q::Int #The index of the queue where service started
end

struct EndOfServiceAtQueueEvent <: Event
    q::Int #The index of the queue where service finished
end

struct OverflowEvent <: Event
    q::Int # The index of the queue where overflowed
end

# create struct for timed event
struct TimedEvent
    event::Event
    time::Float64
end

# Comparison of two timed events - this will allow us to use them in a heap/priority-queue
isless(te1::TimedEvent, te2::TimedEvent) = te1.time < te2.time
