############################
#   Overview structs       #
############################

# struct for general parameters for the park for each scenario

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
    move::Int # Counter, number moving between queues
    overflow::Int # Counter, number overflowed
    left::Int # Counter, number left the park
    params::NetworkParameters #The parameters of the park queueing system
end
