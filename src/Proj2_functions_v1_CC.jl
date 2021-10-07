# General functions

next_park_arrival_time(s::State) = rand(rate_scv_gamma(s.params.λ, s.params.gamma_shape))
next_service_time(s::State, q::Int) = rand(rate_scv_gamma(s.params.μ_array[q], s.params.gamma_shape));