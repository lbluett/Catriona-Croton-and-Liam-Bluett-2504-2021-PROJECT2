# Catriona-Croton-and-Liam-Bluett-2504-2021-PROJECT2
https://courses.smp.uq.edu.au/MATH2504/assessment_html/project2.html

There are two modes for the simulation - mode 1 is for the statistics required in plots 1 and 2 and mode 2 for the tracking of individual jobs. To set up the two modes, the function used to plot both modes, and the provided five example scenarios, run the code:

    include("mode1.jl")
    include("mode2.jl")
    include("plot_all.jl")
    include("Provided_Parameters.jl")

There is one main plotting function used for the simulation, and it will result in two png files per scenario: the first file contains the statistics plots for the first mode and will result the plotting of the mean number of items in the total system and the proportion of items that are in orbit (circulating between queues) as a function of 𝜆. The second file will contain the plot output for mode 2, which is the empirical cumulative distribution (ECDF) of the sojourn time of a item through the system, which is varied as a function of 𝜆.

The plotting function used is called *plot_all()* and takes the following mandatory arguments:

    *scenario* - these are the network parameters
    *item name* - the name of the network parameters (e.g. Scenario 1). This must be a string and so enclosed in "".

There are also optional named arguments, which are:

    *stats_lambda_lower_bound* - the lower bound of the 𝜆 to be used in mode 1 with a default of 0.01
    *stats_lambda_upper_bound* - the upper bound of the 𝜆 to be used in the mode 1 with a default of 5.01
    *stats_lambda_step* - the step of the 𝜆 to be used in the mode 1 with a default of 0.2
    *times_lambda_lower_bound* - the lower bound of the 𝜆 to be used in mode 2 with a default of 1.0
    *times_lambda_upper_bound* - the upper bound of the 𝜆 to be used in mode 2 with a default of 5.0
    *times_lambda_step* - the step of the 𝜆 to be used in mode 2 with a default of 1.0
    *xGrid_step* - the step of the grid used for the x axis in the ECDF in mode 2 with a default is 0.1.
    *xGrid_upper* - the upper bound of the grid used for the x axis in the ECDF in mode 2, with a default of 30.0.

The lower bound of the xGrid isn't able to be set; it is 0.0.

There are 5 provided scenarios as examples and these are stored in the Provided_Parameters.jl file.
