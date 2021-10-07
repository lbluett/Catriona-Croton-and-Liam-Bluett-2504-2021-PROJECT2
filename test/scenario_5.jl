scenario5 = NetworkParameters(  L=20, 
                                gamma_shape = 3.0, 
                                λ = NaN, 
                                η = 4.0, 
                                μ_vector = ones(20),
                                P = zeros(20,20),
                                Q = diagm(3=>ones(19), -19=>ones(3)),                             
                                p_e = vcat(1,zeros(19)),
                                K = fill(5,20))
@show scenario5
