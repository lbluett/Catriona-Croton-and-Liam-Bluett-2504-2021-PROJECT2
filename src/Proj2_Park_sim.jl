#############################################################################
#############################################################################
#
# This is the main project file for park simulation setup
#                                                                               
#############################################################################
#############################################################################

using DataStructures, Distributions, StatsBase, Random, Plots

import Base: isless

include("src/Proj2_functions_v1_CC.jl")
include("src/Proj2_misc_functions_v1_CC.jl")
include("src/Proj2_large_structs_v1_CC.jl")
include("src/Proj2_event_setup_v1_CC.jl")
include("src/Proj2_state_setup_v1_CC.jl")
include("src/Proj2_process_events_v1_CC.jl")
include("src/Proj2_sim_function_v1_CC.jl")