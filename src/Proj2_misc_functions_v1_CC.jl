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
