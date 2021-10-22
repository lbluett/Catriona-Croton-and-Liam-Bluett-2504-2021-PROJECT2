"""
Test drawing from initial arrival.
"""
function arrival_distribution_test(N::Int = 5, p_e::Vector{Float64} = [0.2, 0.2, 0.2, 0.2, 0.2])
    @assert sum(p_e) == 1
    vec = zeros(N)
    for _ in 1:10^7   
    q = external_arrival_function(N, p_e)
    vec[q] += 1
    end

    vec = vec / sum(vec)
    #map(item -> round(item, digits = 3), vec) 
    # Useful if we want to round, as fun as the lambda expression is, it's cooler if it doesn't round as that implies more accuracy.

    if isapprox(vec, p_e; atol = 0.001) # Must be 0.1% different to pass.
        println("PASSED: arrival_distribution_test PASSED with simulated probabilties: ", vec)
    else
        println("FAILED: arrival_distribution_test")
    end
end


function arrival_distribution_test2(N::Int = 5, p_e::Vector{Float64} = [0.2, 0, 0, 0.6, 0.2])
    @assert sum(p_e) == 1
    vec = zeros(N)
    for _ in 1:10^7   
    q = external_arrival_function(N, p_e)
    vec[q] += 1
    end

    vec = vec / sum(vec)
    #map(item -> round(item, digits = 3), vec)

    if isapprox(vec, p_e; atol = 0.01) # Must be 0.1% different to pass.
        println("PASSED: arrival_distribution_test PASSED with simulated probabilties: ", vec)
    else
        println("FAILED: arrival_distribution_test")
    end
end

default_matrix = [0   0.5 0.5 0   0;
                0   0   0   1   0;
                0   0   0   0   1;
                0.5 0   0   0   0;
                0.2 0.2 0.2 0.2 0.2]

function routing_matrix_test(L::Int = 5, P::Matrix{Float64} = default_matrix)
    @assert L == size(P)[1]
    matrix = zeros(L,L+1) # Preallocate, save time.
    print("Loading")
    for q in 1:L
        for _ in 1:10^7
            a = routing_function(L, q, P)
            matrix[q,a] += 1
        end
        matrix[q,:] = matrix[q,:]/sum(matrix[q, :]) # Get the proportion of each element in the row.
        print(".")
        
    end
    println()
    #matrix = matrix / sum(matrix)
    
    if isapprox(matrix[1:L,1:L], P, atol = 0.01)
        println("PASSED: routing_matrix_test PASSED with simulated probabilties: ")
        display(matrix)
    else
        display(matrix)
        println("FAILED: routing_matrix_test")
    end

end


default_matrix_overflow = [0 0.5 0;
                            0 0 0.5;
                            0.5 0 0]

function overflow_matrix_test(L::Int = 3, P::Matrix{Float64} = default_matrix_overflow)
    @assert L == size(P)[1]
    matrix = zeros(L,L+1) # Preallocate, save time.
    print("Loading")
    for q in 1:L
        for _ in 1:10^7
            a = overflow_function(L, q, P)
            matrix[q,a] += 1
        end
        matrix[q,:] = matrix[q,:]/sum(matrix[q, :]) # Get the proportion of each element in the row.
        print(".")
        
    end
    println()
    #matrix = matrix / sum(matrix)
    
    if isapprox(matrix[1:L,1:L], P, atol = 0.01)
        println("PASSED: overflow_matrix_test PASSED with simulated probabilties: ")
        display(matrix)
    else
        println("FAILED: overflow_matrix_test")
        display(matrix)
    end

end


