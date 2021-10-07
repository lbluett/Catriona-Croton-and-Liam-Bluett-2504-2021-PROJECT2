scenario4 = NetworkParameters(  L=5, 
                                gamma_shape = 3.0, 
                                λ = NaN, 
                                η = 4.0, 
                                μ_vector = collect(5:-1:1),
                                P = [0   0.5 0.5 0   0;
                                     0   0   0   1   0;
                                     0   0   0   0   1;
                                     0.5 0   0   0   0;
                                     0.2 0.2 0.2 0.2 0.2],
                                Q = [0 0 0 0 0;
                                     1 0 0 0 0;
                                     1 0 0 0 0;
                                     1 0 0 0 0;
                                     1 0 0 0 0],                             
                                p_e = [0.2, 0.2, 0, 0, 0.6],
                                K = [-1, -1, 10, 10, 10])
@show scenario4
