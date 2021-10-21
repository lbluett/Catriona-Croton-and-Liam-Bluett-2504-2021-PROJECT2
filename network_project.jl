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

include("network_structs.jl")
include("network_functions.jl")
include("process_events.jl")
