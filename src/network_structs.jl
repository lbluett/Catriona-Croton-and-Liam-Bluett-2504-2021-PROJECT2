############################
#   Overview structs       #
############################

# struct for general parameters for the park for each scenario

abstract type State end

# Code from Project 2 sheet
@with_kw struct NetworkParameters
    L::Int #The number of queues in the park
    gamma_scv::Float64 #This is constant for all scenarios at 3.0
    λ::Float64 # external arrival rate to the park, undefined for the scenarios since it is varied
    η::Float64 # move rate between stations, assumed constant for all scenarios at 4.0
    μ_vector::Vector{Float64} #service rates for each of the queues
    P::Matrix{Float64} #routing matrix
    Q::Matrix{Float64} #overflow matrix
    p_e::Vector{Float64} #external arrival distribution
    K::Vector{Int} # vector of buffer capacities from each queue, -1 means infinity 
end

# struct for network states
mutable struct NetworkState <: State
    queues::Vector{Int} #vector for the number of customers in each queue, initialize to zeros[L]
    in_park::Int # Counter, counts the total number of people in the system
    number_in_queue::Int # Counter, counts the total number in queues
    move::Int # Counter, number moving between queues
    overflow::Int # Counter, number overflowed
    left::Int # Counter, number left the park
    params::NetworkParameters #The parameters of the park queueing system
end



############################
#   Event Structs Definitions      #
############################

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



# ########################
# #   Network States       #
# ########################

# using Base: Float64
# # To define the possible states in the Park system

# # Declare the abstract type called state
# abstract type State end

# # before arrival at park
# mutable struct BeforeArrival <: State
# end

# # arrive at park
# mutable struct ArrivePark <: State
#     number_arrive_park::Int
# end

# # queue at station state
# mutable struct QueueState <: State
#     number_in_queue::Int
# end

# # being served at station state
# mutable struct ServeState <: State
#     number_serve::Int
# end

# # moving between stations after served state
# mutable struct ServeMoveState <: State
#     number_moving_after_serve::Int
# end

# # moving between stations after overflowed state
# mutable struct OverflowMoveState <: State
#     number_moving_after_overflow::Int
# end

# # leave park state
# mutable struct LeaveParkState <: State
#     number_leave_park::Int
# end
