# First scenario
# sequential (tandem) queues, as q1 goes to q2 to q3
# if overflows, leaves the system
# NOTE: this result should be the same as using the tandem code from Prac F - use to check

scenario1 = NetworkParameters(  L=3, 
                                gamma_shape = 3.0, 
                                λ = NaN, 
                                η = 4.0, 
                                μ_vector = ones(3),
                                P = [0 1.0 0;
                                    0 0 1.0;
                                    0 0 0],
                                Q = zeros(3,3),
                                p_e = [1.0, 0, 0],
                                K = fill(5,3))
@show scenario1
