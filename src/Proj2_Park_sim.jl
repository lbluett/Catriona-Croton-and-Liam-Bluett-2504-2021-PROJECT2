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

include("Proj2_state_setup.jl")
include("Proj2_functions.jl")
include("Proj2_structs.jl")
include("Proj2_event_setup.jl")
include("Proj2_process_events.jl")
include("Proj2_sim_function.jl")

#=
include("src/Proj2_functions.jl")
include("src/Proj2_structs.jl")
include("src/Proj2_event_setup.jl")
include("src/Proj2_state_setup.jl")
include("src/Proj2_process_events.jl")
include("src/Proj2_sim_function.jl")
=#

