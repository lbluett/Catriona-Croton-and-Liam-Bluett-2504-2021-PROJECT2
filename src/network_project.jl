#############################################################################
#############################################################################
#
# This is the main project file for park simulation setup
#                                                                               
#############################################################################
#############################################################################

using DataStructures, Distributions, StatsBase, Random, Plots, Parameters, LinearAlgebra
using Base: Float64
import Base: isless

#include("network_states.jl") -- Merged -> network_structs 
include("network_structs.jl")
#include("network_events.jl") -- Merged -> network_structs
include("network_functions.jl")
include("process_events.jl")
#include("run_simulation.jl")

#=
include("src/Proj2_functions.jl")
include("src/Proj2_structs.jl")
include("src/Proj2_event_setup.jl")
include("src/Proj2_state_setup.jl")
include("src/Proj2_process_events.jl")
include("src/Proj2_sim_function.jl")
=#

