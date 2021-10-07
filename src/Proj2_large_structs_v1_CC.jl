############################
#   Overview structs       #
############################

# struct for general parameters for the park for each scenario

# Code from Project 2 sheet
@with_kw struct NetworkParameters
    L::Int #The number of queues in the park
    gamma_shape::Float64 #This is constant for all scenarios at 3.0
    λ::Float64 # external arrival rate to the park, undefined for the scenarios since it is varied
    η::Float64 # move rate between stations, assumed constant for all scenarios at 4.0
    μ_vector::Vector{Float64} #service rates for each of the queues
    P::Matrix{Float64} #routing matrix
    Q::Matrix{Float64} #overflow matrix
    p_e::Vector{Float64} #external arrival distribution
    K::Vector{Int} # vector of buffer capacities fro each queue, -1 means infinity 
end

# struct for network states
mutable struct NetworkState <: State
    queues::Vector{Int} #A vector which indicates the number of customers in each queue
    move::Int # number moving between queues
    overflow::Int # number overflowed
    left::Int # number left the park
    params::NetworkParameters #The parameters of the park queueing system
end

# struct for queue as each one has different queue capacity and mean service times (????)
# not mutable as will be fixed for that queue for that simulation (?????)
struct queue
    q::Int  # queue id
    number_init::Int
    μ::Float64   # rate of service
    K::Int       # capacity
end

