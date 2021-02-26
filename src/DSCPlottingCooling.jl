using CSV
using DataFrames
using Plots

"""
    PlotDSCCoolingTemp!(seriesPath, temperature, runSpeed = 0.0)

Adds a series of heatflow vs temperature for the cooling region to the current active plot using data from a csv given in the seriesPath variable.

This plot is cropped to the temperature range given (or if only one temperature is given it takes the range between that and the maximum temperature) on the cooling part of the curve. If a value is given for the run speed it will normalise the plot for that speed. Standard plot kwargs are accepted for editing this plot.
"""
function PlotDSCCoolingTemp!(seriesPath, temperature, runSpeed=0.0, binNum=1; kwargs...)
    DF = CSV.File(seriesPath) |> DataFrame

    DF = FilterCooling(DF, temperature)
    DF[:, 2] = DF[:,2] .- DF[end,2]

    plot!(DF[1:binNum:end,5], (runSpeed == 0) ? DF[1:binNum:end,2] : (DF[1:binNum:end,2] / runSpeed),
        xlabel="Temperature (°C)", ylabel=(runSpeed == 0) ? "Heat Flow (mW)" : "Energy (J/(°C/min))",
        size=plotSize; kwargs...)
end

"""
    PlotDSCCoolingTime!(seriesPath, temperature)

Adds a series of heatflow vs time for the cooling region to the current active plot using data from a csv given in the seriesPath variable.

This plot is cropped to the temperature range given (or if only one temperature is given it takes the range between that and the maximum temperature) on the cooling part of the curve. Standard plot kwargs are accepted for editing this plot.
"""
function PlotDSCCoolingTime!(seriesPath, temperature, binNum=1; kwargs...)
    DF = CSV.File(seriesPath) |> DataFrame

    DF = FilterCooling(DF, temperature)
    DF[:, 1] = DF[:,1] .- DF[end,1]
    DF[:, 2] = DF[:,2] .- DF[end,2]

    plot!(DF[1:binNum:end,1] .* 60, DF[1:binNum:end,2],
        xlabel="Time (s)", ylabel="Heat Flow (mW)",
        size=plotSize; kwargs...)
end
