# Parameters for scenarios 1, 2, 3, 4, 5 for Project 2
#For convenience they are stored in a struct, NetworkParameters

############################
scenario1 = NetworkParameters(  L=3, 
                                gamma_scv = 3.0, 
                                λ = 0.75, # need to vary this
                                η = 4.0, 
                                μ_vector = ones(3),
                                P = [0 1.0 0;
                                    0 0 1.0;
                                    0 0 0],
                                Q = zeros(3,3),
                                p_e = [1.0, 0, 0],
                                K = fill(5,3))
#@show scenario1

############################
scenario2 = NetworkParameters(  L=3, 
                                gamma_scv = 3.0, 
                                λ = 0.75, # need to vary this
                                η = 4.0, 
                                μ_vector = ones(3),
                                P = [0 1.0 0;
                                    0 0 1.0;
                                    0.5 0 0],
                                Q = zeros(3,3),
                                p_e = [1.0, 0, 0],
                                K = fill(5,3))
#@show scenario2

############################
scenario3 = NetworkParameters(  L=3, 
                                gamma_scv = 3.0, 
                                λ = 0.75, # need to vary this
                                η = 4.0, 
                                μ_vector = ones(3),
                                P = [0 1.0 0;
                                    0 0 1.0;
                                    0.5 0 0],
                                Q = [0 0.5 0;
                                     0 0 0.5;
                                     0.5 0 0],
                                p_e = [1.0, 0, 0],
                                K = fill(5,3))
#@show scenario3

############################
scenario4 = NetworkParameters(  L=5, 
                                gamma_scv = 3.0, 
                                λ = 0.75, # need to vary this
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
#@show scenario4

############################
scenario5 = NetworkParameters(  L=20, 
                                gamma_scv = 3.0, 
                                λ = 0.75,                  # need to vary this
                                η = 4.0, 
                                μ_vector = ones(20),
                                P = zeros(20,20),
                                Q = diagm(3=>0.8*ones(17), -17=>ones(3)), #Fixed on Oct 17                           
                                p_e = vcat(1,zeros(19)),
                                K = fill(5,20))
#@show scenario5