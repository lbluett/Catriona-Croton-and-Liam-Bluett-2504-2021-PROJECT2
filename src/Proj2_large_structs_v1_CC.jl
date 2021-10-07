############################
#   Overview structs       #
############################

# struct for general parameters for the park for each scenario
struct NetworkParameters
    L::Int #The number of queues in the park
    gamma_shape::Float64 # shape value for gamma distribution
    λ::Float64 # external arrival rate to the park
    η::Float64 # move rate between stations
    μ_vector::Vector{Float64} # list of the rates of service in each of the queues
    p_matrix::Array{Float64} # routing matrix
    q_matrix::Array{Float64} # overflow matrix
    p_e::Vector{Float64} # probability vector for external arrivals
    K::Vector{Int} # vector of buffer capacities for each queue
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

