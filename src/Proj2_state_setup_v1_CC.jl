using Base: Float64
# To define the possible states in the Park system

# Declare the abstract type called state
abstract type State end

# queue at station state
mutable struct QueueState <: State
    number_in_queue::Int
end

# being served at station state
mutable struct ServeState <: State
    number_serve::Int
end

# moving between stations after served state
mutable struct ServeMoveState <: State
    number_moving_after_serve::Int
end

# moving between stations after overflowed state
mutable struct OverflowMoveState <: State
    number_moving_after_overflow::Int
end

# leave park state
mutable struct LeaveParkState <: State
    number_leave_park <: State
end

