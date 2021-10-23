#######################################
#     Functions for park simulations  #
#######################################


### Miscellaneous functions

"""
 Function to make a Gamma distribution with desired rate (inverse of shape) and SCV
"""
rate_scv_gamma(desired_rate::Float64, desired_scv::Float64) = Gamma(1/desired_scv, desired_scv/desired_rate)
# for this simulation, the SCV will be 3


"""
Function to stich_steps of a discrete event curve
"""
function stich_steps(epochs, values)
    n = length(epochs)
    new_epochs  = [epochs[1]]
    new_values = [values[1]]
    for i in 2:n
        push!(new_epochs, epochs[i])
        push!(new_values, values[i-1])
        push!(new_epochs, epochs[i])
        push!(new_values, values[i])
    end
    return (new_epochs, new_values)
end


### Functions for times
next_park_arrival_time(s::State) = rand(rate_scv_gamma(s.params.λ, s.params.gamma_scv))
next_service_time(s::State, q::Int) = rand(rate_scv_gamma(s.params.μ_vector[q], s.params.gamma_scv))
moving_time(s::State) = rand(rate_scv_gamma(s.params.η, s.params.gamma_scv))


### Helper functions
# function to return which queue to join when first arrive at the park
external_arrival_function(L::Int, p_e::Vector{Float64}) = sample(1:L, weights(p_e))

# function to return which queue to join or if leave when finish service event, according to P matrix
# depends on the queue that are leaving (q) and if return L+1, then must exit the park
routing_function(L::Int, q::Int, P::Matrix{Float64}) = sample(1:L+1, weights(push!(P[q, :], 1 - sum(P[q, :]))))

# function to return which queue to join or if leave when overflow, according to Q matrix
overflow_function(L::Int, q::Int, Q::Matrix{Float64}) = sample(1:L+1, weights(push!(Q[q, :], 1 - sum(Q[q, :]))))

#= DELETE 
"""
 Use Mersenne Twister as RNG algorithm
    - will allow changes in λ and scenarios to be more apparent
"""
rng = MersenneTwister(27)
=#
