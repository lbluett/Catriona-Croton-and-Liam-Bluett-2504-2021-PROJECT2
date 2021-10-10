 # Miscellaneous functions

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

"""
Function to use inverse probability transform for P and Q matrices
    Generates discrete random value given probability vector
"""
# prob vector is the vector of probabilities
# for the park, will be the i'th line from the P or Q matrices
function discrete_inverse_transform_sampling(prob_vector::Array{Float64, 1})
    # randomly generate a probability value between 0 and 1
    prob = rand()
    # then use inverse probability transform to find the category index the probability belongs to
    if prob <= prob_vector[1, ]
        return 1
    end
    else for i in 2:length(prob_vector)
        if(sum(prob_vector[1: (i-1)]) < prob && prob <= sum(prob_vector[1:i]))
            return i
        end
    end
end
