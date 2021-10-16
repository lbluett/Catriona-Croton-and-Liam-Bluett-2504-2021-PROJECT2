using Distributions, StatsBase, DataStructures
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


# Setup the Structs (state and event) here

struct ParkParameters
    L::Int
    gamma_scv::Float64 #This is constant for all scenarios at 3.0
    λ::Float64 #This is undefined for the scenarios since it is varied
    η::Float64 #This is assumed constant for all scenarios at 4.0
    μ_vector::Vector{Float64} #service rates
    P::Matrix{Float64} #routing matrix
    Q::Matrix{Float64} #overflow matrix
    p_e::Vector{Float64} #external arrival distribution
    K::Vector{Int} #-1 means infinity 
end

mutable struct ParkState <: State
    station_queues::Vector{Int} # Should be initialized to zeros[L]
    params::ParkParameters
    total_inside::Int # Counter, counts the total number of people in the system.
    # TOTAL PEOPLE COUNT - STATION QUEUES SUM = PEOPLE ORBITTING
    # Perhaps initialising an array of size L to indicate the number of people in each queue.
    
end

#Generic events that we can always use
struct EndSimEvent <: Event end
struct LogStateEvent <: Event end

#Arrives, goes into random queue based on p_e.
struct ExternalArrivalEvent <: Event
end
struct EndOfServiceAtQueueEvent <: Event
    q::Int # Represents the finished end of service position.
end


"""
A convenience function to make a Gamma distribution with desired rate (inverse of shape) and SCV.
"""
rate_scv_gamma(desired_rate::Float64, desired_scv::Float64) = Gamma(1/desired_scv, desired_scv/desired_rate)

next_arrival_time(s::State) = rand(rate_scv_gamma(s.params.λ, s.params.gamma_scv)) # Cat, could you verify the mathematical validity of the parameters? I think it's right.
next_service_time(s::State, q::Int) = rand(rate_scv_gamma(s.params.μ_array[q], s.params.gamma_shape))
moving_time(s::State, q::Int) = rand(rate_scv_gamma(s.params.η, s.params.gamma_shape));

function process_event(time::Float64, state::State, es_event::EndSimEvent)
    println("Ending simulation at time $time.")
    return []
end

function process_event(time::Float64, state::State, ls_event::LogStateEvent)
    println("Logging state at time $time.")
    println(state)
    return []
end;

function process_event(time::Float64, state::State, arrival_event::ExternalArrivalEvent)
    #draw from p
    state.station_queues[p] += 1
end

"""
    EndOfServiceAtQueueEvent()
"""
function process_event(time::Float64, state::State, ::EndOfServiceAtQueueEvent)
    NetworkState.moving += 1 # add one to the moving counter
    new_timed_events = TimedEvent[]
    
    # Release a customer from the system
    state.number_in_queue -= 1 
    @assert state.number_in_queue ≥ 0
    return state.number_in_queue ≥ 1 ? [TimedEvent(EndOfServiceAtQueueEvent(), time + servicefunction())] : TimedEvent[]
end


#### Helper functions ####
function external_arrival_function(L::Int, p_e::Vector)
    return sample(1:L, weights(p_e))
end

function routing_function(l::Int, Q::Matrix{Float64})
    return sample(1:L+1, weights(Q[l, :].push!(1 - +(Q[l, :]))))
    
end
############################

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

P = [0 1.0 0;
0 0 1.0;
0 0 0]
scenario1 = ParkParameters(3, 3.0, NaN, 4.0, ones(3), P, zeros(3,3),[1, 0, 0], fill(5,3))
external_arrival_function(scenario1.L, scenario1.p_e)      
#=
struct ParkParameters
    L::Int
    gamma_scv::Float64 #This is constant for all scenarios at 3.0
    λ::Float64 #This is undefined for the scenarios since it is varied
    η::Float64 #This is assumed constant for all scenarios at 4.0
    μ_vector::Vector{Float64} #service rates
    P::Matrix{Float64} #routing matrix
    Q::Matrix{Float64} #overflow matrix
    p_e::Vector{Float64} #external arrival distribution
    K::Vector{Int} #-1 means infinity 
end
=#