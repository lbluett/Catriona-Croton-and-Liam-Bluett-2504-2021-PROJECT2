using Distributions
include("Generic_Queue_Framework.jl")

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
    # Perhaps initialising an array of size L to indicate the number of people in each queue.
    
end

#Arrives, goes into random queue based on p_e.
struct ExternalArrivalEvent <: Event
end

"""
A convenience function to make a Gamma distribution with desired rate (inverse of shape) and SCV.
"""
rate_scv_gamma(desired_rate::Float64, desired_scv::Float64) = Gamma(1/desired_scv, desired_scv/desired_rate)

next_arrival_time(s::State) = rand(rate_scv_gamma(s.params.λ, s.params.gamma_scv))

function process_event(time::Float64, state::State, arrival_event::ExternalArrivalEvent)
    state.station_queues
end
